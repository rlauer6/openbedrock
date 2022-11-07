use strict;
use warnings;

use Test::More;

use DBI;
use English qw{-no_match_vars};

########################################################################
require 't/db-setup.pl';

my $dbi = eval { return connect_db(); };

if ( !$dbi ) {
  plan skip_all => 'no database connection';
}
else {
  plan tests => 3;
}

use_ok('BLM::IndexedTableHandler');

eval {
  $dbi->do('create database foo');
  $dbi->do('use foo');

  my $create_table = <<'SQL';
create table foo (
  id  int          auto_increment primary key
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
  eval {
    if ( $dbi && $dbi->ping ) {
      $dbi->do('drop database foo');
      $dbi->disconnect;
    }
  };
}

1;
