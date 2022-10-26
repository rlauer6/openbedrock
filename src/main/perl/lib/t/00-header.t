########################################################################
package Faux::Context;

use strict;
use warnings;
use List::Util qw{pairs};
use Bedrock::Constants qw{:chars};
use Data::Dumper;

########################################################################
sub new {
########################################################################
  my ( $class, $outhandle ) = @_;

  my $self = bless {}, $class;

  $self->request( bless {}, 'Faux::Handler' );
  $self->{outhandle} = $outhandle;

  return $self;
}

########################################################################
sub cgi_header_in {
########################################################################
  require CGI;

  my $cgi = CGI->new;

  my %http_vars = map { $_ => $cgi->http($_) } $cgi->http();

  foreach my $p ( pairs %http_vars ) {
    my ( $key, $value ) = @{$p};
    $key =~ s/^HTTP_//xsm;

    $http_vars{$key} = $value;

    delete $http_vars{ 'HTTP_' . $key };
  }

  return %http_vars;
}

########################################################################
sub send_http_header {
########################################################################
  my ($self) = @_;

  if ( $self->{headers} ) {
    $self->print( $self->{headers}, "\r\n" );
  }

  $self->{headers} = undef;

  return;
}

########################################################################
sub cgi_header_out {
########################################################################
  my ( $self, @headers ) = @_;

  $self->{headers} //= $EMPTY;

  if (@headers) {
    foreach my $p ( pairs @headers ) {
      my ( $header, $value ) = @{$p};

      $self->{headers} .= "$header: $value\r\n";
    }
  }

  return $self->{headers};
}

########################################################################
sub getCookieValue { }
########################################################################

########################################################################
sub request { return _set( @_, 'request' ) };  ## no critic (RequireArgUnpacking)
########################################################################

########################################################################
sub _set {
########################################################################
  my ( $self, @args ) = @_;

  if ( @args > 1 ) {
    return $self->{ $args[1] } = $args[0];
  }
  else {
    return $self->{ $args[0] };
  }
}

########################################################################
sub print {  ## no critic (ProhibitBuiltinHomonyms)
########################################################################
  my ( $self, @args ) = @_;

  return $self->{outhandle}->print(@args);
}

########################################################################
sub close {  ## no critic (ProhibitBuiltinHomonyms, ProhibitAmbiguousNames)
########################################################################
  my ( $self, @args ) = @_;

  return $self->{outhandle}->close(@args);
}

########################################################################
package main;

use strict;
use warnings;

use lib qw{.};

use Data::Dumper;
use Test::More tests => 9;
use IO::Scalar;

use_ok('BLM::Startup::Header');

########################################################################
sub bind_module {
########################################################################
  my ($ctx) = @_;

  my $module = q{BLM::Startup::Header};

  my $obj = bless {}, $module;

  tie %{$obj}, $module, $ctx;  ## no critic (ProhibitTies)

  return $obj;
}

########################################################################
{
  ## no critic (RequireArgUnpacking, ProhibitNoStrict)
  no strict 'refs';

  *{'Faux::Handler::content_type'} = sub { return 'text/html'; };
}
########################################################################

my $output = q{};

my $ctx = Faux::Context->new( IO::Scalar->new( \$output ) );

my $header;

subtest 'bind' => sub {
  $header = bind_module($ctx);

  isa_ok( $header, 'BLM::Startup::Header' )
    or BAIL_OUT('could not bind BLM::Startup::Header');
};

subtest 'content_type()' => sub {
  $header->content_type('text/plain');

  $header->print_header($ctx);

  like( $output, qr/^Content-type:\stext\/plain\r\n\r\n\z/xsm, 'text/plain' )
    or diag( Dumper( [$output] ) );
};

subtest 'set' => sub {
  $header->set( 'X-AMZ-TOKEN', 'foo' );
  $output = q{};

  $header->print_header($ctx);
  like( $output, qr/X-AMZ-TOKEN:\sfoo\r\n\r\n\z/xsm, 'set' )
    or diag( Dumper( [$output] ) );
};

subtest 'see_other' => sub {
  $output = q{};

  $header->see_other('/foo');

  $header->print_header($ctx);
  like( $output,
    qr/\AStatus:\s303\sSee\sOther\r\nLocation:\s\/foo\r\n\r\n\z/xsm )
    or diag( Dumper( [$output] ) );
};

subtest 'location' => sub {
  $output = q{};

  $header->location('/foo');

  $header->print_header($ctx);
  like( $output, qr/\AStatus:\s302\sFound\r\nLocation:\s\/foo\r\n\r\n\z/xsm )
    or diag( Dumper( [$output] ) );
};

subtest 'no_cache' => sub {
  $output = q{};

  $header->no_cache('/foo');

  $header->print_header($ctx);
  my @headers = sort split /\r\n/xsm, $output;

  is( $headers[0], 'Cache-control: no-cache', 'Cache-control: no-cache' )
    or diag( Dumper( [ \@headers ] ) );

  is( $headers[1], 'Cache-control: no-store', 'Cache-control: no-store' )
    or diag( Dumper( [ \@headers ] ) );

  is( $headers[2], 'Pragma: no-cache', 'Pragma: no-cache' )
    or diag( Dumper( [ \@headers ] ) );

};

subtest 'build_get_url()' => sub {
  ok( $header->build_get_url( 'name', 'key', 'value' ), 'name?key=value' );

  ok( $header->build_get_url( 'name', [ 'key', 'value' ] ),
    'name?key=value' );

  ok( $header->build_get_url( 'name', { key => 'value' } ),
    'name?key=value' );
};

subtest 'Authorization' => sub {
  require MIME::Base64;

  $ENV{HTTP_Authorization}
    = 'Basic ' . MIME::Base64::encode_base64('fred:W1lma');

  $ENV{HTTP_AUTHORIZATION} = $ENV{HTTP_Authorization};

  $header = bind_module($ctx);

  is( $header->auth_user, 'fred', 'auth_user' )
    or diag( Dumper( [ $header, tied %{$header} ] ) );

  is( $header->auth_passwd, 'W1lma', 'auth_passwd' )
    or diag( Dumper( [ $header, tied %{$header} ] ) );
};

1;

__END__
