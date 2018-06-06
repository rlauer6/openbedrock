use strict;
use warnings;

use Test::More tests => 12;

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
 id int auto_increment primary key,
 name varchar(100) not null default '',
 foo  varchar(100) not null,
 bar_phone varchar(10) not null default ''
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

my @columns;

subtest 'get_fields' => sub {
  @columns = sort $ith->get_fields();
  is_deeply(\@columns, [qw/bar_phone foo id name/], 'get_fields()');

  is($ith->get_field_type('name'), 'varchar(100)', 'get_field_type') or diag($ith->get_field_type('name'));
};

subtest 'set/get' => sub {
  $ith->set('name', 'Bill');
  is($ith->{name}, 'Bill', 'set scalar');

  $ith->set({ name => 'William', id => 0, foo => 'foo', bar_phone => 'bar'});
  ok($ith->{name} eq 'William' &&
     $ith->{id} == 0 &&
     $ith->{foo} eq 'foo' &&
     $ith->{bar_phone} eq 'bar', 'set hash ref');

  my $row = $ith->get(qw/id name foo bar_phone/);
  isa_ok($row, 'Bedrock::Array');
  is(join('',@$row), '0Williamfoobar', 'get array');
};

$ith->set('id', 0);
$ith->set('foo', undef); # cannot be null - should throw exception
$ith->set('bar_phone', undef); # cannot be null - should throw exception

# this should produce an error, foo cannot be null
eval {
  $ith->save();
};

like($@, qr/cannot be null/i, 'save() - not null field');

my $id;

subtest 'save' => sub {
  $id = eval {
    $ith->set({ id => 0, name => 'William', bar_phone => '8001234567', foo => 'bar'});
    $ith->save();
  };
  
  ok(! $@ && defined $id && $id > 0, 'save');
  is($ith->get('id'), $id, 'returns, sets id');
  
  my $ith2 = BLM::IndexedTableHandler->new($dbi, $id, undef, $ith->get_table_name);
  ok($ith2->{id} == $ith->{id} &&
     $ith2->{name} eq $ith->{name} &&
     $ith2->{foo} eq $ith->{foo} &&
     $ith2->{bar_phone} eq $ith2->{bar_phone}, 'saved record');
};

subtest 'reset' => sub {
  $ith->reset();
  my $count = 0;
  
  foreach (@columns) {
    $count++
      if exists $ith->{$_} && ! $ith->{$_};
  }
  
  cmp_ok($count, '==', 4, 'reset()');
  
  $ith->reset(1);
  $count = 0;

  foreach (@columns) {
    $count++
      if exists $ith->{$_};
  }

  cmp_ok($count, '==', 0, 'reset(1)');
};

# sub-class BLM::IndexedTablehandler
{
  no strict 'refs';
  push @{'ITH::Foo::ISA'}, 'BLM::IndexedTableHandler';
}

$ith = new ITH::Foo($dbi, $id);
isa_ok($ith, 'ITH::Foo') or BAIL_OUT($@);
ok(exists $ith->{name} && $ith->{name} eq 'William', 'new() - fetch inserted record');

my $ref = $ith->asref();
isa_ok($ref, 'Bedrock::Hash');

@columns = sort keys %$ref;
is_deeply(\@columns, [qw/bar_phone foo id name/], 'asref() - keys');

my $values = join('',@{$ref}{@columns});
is($values, "8001234567bar$id" . 'William', 'asref() - values');

END {
  eval { $dbi->do('drop database foo'); };
}
