package MyApp::Users;

use strict;
use warnings;

use parent qw/Bedrock::Model::Handler/;

our $MODEL = new Bedrock::Hash(
    id => new Bedrock::Model::Field(
        {
            field => 'id',
            type  => 'int(11)',
            null  => 'no',
            extra => 'auto_increment',
            key   => 'pri'
        }
    ),
    email => new Bedrock::Model::Field(
        {
            field => 'email',
            type  => 'varchar(100)',
            null  => 'no'
        }
    ),
    nick_name => new Bedrock::Model::Field(
        {
            field => 'nick_name',
            type  => 'varchar(32)',
	    null  => 'no',
	    default => "'anonymouse'"
        }
    ),
    lname => new Bedrock::Model::Field(
        {
            field => 'lname',
            type  => 'varchar(32)',
            null  => 'no'
        }
    ),
    fname => new Bedrock::Model::Field(
        {
            field => 'fname',
            type  => 'varchar(32)',
            null  => 'no'
        }
    )
);

package main;

use strict;
use warnings;

use Test::More tests => 5;

use DBI;
use Data::Dumper;

BEGIN {
  use_ok('Bedrock::Model::Handler');
}

my $dbi;

eval{
  $dbi = DBI->connect('dbi:mysql:', 'root', undef, { PrintError => 1, RaiseError => 1, AutoCommit => 0} );
  $dbi->do('create database foo');
  $dbi->do('use foo');
};

if ( $@ ) {
  BAIL_OUT("could not create database 'foo': $@\n");
}

eval {
  MyApp::Users->_create_model($dbi);
};

ok(! $@, "create table") or BAIL_OUT("could not create table 'users'");

my $rows = $dbi->do("describe users");
is($rows, 5, "table looks sane") or BAIL_OUT("could not create table 'users'");

my $users = MyApp::Users->new($dbi);
$users->set('email', 'someuser@example.com');
$users->set('fname', 'fred');
$users->set('lname', 'flintstone');
$users->set_upsert_mode(1);
my $id = $users->save();

like($id, qr/\d+/, 'add a record with default value') or BAIL_OUT("could not write record");

subtest 'read record' => sub {
  my $new_user = $users->new($dbi, $id);
  is($new_user->get('email'), 'someuser@example.com');
  is($new_user->get('fname'), 'fred');
  is($new_user->get('lname'), 'flintstone');
  is($new_user->get('nick_name'), 'anonymouse');
};

END {
  eval {
    $dbi->do('drop database foo');
    $dbi->disconnect;  
  };
}
