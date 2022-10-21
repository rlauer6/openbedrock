########################################################################
package Faux::Context;

use strict;
use warnings;

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
sub cgi_header_in    { }
sub send_http_header { }
sub getCookieValue   { }
sub cgi_header_out   { }
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

use strict;
use warnings;

use lib qw{.};

use Data::Dumper;
use Test::More tests => 4;
use IO::Scalar;

use_ok('BLM::Startup::Header');

sub bind_module {
  my ($ctx) = @_;

  my $module = q{BLM::Startup::Header};

  my $obj = bless {}, $module;

  return tie %{$obj}, $module, $ctx;  ## no critic (ProhibitTies)
}

{
  ## no critic (RequireArgUnpacking, ProhibitNoStrict)
  no strict 'refs';

  *{'Faux::Handler::content_type'} = sub { return 'text/html'; };
}

my $output = q{};

my $ctx = Faux::Context->new( IO::Scalar->new( \$output ) );

my $header = bind_module($ctx);

$header->content_type('text/plain');
$header->print_header($ctx);

ok( $header->build_get_url( 'name', 'key', 'value' ), 'name?key=value' );

ok( $header->build_get_url( 'name', [ 'key', 'value' ] ), 'name?key=value' );

ok( $header->build_get_url( 'name', { key => 'value' } ), 'name?key=value' );

1;

__END__
