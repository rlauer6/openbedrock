#!/usr/bin/env perl

use strict;
use warnings;

BEGIN {
  use lib qw(.);
}

use English qw(-no_match_vars);
use Data::Dumper;
use Test::More tests => 5;

BEGIN {
  use_ok('BLM::DBHandler');
}

like( $BLM::DBHandler::VERSION, qr/\A[\d.]+\z/xsm, 'version' );

SKIP: {
  skip 'no DBI_USER set', 3
    if !$ENV{DBI_USER};

  BLM::DBHandler->import(qw(easy_connect is_dbi));

  my $dbi = eval {

    return easy_connect(
      user     => $ENV{DBI_USER},
      password => $ENV{DBI_PASS},
      host     => $ENV{DBI_HOST} // 'localhost',
    );
  };

  ok( $dbi, 'easy_connect()' )
    or diag($EVAL_ERROR);

  ok( is_dbi($dbi), 'easy_connect() returns a DBI object' )
    or diag( Dumper( [ dbi => $dbi ] ) );

  $dbi->disconnect;

  $dbi = eval {

    BLM::DBHandler->easy_connect(
      user     => $ENV{DBI_USER},
      password => $ENV{DBI_PASS},
      host     => $ENV{DBI_HOST} // 'localhost',
    );
  };

  ok( is_dbi($dbi) && !$EVAL_ERROR, 'BLM::DBHandler->easy_connect()' );
}

1;
