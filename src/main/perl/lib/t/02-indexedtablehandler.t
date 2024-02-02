#!/usr/bin/env perl

## no critic (RequireVersionVar)
use strict;
use warnings;

use Test::More;

use DBI;
use Data::Dumper;
use English qw{-no_match_vars};
use Readonly;

Readonly my $TRUE  => 1;
Readonly my $FALSE => 0;

########################################################################
require 't/db-setup.pl';

my $dbi = eval { return connect_db(); };

if ( !$dbi ) {
  plan skip_all => 'no database connection';
}
else {
  plan tests => 16;
}

use_ok('BLM::IndexedTableHandler');

eval {
  $dbi->do('create database foo');
  $dbi->do('use foo');

  my $create_table = <<'SQL';
create table foo (
  id  int          auto_increment primary key,
  biz varchar(10)  not null,
  baz varchar(10)  null,
  buz varchar(10)  not null default 'buzzzz'
)
SQL

  $dbi->do($create_table);
};

if ($EVAL_ERROR) {
  BAIL_OUT("could not create database 'foo': $EVAL_ERROR\n");
}
########################################################################

my $ith = eval { return BLM::IndexedTableHandler->new( $dbi, 0, undef, 'foo' ); };

isa_ok( $ith, 'BLM::IndexedTableHandler' )
  or BAIL_OUT($EVAL_ERROR);

my @filtered_list = BLM::IndexedTableHandler::_filter_array( [qw( a b c d )], [qw(c d)] );
ok( !( grep {/[cd]/xsm} @filtered_list ), 'filter array (array)' );

@filtered_list = BLM::IndexedTableHandler::_filter_array( [qw( a b c d )], 'c' );
ok( !( grep {/[c]/xsm} @filtered_list ), 'filter array (scalar)' );

my @not_id = $ith->not_id();

ok( !( grep {/id/xsm} @not_id ), 'not id' )
  or diag( Dumper( [ not_id => \@not_id ] ) );

is( $ith->get_upsert_mode(), $FALSE, 'upsert default 0?' )
  or diag( $ith->get_upsert_mode );

$ith->set_upsert_mode($TRUE);

is( $ith->get_upsert_mode(), $TRUE, 'set_upsert_mode' )
  or diag( $ith->get_upsert_mode );

my $id = eval {
  $ith->set( biz => 'bizzzz' );
  $ith->save();
};

ok( !$EVAL_ERROR && defined $id, 'upsert' )
  or do {
  diag( Dumper( [$ith] ) );
  BAIL_OUT($EVAL_ERROR);
  };

like( $id, qr/^\d+$/xsm, 'upsert' )
  or diag("id not returned ($id): $EVAL_ERROR");

$id = eval {
  $ith->reset($TRUE);
  $ith->set_upsert_mode($FALSE);
  $ith->set( 'biz', 'bizzz' );
  $ith->save();
};

like( $EVAL_ERROR, qr/cannot be null/smi, 'null exception' )
  or diag("$EVAL_ERROR");

$id = eval {
  $ith->set( 'buz', 'buzzz' );
  $ith->save();
};

ok( !$EVAL_ERROR && $id =~ /^\d+$/xsm, 'insert all columns' );

########################################################################
subtest 'select' => sub {
########################################################################
  my $rows = $ith->select();
  isa_ok( $rows, 'BLM::IndexedTableHandler::RecordSet' );
  is( @{$rows}, 2, 'all rows read' );
};

########################################################################
subtest 'search exact' => sub {
########################################################################
  my $rows = $ith->search( { buz => 'buzzz' }, 1 );

  is( @{$rows}, 1, 'found a record' )
    or diag( Dumper( [$rows] ) );

  SKIP: {
    if ( !@{$rows} ) {
      skip 'search failed', 1;
    }

    is( $rows->[0]->{buz}, 'buzzz', 'found correct record' )
      or diag( Dumper [$rows] );
  }
};

########################################################################
subtest 'search wilcard' => sub {
########################################################################
  my $rows = $ith->search( { buz => 'buzz' } );
  is( @{$rows}, 2, 'found all records' );
};

########################################################################
subtest 'find exact' => sub {
########################################################################
  my $rows = $ith->find( 1, 'buz', 'buzzz' );

  is( @{$rows}, 1, 'found 1 record' );

  SKIP: {
    if ( !@{$rows} ) {
      skip 'search failed', 1;
    }

    is( $rows->[0]->{buz}, 'buzzz', 'found correct record' )
      or diag( Dumper $rows->[0]->as_ref() );
  }
};

########################################################################
subtest 'find wildcard' => sub {
########################################################################
  my $rows = $ith->find( 0, 'buz', 'buzzz' );
  is( @{$rows}, 2, 'found 2 records' );
};

END {
  eval {
    if ( $dbi && $dbi->ping ) {
      $dbi->do('drop database foo');
      $dbi->disconnect;
    }
  };
}

1;

__END__
