use strict;
use warnings;

use Test::More tests => 3;

use DBI;

BEGIN {
  use_ok('BLM::IndexedTableHandler') or BAIL_OUT($@);
}

my $dbi;

eval{
  $dbi = DBI->connect('dbi:mysql:', 'root', undef, { PrintError => 0, RaiseError => 1} );
  $dbi->do('create database foo');

  my $create_table =<<eot;
create table foo (
  id  int          auto_increment primary key
)
eot

  $dbi->do('use foo');
  $dbi->do($create_table);
};

BAIL_OUT("could not create database and table for test: $@\n")
  if $@;

my $ith = eval {
  new BLM::IndexedTableHandler($dbi, 0, undef, 'foo');
};

isa_ok($ith,'BLM::IndexedTableHandler') or BAIL_OUT($@);

eval {
  foreach (1..10) {
    $ith->set('id', 0);
    $ith->save();
  }
};

BAIL_OUT("Could not write records...$@\n")
  if $@;

is($ith->max_id(), 10, 'max_id()');

END {
  eval { $dbi->do('drop database foo'); };
  $dbi->disconnect;
}
