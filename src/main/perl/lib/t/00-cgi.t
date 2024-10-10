#!/usr/bin/env perl

use strict;
use warnings;

use lib qw{.};

use Test::More tests => 3;
use Test::Output;
use Cwd;
use Bedrock::Constants qw(:chars);
use Data::Dumper;
use English qw(-no_match_vars);

use IO::Scalar;

BEGIN {
  use Bedrock::BedrockCGI;

  Bedrock::CGI->import(qw(:all));
}

my $cgi = Bedrock::CGI->new;

stdout_like(
  sub {
    $cgi->print('<p>test</p>');
    $cgi->flush_output;
  },
  qr/\AContent-type:\s+text\/html\r\n\r\n<p>test<\/p>\z/xsmi,
  'print',
);

my $output = $EMPTY;

my $fh = IO::Scalar->new( \$output );

$cgi = Bedrock::CGI->new( output_handle => $fh );

$cgi->print( sprintf "%s\n",
  element( $cgi->element_start( 'div', $cgi->style( $main::FONT_SIZE, $PURPLE, $BOLD, $MARGIN ) ), 'foo' ) );

$cgi->print( sprintf "%s\n", $cgi->element( 'pre', 'foo' ) );
$cgi->flush_output;

$fh->close;

ok( length $output, 'captured output' );

like( $output, qr/\AContent-type:\s+text\/html\r\n\r\n<.*>\n\z/xsmi, 'content' );

1;
