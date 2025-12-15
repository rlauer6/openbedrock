#!/usr/bin/env perl

use strict;
use warnings;

use BLM::DBHandler;
use Cwd;
use DBI;
use Data::Dumper;
use English qw(-no_match_vars);
use List::Util qw(none);
use Test::More;
use Bedrock::Test::Utils qw(connect_db create_db :booleans @FOO_FIELDS);

########################################################################
# setup
########################################################################

my $dbi = eval { return connect_db(); };

if ( !$dbi ) {
  plan skip_all => 'no database connection';
}

eval { return create_db($dbi); };

BAIL_OUT("could not create database 'foo': $EVAL_ERROR\n")
  if $EVAL_ERROR;

Readonly::Hash our %TEST_RECORD => (
  id        => 0,
  name      => 'test',
  foo       => 'bar',
  bar_phone => '8888888888',
);

########################################################################
# end of setup
########################################################################

use_ok('BLM::IndexedTableHandler')
  or BAIL_OUT(@EVAL_ERROR);

########################################################################
subtest 'new(dbi, id, table)' => sub {
########################################################################

  my $ith = eval { return BLM::IndexedTableHandler->new( $dbi, 0, 'foo' ); };

  isa_ok( $ith, 'BLM::IndexedTableHandler' )
    or do {
    diag($EVAL_ERROR);
    BAIL_OUT('ERROR: unable to create a handler');
    };
};

########################################################################
subtest 'new(dbi, { table => } )' => sub {
########################################################################

  my $ith = eval { return BLM::IndexedTableHandler->new( $dbi, { table => 'foo' } ); };

  isa_ok( $ith, 'BLM::IndexedTableHandler' )
    or do {
    diag($EVAL_ERROR);
    BAIL_OUT('ERROR: unable to create a handler');
    };
};

########################################################################
subtest 'new(dbi, { table_name => } )' => sub {
########################################################################

  my $ith = eval { return BLM::IndexedTableHandler->new( $dbi, { table_name => 'foo' } ); };

  isa_ok( $ith, 'BLM::IndexedTableHandler' )
    or do {
    diag($EVAL_ERROR);
    BAIL_OUT('ERROR: unable to create a handler');
    };
};

########################################################################
subtest 'new(dbi) - sub-classed' => sub {
########################################################################

  # sub-class BLM::IndexedTablehandler
  {
    no strict 'refs';  ## no critic (ProhibitNoStrict)

    push @{'ITH::Foo::ISA'}, 'BLM::IndexedTableHandler';
  }

  my $ith = ITH::Foo->new($dbi);

  isa_ok( $ith, 'ITH::Foo' )
    or do {
    diag($EVAL_ERROR);
    BAIL_OUT('could not create BLM::IndexedTableHandler instance');
    };
};

########################################################################
subtest 'get_fields' => sub {
########################################################################
  my $ith = ITH::Foo->new($dbi);

  my @columns = sort $ith->get_fields();

  is_deeply( \@columns, \@FOO_FIELDS, 'get_fields() - all' );
};

########################################################################
subtest 'get_field_type' => sub {
########################################################################
  my $ith = ITH::Foo->new($dbi);

  is( $ith->get_field_type('name'), 'varchar(100)', 'get_field_type' )
    or diag( $ith->get_field_type('name') );
};

########################################################################
subtest 'set/get' => sub {
########################################################################
  my $ith = ITH::Foo->new($dbi);

  $ith->set(%TEST_RECORD);

  foreach my $field ( keys %TEST_RECORD ) {
    ok( $ith->get($field) eq $TEST_RECORD{$field}, 'get ' . $field );
  }

};

########################################################################
subtest 'save' => sub {
########################################################################
  my $ith = ITH::Foo->new($dbi);

  $ith->set(%TEST_RECORD);

  my $id = $ith->save();

  like( $id, qr/\A\d+\z/xsm, 'save returned integer id' );
};

########################################################################
subtest 'new(dbi, id)' => sub {
########################################################################
  my $id = $dbi->last_insert_id();

  my $ith = ITH::Foo->new( $dbi, $id );

  foreach my $field ( keys %TEST_RECORD ) {
    next if $field eq 'id';

    ok( $ith->get($field) eq $TEST_RECORD{$field}, 'get ' . $field );
  }
};

########################################################################
subtest 'new( dbi, { id => ... })' => sub {
########################################################################
  my $id = $dbi->last_insert_id();

  my $ith = ITH::Foo->new( $dbi, { id => $id } );

  foreach my $field ( keys %TEST_RECORD ) {
    next if $field eq 'id';

    ok( $ith->get($field) eq $TEST_RECORD{$field}, 'get ' . $field );
  }
};

