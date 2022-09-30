use strict;
use warnings;

use Test::More tests => 7;

use DBI;
use Data::Dumper;
use English qw{-no_match_vars};

BEGIN {
  use_ok('BLM::IndexedTableHandler')
    or BAIL_OUT($EVAL_ERROR);
}

my $dbi;

eval {
  $dbi = DBI->connect( 'dbi:mysql:', 'root', undef,
    { PrintError => 0, RaiseError => 1 } );
  $dbi->do('create database foo');

  my $create_table = <<eot;
create table foo (
  id  int          auto_increment primary key,
  firstname varchar(50),
  lastname varchar(50),
  nickname varchar(50)
)
eot

  $dbi->do('use foo');
  $dbi->do($create_table);
};

BAIL_OUT("could not create database and table for test: $@\n")
  if $@;

my $ith = eval { new BLM::IndexedTableHandler( $dbi, 0, undef, 'foo' ); };

isa_ok( $ith, 'BLM::IndexedTableHandler' ) or BAIL_OUT($@);

my $count = 0;

while ( my $rec = <DATA> ) {
  chomp $rec;

  my ( $first, $last, $nick ) = split /,/, $rec;

  $ith->set( 'id',        0 );
  $ith->set( 'firstname', $first );
  $ith->set( 'lastname',  $last );
  $ith->set( 'nickname',  $nick );

  $ith->save();
  $count++;
}

ok( $count == 3,                                      'loaded 3 records' );
ok( @{ $ith->select_list("select * from foo") } == 3, 'read 3 record' );

my $ac = $ith->autocomplete();

isa_ok( $ac, 'ARRAY' );

# 8 because Clyde does not have a last name
ok( @$ac == 8, 'all rows, all columns' );

$ac = $ith->autocomplete(
  query => "lastname like ? or nickname like ?",
  args  => [ 'k%', 'k%' ]
);

ok( @$ac == 5, 'all rows, all columns not like "k"' );

BAIL_OUT("Could not write records...$@\n")
  if $@;

END {
  eval { $dbi->do('drop database foo'); };
  $dbi->disconnect;
}

__DATA__
Rob,Lauer,Bigfoot
Meghan,Kelly,Hollywood
Clyde,,King
