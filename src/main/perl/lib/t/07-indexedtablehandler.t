#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;

use DBI;
use Data::Dumper;
use English qw{-no_match_vars};

########################################################################
require 't/db-setup.pl';

my $dbi = eval {
  my $dbh = connect_db();

  create_db($dbh);

  return $dbh;
};

diag($EVAL_ERROR);

if ( $EVAL_ERROR || !$dbi ) {
  plan skip_all => 'could not create database';

  diag($EVAL_ERROR);
}
else {
  plan tests => 2;
}

use_ok('BLM::IndexedTableHandler')
  or BAIL_OUT($EVAL_ERROR);

########################################################################

my $ith;

#create table foo (
# id             int auto_increment primary key,
# name           varchar(100) not null default '',
# foo            varchar(100) not null,
# bar_phone      varchar(10) not null default '',
# colors         enum('red', 'green', 'blue'),
# expires_time   timestamp,
# expires_date   date,
# active         boolean

########################################################################
subtest 'get_count' => sub {
########################################################################
  $ith
    = eval { return BLM::IndexedTableHandler->new( $dbi, 0, undef, 'foo' ); };

  isa_ok( $ith, 'BLM::IndexedTableHandler' )
    or BAIL_OUT($EVAL_ERROR);

  my @colors = qw(red green blue);

  for (0..9) {
    $ith->set(id => 0,
              name => (qw{ foo boo buz biz})[int rand 4 ],
              foo => (qw{buz biz})[int rand 2 ],
              active => $_ % 2,
              bar_phone => q{},
              colors => $colors[int rand 3],
            );
    $ith->save();
  }
  
  diag('active records is ' . $ith->get_count( 1, active => 1));

  diag('records ' . $ith->get_count());

  diag('active and blue = ', $ith->get_count( 1, active => 1, 1, colors => 'blue'));
  
  diag('not active and blue = ', $ith->get_count(1,  active => 0, 1, colors => 'blue'));
  
};


END {
  eval {
    if ( $dbi && $dbi->ping ) {
      $dbi->do('drop database foo');
      $dbi->disconnect;
    }
  };
}

1;

__END__
