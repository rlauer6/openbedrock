package MyApp::Users;

use strict;
use warnings;

use parent qw/Bedrock::Model::Handler/;

our $MODEL = {
  %Bedrock::Model::Field::Id,
  %Bedrock::Model::Field::Email,
  %Bedrock::Model::Field::Address,
  %Bedrock::Model::Field::Timestampable,
  nick_name => new Bedrock::Model::Field(
    { field   => 'nick_name',
      type    => 'varchar(32)',
      null    => 'no',
      default => "'anonymouse'"
    }
  ),
  lname => new Bedrock::Model::Field(
    { field => 'lname',
      type  => 'varchar(32)',
      null  => 'no'
    }
  ),
  fname => new Bedrock::Model::Field(
    { field => 'fname',
      type  => 'varchar(32)',
      null  => 'no'
    }
  )
};

package main;

use strict;
use warnings;

use Test::More tests => 5;

use DBI;
use Data::Dumper;
use English qw{-no_match_vars};

BEGIN {
  use_ok('Bedrock::Model::Handler');
}

my $dbi;
my $user = $ENV{DBI_USER};
my $pass = $ENV{DBI_PASS};

eval {
  $dbi = DBI->connect( 'dbi:mysql:', $user, $pass,
    { PrintError => 0, RaiseError => 1, AutoCommit => 0 } );

  $dbi->do('create database foo');
  $dbi->do('use foo');
};

if ($EVAL_ERROR) {
  BAIL_OUT("could not create database 'foo': $EVAL_ERROR\n");
}

eval { MyApp::Users->_create_model($dbi); };

ok( !$EVAL_ERROR, "create table" )
  or BAIL_OUT("could not create table 'users'");

my $rows = $dbi->do("describe users");
is( $rows, 11, "table looks sane" )
  or BAIL_OUT("could not create table 'users'");

my $users = MyApp::Users->new($dbi);

$users->set( 'email', 'someuser@example.com' );
$users->set( 'fname', 'fred' );
$users->set( 'lname', 'flintstone' );
$users->set( 'zip',   '08620-1234' );
$users->set_upsert_mode(1);
my $id = $users->save();

like( $id, qr/\d+/, 'add a record with default value' )
  or BAIL_OUT("could not write record");

subtest 'read record' => sub {
  my $new_user = $users->new( $dbi, $id );
  is( $new_user->get('email'),     'someuser@example.com', 'email' );
  is( $new_user->get('fname'),     'fred',                 'fname' );
  is( $new_user->get('lname'),     'flintstone',           'lname' );
  is( $new_user->get('nick_name'), 'anonymouse',           'nick_name' );
  is( $new_user->get('zip'),       '08620-1234',           'zip' );
  like( $new_user->get('last_updated'), qr/^\d{4}\-/, 'timestamp' );
};

END {
  eval {
    $dbi->do('drop database foo');
    $dbi->disconnect;
  };
}
