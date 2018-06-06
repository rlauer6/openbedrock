use strict;
use warnings;

use Test::More tests => 13;

use DBI;
use Data::Dumper;

BEGIN {
  use_ok('BLM::IndexedTableHandler');
}

my $dbi;

eval{
  $dbi = DBI->connect('dbi:mysql:', 'root', undef, { PrintError => 0, RaiseError => 1} );
  $dbi->do('create database foo');

  my $create_table =<<eot;
create table foo (
  id  int          auto_increment primary key,
  biz varchar(10)  not null,
  baz varchar(10)  null,
  buz varchar(10)  not null default 'buzzzz'
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

is($ith->get_upsert_mode(), 0, 'upsert default 0?') or diag($ith->get_upsert_mode);
$ith->set_upsert_mode(1);

is($ith->get_upsert_mode(), 1, 'set_upsert_mode') or diag($ith->get_upsert_mode);

my $id = eval {
  $ith->set('biz', 'bizzzz');
  $ith->save();
};

ok(! $@ && defined $id, 'upsert') or BAIL_OUT($@);

like($id, qr/\d+/, 'upsert') or diag("id not returned ($id): $@");

$id = eval {
  $ith->reset(1);
  $ith->set_upsert_mode(0);
  $ith->set('biz', 'bizzz');
  $ith->save();
};

like($@, qr/cannot be null/i, 'null exception') or diag("$@");

$id = eval {
  $ith->set('buz', 'buzzz');
  $ith->save();
};

ok(! $@ && $id =~/\d+/, 'insert all columns');

subtest 'select' => sub {
  my $rows = $ith->select();
  isa_ok($rows, 'BLM::IndexedTableHandler::RecordSet');
  is(@$rows, 2, 'all rows read');
};

subtest 'search exact' => sub {
  my $rows = $ith->search({ buz => 'buzzz'}, 1);
  is(@$rows, 1, 'found a record');

 SKIP: {
    skip "search failed",1 unless @$rows;
    is($rows->[0]->{buz}, 'buzzz', 'found correct record') or diag(Dumper [ $rows ]);
  }
};

subtest 'search wilcard' => sub {
  my $rows = $ith->search({ buz => 'buzz'});
  is(@$rows, 2, 'found all records');
};

subtest 'find exact' => sub {
  my $rows = $ith->find(1, 'buz', 'buzzz');
  is(@$rows, 1, 'found 1 record');
  is($rows->[0]->{buz}, 'buzzz', 'found correct record') or diag(Dumper $rows->[0]->as_ref());
};

subtest 'find wildcard' => sub {
  my $rows = $ith->find(0, 'buz', 'buzzz');
  is(@$rows, 2, 'found 2 records');
};

END {
  eval { $dbi->do('drop database foo'); };
  $dbi->disconnect;
}
