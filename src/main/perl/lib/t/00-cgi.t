#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::Output;
use Cwd;
use Bedrock::Constants qw(:chars);
use Data::Dumper;
use English qw(-no_match_vars);

BEGIN {
  $ENV{GATEWAY_INTERFACE} = 'CGI/1.1';

  use Bedrock::BedrockCGI;

  Bedrock::CGI->import(qw(:all));
}

########################################################################
# print
########################################################################
subtest 'print' => sub {
  my $cgi = Bedrock::CGI->new;

  stdout_like(
    sub {
      $cgi->print('<p>test</p>');
      $cgi->flush_output;
    },
    qr/\AContent-type:\s+text\/html\r\n\r\n<p>test<\/p>\z/xsmi,
    'print',
  );
};

########################################################################
# output
########################################################################
subtest 'output' => sub {
  my $output = $EMPTY;

  open my $fh, '>', \$output
    or BAIL_OUT('ERROR: could not open scalar ref for reading.');

  $fh->autoflush;

  my $cgi = Bedrock::CGI->new( output_handle => $fh, autoflush => 1 );

  my $html = element( element_start( div => style( $main::FONT_SIZE, $PURPLE, $BOLD, $MARGIN ) ), 'foo' );
  $cgi->print("$html\n");

  my $pre = element( pre => 'foo' );
  $html = "$html\n$pre\n";

  $cgi->print( sprintf "%s\n", $pre );

  $cgi->flush_output;

  $fh->close;

  like( $output, qr/\AContent.*<div.*<\/pre>\n\z/xsm, 'content' );
};

done_testing;

1;
