#!/usr/bin/env perl

use strict;
use warnings;

BEGIN {
  use lib qw(.);
}

package Test::Logger;

use Role::Tiny::With;
with 'Bedrock::Logger';

use parent qw(Exporter);
our @EXPORT = qw(txt2level);

########################################################################
sub new {
########################################################################
  return bless {}, shift;
}

package main;

use English qw(-no_match_vars);
use Data::Dumper;
use Carp;
use Carp::Always;
use Test::More;
use Test::Output;

use_ok('Bedrock::Logger');

my $self;
my $logger;

########################################################################
subtest 'get a default logger' => sub {
########################################################################
  Test::Logger->import('txt2level');

  $self = Test::Logger->new;

  $logger = $self->get_logger;

  isa_ok( $logger, 'Log::Log4perl::Logger', 'got a logger' )
    or do {
    diag( Dumper( [ logger => $logger ] ) );
    BAIL_OUT('could not create a logger');
    };
};

########################################################################
subtest 'log a message at error level' => sub {
########################################################################
  stderr_like(
    sub {
      $logger->error('log message');
    },
    qr/log\smessage/xsm,
    'logging at default level (error)'
  );
};

########################################################################
subtest 'set log level' => sub {
########################################################################
  stderr_isnt(
    sub {
      $logger->info('test');
    },
    qr/test/xsm,
    'suppress logging at info level'
  );

  my $level = $self->txt2level('info');

  is( $level, 'error', 'txt2level returns default level (error)' );

  stderr_like(
    sub {
      $logger->info('info message');
    },
    qr/info\smessage/xsm,
    'logging at info level'
  );

  eval { return $self->txt2level('foo'); };

  like( $EVAL_ERROR, qr/invalid\slevel/xsm, 'trap invalid levels' );

  my $current_level = eval { return txt2level( $logger, 'debug' ); };

  ok( !$EVAL_ERROR && $current_level eq 'info', 'call with logger?' )
    or diag(
    Dumper(
      [ error         => $EVAL_ERROR,
        current_level => $current_level
      ]
    )
    );
};

done_testing;

1;
