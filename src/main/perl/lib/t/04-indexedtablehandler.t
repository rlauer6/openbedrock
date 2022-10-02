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

my $user = $ENV{DBI_USER} || 'root';
my $pass = $ENV{DBI_PASS};

eval {
  $dbi = DBI->connect( 'dbi:mysql:', $user, $pass,
    { PrintError => 0, RaiseError => 1 } );

  $dbi->do('create database foo');

  my $create_table = <<'SQL';
create table foo (
  id  int   auto_increment primary key,
  firstname varchar(50),
  lastname  varchar(50),
  nickname  varchar(50)
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

my $count = 0;

while ( my $rec = <DATA> ) {
  chomp $rec;

  my ( $firstname, $lastname, $nickname ) = split /[,]/xsm, $rec;

  $ith->set(
    id        => 0,
    firstname => $firstname,
    lastname  => $lastname,
    nickname  => $nickname,
  );

  $ith->save();
  $count++;
}

ok( $count == 3, 'loaded 3 records' );

ok( @{ $ith->select_list('select * from foo') } == 3, 'read 3 record' );

my $ac = $ith->autocomplete();

isa_ok( $ac, 'ARRAY' );

# 8 because Clyde does not have a last name
ok( @{$ac} == 8, 'all rows, all columns' )
  or diag( Dumper( [$ac] ) );

$ac = $ith->autocomplete(
  query => 'lastname like ? or nickname like ?',
  args  => [ 'k%', 'k%' ]
);

ok( @{$ac} == 5, 'all rows, all columns not like "k"' );

if ($EVAL_ERROR) {
  diag( Dumper( [ 'autocomplete: ', $ac ] ) )
    or diag( Dumper( [$ac] ) );

  BAIL_OUT("Could not write records...$EVAL_ERROR\n");
}

END {
  eval { $dbi->do('drop database foo'); };
  $dbi->disconnect;
}

1;

__DATA__
Rob,Lauer,Bigfoot
Meghan,Kelly,Hollywood
Clyde,,King
