use strict;
use warnings;

use Test::More;

use DBI;
use Data::Dumper;
use English qw{-no_match_vars};

########################################################################
require 't/db-setup.pl';

my $dbi = eval { return connect_db(); };

if ( !$dbi ) {
  plan skip_all => 'no database connection';
}
else {
  plan tests => 6;
}

use_ok('BLM::IndexedTableHandler')
  or BAIL_OUT($EVAL_ERROR);

eval {
  $dbi->do('create database foo');
  $dbi->do('use foo');

  my $create_table = <<'SQL';
create table foo (
  id  int   auto_increment primary key,
  firstname varchar(50),
  lastname  varchar(50),
  nickname  varchar(50)
)
SQL

  $dbi->do($create_table);
};

if ($EVAL_ERROR) {
  BAIL_OUT("could not create database 'foo': $EVAL_ERROR\n");
}
########################################################################

my $ith
  = eval { return BLM::IndexedTableHandler->new( $dbi, 0, undef, 'foo' ); };

isa_ok( $ith, 'BLM::IndexedTableHandler' )
  or BAIL_OUT($EVAL_ERROR);

my $curtime = eval { $ith->curtime(); };

ok($curtime, 'curtime()');
like($curtime, qr/\d{2}:\d{2}/xsm, 'looks like a time');

my $now = eval { $ith->now() };

ok($now, 'now');

like($now, qr/^\d{4}-\d{2}-\d{2}\s\d{2}:\d{2}:\d{2}$/xsm, 'looks like data')
 or diag($now);

END {
  eval {
    if ( $dbi && $dbi->ping ) {
      $dbi->do('drop database foo');
      $dbi->disconnect;
    }
  };
}

1;

__DATA__
Rob,Lauer,Bigfoot
Meghan,Kelly,Hollywood
Clyde,,King
