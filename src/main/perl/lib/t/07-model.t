#!/usr/bin/env perl

use strict;
use warnings;

package MyApp::Users;

BEGIN {
  use Bedrock;
  use File::Basename qw(dirname basename);

  my $path = dirname( $INC{'Bedrock.pm'} );
  push @INC, "$path/Bedrock", "$path/Bedrock/Text";
}

use parent qw(Bedrock::Model::Handler);

########################################################################
package main;
########################################################################

use Bedrock::Test::Utils qw(connect_db create_db);

use Carp::Always;
use Bedrock::Hash;
use DBI;
use Data::Dumper;
use English qw(-no_match_vars);
use Test::More;

my $dbi = eval { return connect_db(); };

if ( !$dbi ) {
  plan skip_all => 'no database connection';
}

use_ok('Bedrock::Model');
use_ok('Bedrock::Model::Field');

Bedrock::Model::Field->import(qw(:all));

eval { return create_db( $dbi, 1 ); };

if ($EVAL_ERROR) {
  BAIL_OUT("could not create database 'foo': $EVAL_ERROR\n");
}

########################################################################

my @fields = eval {
  local $Bedrock::Model::Field::RETURN_FIELDS = 1;

  return (
    id_field(),                                                              varchar_field( 'name', 32 ),
    varchar_field( 'address', 64 ),                                          zip_field('zip'),
    enum_field( 'position', [ 'president', 'vice-president', 'cabinet', ] ), json_field('json'),
    date_inserted_field(),                                                   last_updated_field(),
  );
};

my $model = Bedrock::Model->create( $dbi, model => \@fields, table => 'users' );

use_ok('Bedrock::Model::Maker');

my $rows = $dbi->do('describe users');

is( $rows, @fields, 'create table users' )
  or BAIL_OUT(q{could not create table 'users'});

MyApp::Users->_model_def( model => $model->get_model );

my $config = { users => { set => { 'name' => 'set_uc' } } };

my $users = MyApp::Users->new( $dbi, { config => { tables => $config } } );

$users->set(
  name     => 'Dwight Eisenhower',
  address  => '1600 Pennsylvania Ave, Washington, DC',
  position => 'president',
);

$users->set( json => { name => $users->get('name') } );

my $id = $users->save();

like( $id, qr/\d+/xsm, 'save a record: ' . $id )
  or BAIL_OUT('could not write record');

my $new_users = $users->new( $dbi, $id );

foreach ( $users->not_id ) {
  is_deeply( { $_ => $users->get($_) }, { $_ => $new_users->get($_) }, "columns '$_' saved", );
}

done_testing;

END {
  eval {
    $ENV{NO_DROP} or $dbi->do('drop database foo');
    $dbi->disconnect;
  };

}

1;

__END__
