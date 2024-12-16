#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Data::Dumper;
use List::Util qw(pairs);

use_ok('BLM::IndexedTableHandler');

my %tests = (
  'Foo'           => 'foo',
  'Foo::Bar'      => 'bar',
  'Foo:BarBuz'    => 'bar_buz',
  'Foo::Boo::Bar' => 'bar',
);

foreach my $p ( pairs %tests ) {
  my $table_name = BLM::IndexedTableHandler::create_table_name( $p->[0] );
  is( $table_name, $p->[1], sprintf 'table name from %s is %s', @{$p} );
}

done_testing;

1;
