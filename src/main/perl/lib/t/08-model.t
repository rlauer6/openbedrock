#!/usr/bin/env perl

use strict;
use warnings;

package MyApp::Users;

use parent qw(Bedrock::Model::Handler);

########################################################################
package main;
########################################################################

use Bedrock::Test::Utils qw(connect_db create_db);

use Carp::Always;
use Bedrock::Hash;
use Bedrock::Constants qw(:booleans);
use DBI;
use Data::Dumper;
use English qw(-no_match_vars);
use List::Util qw(any pairs);
use Test::More;

$Data::Dumper::Terse = 1;

my $dbi = eval { return connect_db(); };

if ( !$dbi ) {
  plan skip_all => 'no database connection';
}

use_ok('Bedrock::Model');
use_ok('Bedrock::Model::Field');

Bedrock::Model::Field->import(qw(:all));

eval { return create_db( $dbi, { no_table => 1 } ); };

if ($EVAL_ERROR) {
  BAIL_OUT("could not create database 'foo': $EVAL_ERROR\n");
}

my @fields = (
  id             => { type => 'id' },
  fname          => 32,
  lname          => 32,
  email          => { type => 'email', null => 'yes' },
  address1       => 32,
  address2       => 32,
  city           => 32,
  a_bigint       => { type => 'bigint' },
  a_int          => { type => 'int' },
  state          => { type => 'state' },
  zip            => { type => 'zip' },
  start_date     => { type => 'date' },
  end_date       => { type => 'date' },
  salary         => { type => 'money' },
  winning_margin => { type => 'decimal', length => '5.3' },
  position       => [ 'president', 'vice-president', 'cabinet', ],
  json           => { type => 'json' },
  date_inserted  => { type => 'date_inserted' },
  last_updated   => { type => 'last_updated' },
);

my @model_fields;

########################################################################
subtest 'create_model_fields() - return key/value pairs' => sub {
########################################################################

  @model_fields = create_model_fields(@fields);

  ok( ( @fields == @model_fields ), sprintf 'returns a list of %d elements', scalar @fields );

  my @objs = map { $_->[1] } pairs @model_fields;

  ok( !( any { ref($_) !~ /Bedrock::Model::Field/xsm } @objs ), 'returns a list of "Bedrock::Model::Field"s' );
};

########################################################################
subtest 'create_model_fields - return array' => sub {
########################################################################

  local $Bedrock::Model::Field::RETURN_FIELDS = 1;

  @model_fields = create_model_fields(@fields);

  ok( ( @fields == 2 * @model_fields ), sprintf 'returns a list of %d elements', scalar @fields )
    or do {
    diag( Dumper( [ model_fields => \@model_fields ] ) );
    BAIL_OUT('wrong size');
    };

  ok( !( any { ref($_) !~ /Bedrock::Model::Field/xsm } @model_fields ), 'returns a list of "Bedrock::Model::Field"s' );
};

########################################################################
subtest 'create model' => sub {
########################################################################

  my $model = Bedrock::Model->create( $dbi, model => \@model_fields, table => 'users' );
  my $rows  = $dbi->do('describe users');

  is( $rows, @model_fields, 'create table users' )
    or BAIL_OUT(q{could not create table 'users'});

  use_ok('Bedrock::Model::Maker');

  MyApp::Users->_model_def( model => $model->get_model );

  my $config = { users => { set => { 'name' => 'set_uc' } } };

  my $users = MyApp::Users->new( $dbi, { config => { tables => $config } } );

  $users->set(
    fname    => 'Dwight',
    lname    => 'Eisenhower',
    address1 => '1600 Pennsylvania Ave',
    city     => 'Washington',
    state    => 'DC',
    position => 'president',
    salary   => 230_000,
  );

  $users->set( json => { fname => $users->get('fname') } );

  my $id = $users->save();

  like( $id, qr/\d+/xsm, 'save a record: ' . $id )
    or BAIL_OUT('could not write record');

  my $new_users = $users->new( $dbi, $id );

  foreach ( $users->not_id ) {
    is_deeply( { $_ => $users->get($_) }, { $_ => $new_users->get($_) }, "columns '$_' saved", );
  }

};

########################################################################

done_testing;

END {
  eval {
    $ENV{NO_DROP} or $dbi->do('drop database foo');
    $dbi->disconnect;
  };

}

1;

__END__