########################################################################
subtest 'new({}) - query ' => sub {
########################################################################
  my $ith = ITH::Foo->new( { dbi => $dbi, table => 'foo', foo => 'bar' } );

  isa_ok( $ith, 'ITH::Foo' )
    or do {
    diag($EVAL_ERROR);
    bail_out('could not create BLM::IndexedTableHandler instance');
    };

  is( $ith->{foo}, 'bar', 'read record from query' );

  for (qw(biz buz baz)) {
    $ith->set( id => 0, foo => $_ );

    if ( $_ eq 'baz' ) {
      $ith->set( bar_phone => '9999999999' );
    }

    $ith->save();
  }

  $ith = $ith->new(
    { dbi       => $dbi,
      bar_phone => '9999999999',
      or        => [ foo => 'biz', foo => 'baz' ]
    }
  );

  is( $ith->{foo}, 'baz', 'and, or' );

};

########################################################################
subtest 'new({}) - query (or)' => sub {
########################################################################
  my $ith = ITH::Foo->new( { dbi => $dbi, _or_ => [ foo => 'bar', name => 'test' ] } );

  isa_ok( $ith, 'ITH::Foo' )
    or do {
    diag($EVAL_ERROR);
    bail_out('could not create BLM::IndexedTableHandler instance');
    };

  is( $ith->{foo}, 'bar', 'read record from query' );

  my $list = $ith->select_list('select * from foo');
};

########################################################################
subtest 'new()' => sub {
########################################################################
  my $ith = ITH::Foo->new();

  isa_ok( $ith, 'ITH::Foo' )
    or do {
    diag($EVAL_ERROR);
    bail_out('could not create BLM::IndexedTableHandler instance');
    };

  my $new_ith = eval { return $ith->load_config(*DATA); };

  ok( !$EVAL_ERROR, 'loaded config and create new handler' )
    or do {
    diag( Dumper( [ error => $EVAL_ERROR ] ) );
    BAIL_OUT("could not load config\n");
    };

  isa_ok( $new_ith, 'BLM::IndexedTableHandler' )
    or diag($EVAL_ERROR);

  my $config = $ith->get_config;

  ok( exists $config->{tables}, 'loaded a table definition' );

  isa_ok( $new_ith->dbi, 'DBI::db' );

  my $list = $new_ith->select_list('select * from foo');
};

########################################################################
subtest delete => sub {
########################################################################
  my $id = $dbi->last_insert_id();

  my $ith = ITH::Foo->new( $dbi, $id );

  $ith->delete('foo');  # delete 1 column

  my @columns = $ith->get_fields( { exists_only => $TRUE } );

  ok( @columns == @FOO_FIELDS - 1, 'delete column' );

  ok( $ith->delete($id), 'delete record from table' );

  ok( ( none { exists $ith->{$_} } $ith->get_fields ), 'delete fields from record' );

  my ($deleted_record) = $dbi->selectall_array( 'select * from foo where id = ?', undef, $id );

  ok( !$deleted_record, 'verify record deleted' )
    or diag( Dumper( [$deleted_record] ) );
};

########################################################################
subtest 'null exceptions' => sub {
########################################################################
  my $ith = ITH::Foo->new($dbi);

  $ith->set(
    id        => 0,
    foo       => undef,
    bar_phone => undef,
  );

  # this should produce an error, foo cannot be null
  my $id = eval { return $ith->save(); };

  ok( !$id, 'no id returned from save' );
  like( $EVAL_ERROR, qr/cannot be null/ism, 'save() - not null field' );
};

my $ith;

########################################################################
subtest 'reset (clear all fields)' => sub {
########################################################################
  my $count;

  my $id = $dbi->last_insert_id();

  $ith = ITH::Foo->new( $dbi, $id );

  $ith->reset();

  $count = grep { exists $ith->{$_} && !defined $ith->{$_} } $ith->get_fields;

  ok( $count == @FOO_FIELDS, 'reset() - undef' );
};

########################################################################
subtest 'reseet (delete all fields)' => sub {
########################################################################
  my $id = $dbi->last_insert_id();

  $ith->new( $dbi, $id );

  $ith->reset( { delete => $TRUE } );

  my $count = grep { exists $ith->{$_} } $ith->get_fields;

  ok( !$count, 'reset( { delete => 1 }) - delete all fields' );
};

done_testing;

1;

END {
  eval {
    if ( $dbi && $dbi->ping ) {
      $dbi->do('drop database foo');
    }
  };
}

__DATA__
{
  "tables": {
    "foo" : {
    }
  },
  "database": {
     "dsn": "dbi:mysql:foo",
     "user": "fred",
     "password": "flintstone",
     "hostname": "127.0.0.1;mysql_ssl=1",
     "env": 1
   },
  "title": "Test"
}
