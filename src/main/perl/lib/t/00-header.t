use strict;
use warnings;

use Bedrock::Test::FauxContext qw(bind_module);
use Data::Dumper;
use Test::More;
use IO::Scalar;

# FIX: Simulate a CGI environment so Header.pm knows to print
$ENV{GATEWAY_INTERFACE} = 'CGI/1.1';

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

  like( "@headers", qr/Location: \/foo/sm, 'Location: /foo' )
    or diag(
    Dumper(
      [ headers => \@headers,
        output  => $output
      ]
    )
    );

  like( "@headers", qr/Status: 303 See Other/sm, 'Status: 303 See Other' )
    or diag(
    Dumper(
      [ headers => \@headers,
        output  => $output
      ]
    )
    );
};

########################################################################
subtest 'location' => sub {
########################################################################
  $output = q{};

  $header->location('/foo');

  $header->print_header($ctx);
  my @headers = sort grep {$_} split /\r\n/xsm, $output;

  like( "@headers", qr/Location: \/foo/sm, 'Location: /foo' )
    or diag(
    Dumper(
      [ headers => "@headers",
        output  => $output
      ]
    )
    );

  like( "@headers", qr/Status: 302 Found/sm, 'Status: 302 Found' )
    or diag(
    Dumper(
      [ headers => "@headers",
        output  => $output
      ]
    )
    );
};

########################################################################
subtest 'no_cache' => sub {
########################################################################
  $output = q{};

  $header->no_cache('/foo');

  $header->print_header($ctx);
  my @headers = sort grep { !/Content/xsm } split /\r\n/xsm, $output;

  like( "@headers", qr/Cache-control: no-cache/sm, 'Cache-control: no-cache' )
    or diag( Dumper( [ \@headers ] ) );

  like( "@headers", qr/Cache-control: no-store/sm, 'Cache-control: no-store' )
    or diag( Dumper( [ \@headers ] ) );

  like( "@headers", qr/Pragma: no-cache/sm, 'Pragma: no-cache' )
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
