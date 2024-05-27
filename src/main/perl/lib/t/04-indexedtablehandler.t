use strict;
use warnings;

use Test::More;

use DBI;
use Data::Dumper;
use English qw{-no_match_vars};

########################################################################
use Bedrock::Test::Utils qw(connect_db create_db);

my $dbi = eval { return connect_db(); };

if ( !$dbi ) {
  plan skip_all => 'no database connection';
}
else {
  plan tests => 7;
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
