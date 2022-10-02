use strict;
use warnings;

use Test::More tests => 3;

use DBI;
use English qw{-no_match_vars};

BEGIN {
  use_ok('BLM::IndexedTableHandler') or BAIL_OUT($EVAL_ERROR);
}

my $dbi;

my $user = $ENV{DBI_USER} || 'root';
my $pass = $ENV{DBI_PASS};

eval {
  $dbi = DBI->connect( 'dbi:mysql:', $user, $pass,
    { PrintError => 0, RaiseError => 1 } );

  $dbi->do('create database foo');

  my $create_table = <<'SQL';
create table foo (
  id  int          auto_increment primary key
)
SQL

  $dbi->do('use foo');
  $dbi->do($create_table);
};

if ($EVAL_ERROR) {
  BAIL_OUT("could not create database and table for test: $EVAL_ERROR\n");
}

my $ith
  = eval { return BLM::IndexedTableHandler->new( $dbi, 0, undef, 'foo' ); };

isa_ok( $ith, 'BLM::IndexedTableHandler' )
  or BAIL_OUT($EVAL_ERROR);

eval {
  foreach ( 1 .. 10 ) {
    $ith->set( id => 0 );
    $ith->save();
  }
};

if ($EVAL_ERROR) {
  BAIL_OUT("Could not write records...$EVAL_ERROR\n");
}

is( $ith->max_id(), 10, 'max_id()' );

END {
  eval { $dbi->do('drop database foo'); };
  $dbi->disconnect;
}

1;
