use strict;
use warnings;

use Test::More tests => 15;

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

BAIL_OUT("could not create database and table for test\n$@\n")
  if $@;

my $ith = eval {
  new BLM::IndexedTableHandler($dbi, 0, undef, 'foo');
};

isa_ok($ith,'BLM::IndexedTableHandler') or BAIL_OUT($@);

my @columns = sort $ith->get_fields();
is_deeply(\@columns, [qw/bar_phone foo id name/], 'get_fields()');

$ith->set('id', 0);
$ith->set('name', 'William');

# this should produce an error
eval {
  $ith->save();
};

like($@, qr/null/, 'save() - NOT NULL');

$ith->set('bar_phone', '');
$ith->set('foo', '');

my $id = eval {
  $ith->save();
};

ok(! $@ && defined $id && $id > 0, 'save()');

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

$ith->set('id', 0);
$ith->set('name', 'John');

$id = eval {
  $ith->insert();
};

ok(! $@ && defined $id && $id > 0, 'insert()');

my $ith2 = $ith->new($dbi, $id);

isa_ok($ith2, 'BLM::IndexedTableHandler') or BAIL_OUT(ref($ith2));
ok(exists $ith2->{name} && $ith2->{name} eq 'John', 'new() - fetch inserted record');

# sub-class BLM::IndexedTablehandler
{
  no strict 'refs';
  push @{'ITH::Foo::ISA'}, 'BLM::IndexedTableHandler';
}

my $ith3 = new ITH::Foo($dbi, $id);
isa_ok($ith3, 'ITH::Foo') or BAIL_OUT($@);
ok(exists $ith3->{name} && $ith3->{name} eq 'John', 'new() - fetch inserted record');

my $ref = $ith3->asref();
isa_ok($ref, 'Bedrock::Hash');

@columns = sort keys %$ref;
is_deeply(\@columns, [qw/bar_phone foo id name/], 'asref() - keys');

my $values = join('',@{$ref}{@columns});
is($values, "$id" . 'John', 'asref() - values');

END {
  eval { $dbi->do('drop database foo'); };
}
