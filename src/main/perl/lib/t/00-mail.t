#!/usr/bin/env perl

use strict;
use warnings;

use lib qw{.};

use Bedrock::Test::Utils qw{:all};

use Data::Dumper;
use English qw{-no_match_vars};
use Test::More;

our %TESTS = fetch_test_descriptions(*DATA);

########################################################################

plan tests => 1 + keys %TESTS;

use_ok('BLM::Mail');

########################################################################
subtest '_set_get' => sub {
########################################################################
  my $mailer = BLM::Mail->new;

  $mailer->smtp_server('example.com');

  is( $mailer->smtp_server, 'example.com', '_set_get()' )
    or BAIL_OUT('setter/getter not working');
};

########################################################################
subtest 'sendmail' => sub {
########################################################################
  SKIP: {

    my $to   = $ENV{TEST_SENDMAIL_TO};
    my $from = $ENV{TEST_SENDMAIL_FROM};

    skip 'sendmail disabled', 1 if !$to || !$from;

    my $mailer = BLM::Mail->new;

    eval {
      $mailer->to($to);
      $mailer->subject('test');
      $mailer->from($from);
      $mailer->content_type('text/html');
      $mailer->message('<b>Hello World!</b>');
      $mailer->sendmail;
    };

    ok( !$EVAL_ERROR, 'sendmail' )
      or do {
      diag( Dumper( [ $mailer, $EVAL_ERROR ] ) );
      BAIL_OUT('could not end mail');
      };
  }
};

1;

__DATA__
_set_get_ => test setters/getters
sendmail => testing sending mail
  
END_OF_PLAN  
