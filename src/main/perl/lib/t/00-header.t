use strict;
use warnings;

use Bedrock::Test::FauxContext qw(bind_module);
use Data::Dumper;
use Test::More;
use IO::Scalar;

use_ok('BLM::Startup::Header');

my $output = q{};

my $ctx = Bedrock::Test::FauxContext->new( outhandle => IO::Scalar->new( \$output ) );

my $header;

########################################################################
subtest 'bind' => sub {
########################################################################
  $header = bind_module( $ctx, {}, 'BLM::Startup::Header' );

  isa_ok( $header, 'BLM::Startup::Header' )
    or BAIL_OUT('could not bind BLM::Startup::Header');
};

########################################################################
subtest 'content_type()' => sub {
########################################################################
  $header->content_type('text/plain');

  $header->print_header($ctx);

  like( $output, qr/^Content-type:\stext\/plain\r\n\r\n\z/xsm, 'text/plain' )
    or diag( Dumper( [ output => $output ] ) );
};

########################################################################
subtest 'set' => sub {
########################################################################
  $header->set( 'X-AMZ-TOKEN', 'foo' );
  $output = q{};

  $header->print_header($ctx);

  like( $output, qr/X-AMZ-TOKEN:\sfoo/xsm, 'set' )
    or diag( Dumper( [$output] ) );
};

########################################################################
subtest 'see_other' => sub {
########################################################################
  $output = q{};

  $header->see_other('/foo');

  $header->print_header($ctx);
  my @headers = sort grep {$_} split /\r\n/xsm, $output;

  is( $headers[1], 'Location: /foo' )
    or diag( Dumper( [$output] ) );

  is( $headers[2], 'Status: 303 See Other' )
    or diag( Dumper( [$output] ) );
};

########################################################################
subtest 'location' => sub {
########################################################################
  $output = q{};

  $header->location('/foo');

  $header->print_header($ctx);
  my @headers = sort grep {$_} split /\r\n/xsm, $output;

  is( $headers[1], 'Location: /foo' )
    or diag( Dumper( [$output] ) );

  is( $headers[2], 'Status: 302 Found' )
    or diag( Dumper( [$output] ) );
};

########################################################################
subtest 'no_cache' => sub {
########################################################################
  $output = q{};

  $header->no_cache('/foo');

  $header->print_header($ctx);
  my @headers = sort grep { !/Content/xsm } split /\r\n/xsm, $output;

  is( $headers[0], 'Cache-control: no-cache', 'Cache-control: no-cache' )
    or diag( Dumper( [ \@headers ] ) );

  is( $headers[1], 'Cache-control: no-store', 'Cache-control: no-store' )
    or diag( Dumper( [ \@headers ] ) );

  is( $headers[2], 'Pragma: no-cache', 'Pragma: no-cache' )
    or diag( Dumper( [ \@headers ] ) );

};

########################################################################
subtest 'build_get_url()' => sub {
########################################################################
  ok( $header->build_get_url( 'name', 'key', 'value' ), 'name?key=value' );

  ok( $header->build_get_url( 'name', [ 'key', 'value' ] ), 'name?key=value' );

  ok( $header->build_get_url( 'name', { key => 'value' } ), 'name?key=value' );
};

########################################################################
subtest 'Authorization' => sub {
########################################################################
  require MIME::Base64;

  local $ENV{HTTP_Authorization} = 'Basic ' . MIME::Base64::encode_base64('fred:W1lma');

  local $ENV{HTTP_AUTHORIZATION} = $ENV{HTTP_Authorization};

  $header = bind_module( $ctx, {}, 'BLM::Startup::Header' );

  is( $header->auth_user, 'fred', 'auth_user' )
    or diag( Dumper( [ $header, tied %{$header} ] ) );

  is( $header->auth_passwd, 'W1lma', 'auth_passwd' )
    or diag( Dumper( [ $header, tied %{$header} ] ) );
};

done_testing;

1;

__END__
