#!/usr/bin/env perl

use strict;
use warnings;

use Bedrock;
use Test::More;
use Data::Dumper;
use English qw(-no_match_vars);
use IO::Scalar;
use Cwd qw(getcwd);

use_ok 'Bedrock::Apache::Request::CGI';

my $r;
my $buffer = q{};
my $fh     = IO::Scalar->new( \$buffer );

local $ENV{PATH_INFO}       = $PROGRAM_NAME;
local $ENV{PATH_TRANSLATED} = sprintf '%s/%s', getcwd, $PROGRAM_NAME;
local $ENV{REQUEST_METHOD}  = 'GET';

########################################################################
subtest 'new' => sub {
########################################################################
  $r = Apache::Request::CGI->new( output_handle => $fh );

  isa_ok( $r, 'Apache::Request::CGI' );
};

########################################################################
subtest 'headers' => sub {
########################################################################
  $r->headers_out( 'Content-length', 100 );
  $r->headers_out( 'Accept-Ranges',  'bytes' );
  $r->headers_out( 'Content-type',   'text/plain' );

  $r->send_http_header;

  my @headers = grep {$_} sort split /\r\n/xsm, $buffer;

  is_deeply( \@headers, [ sort 'Content-type: text/plain', 'Content-length: 100', 'Accept-Ranges: bytes' ] );

};

########################################################################
subtest 'method' => sub {
########################################################################
  is( $r->method, 'GET', 'method' );
};

########################################################################
subtest 'filename' => sub {
########################################################################
  is( $r->filename, sprintf( '%s/%s', getcwd, $PROGRAM_NAME ), 'filename' );
};

########################################################################
subtest 'uri' => sub {
########################################################################
  is( $r->uri, $PROGRAM_NAME, 'uri' );
};

done_testing;

1;
