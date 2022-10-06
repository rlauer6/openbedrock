package MyApp::Users;

use strict;
use warnings;

use parent qw/Bedrock::Model::Handler/;

our $MODEL = Bedrock::Hash->new(
  id => Bedrock::Model::Field->new(
    { field => 'id',
      type  => 'int(11)',
      null  => 'no',
      extra => 'auto_increment',
      key   => 'pri'
    }
  ),
  email => Bedrock::Model::Field->new(
    { field => 'email',
      type  => 'varchar(100)',
      null  => 'no'
    }
  ),
  nick_name => Bedrock::Model::Field->new(
    { field   => 'nick_name',
      type    => 'varchar(32)',
      null    => 'no',
      default => '"anonymouse"'
    }
  ),
  lname => Bedrock::Model::Field->new(
    { field => 'lname',
      type  => 'varchar(32)',
      null  => 'no'
    }
  ),
  fname => Bedrock::Model::Field->new(
    { field => 'fname',
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
use English qw{-no_match_vars};

BEGIN {
  use_ok('Bedrock::Model::Handler');
}

########################################################################
require 't/db-setup.pl';

my $dbi = eval { return connect_db(); };

if ( !$dbi || $EVAL_ERROR ) {
  diag($EVAL_ERROR);
  BAIL_OUT("could not connect to database\n");
}

eval {
  $dbi->do('create database foo');
  $dbi->do('use foo');
};

if ($EVAL_ERROR) {
  BAIL_OUT("could not create database 'foo': $EVAL_ERROR\n");
}
########################################################################

eval { MyApp::Users->_create_model($dbi); };

ok( !$EVAL_ERROR, 'create table' )
  or do {
  diag( Dumper( [$EVAL_ERROR] ) );
  BAIL_OUT(q{could not create table 'users'});
  };

my $rows = $dbi->do('describe users');
is( $rows, 5, 'table looks sane' )
  or BAIL_OUT(q{could not create table 'users'});

my $users = MyApp::Users->new($dbi);
$users->set(
  email => 'someuser@example.com',
  fname => 'fred',
  lname => 'flintstone',
);

$users->set_upsert_mode(1);

my $id = $users->save();

like( $id, qr/\d+/xsm, 'add a record with default value' )
  or BAIL_OUT('could not write record');

subtest 'read record' => sub {
  my $new_user = $users->new( $dbi, $id );
  is( $new_user->get('email'),     'someuser@example.com' );
  is( $new_user->get('fname'),     'fred' );
  is( $new_user->get('lname'),     'flintstone' );
  is( $new_user->get('nick_name'), 'anonymouse' );
};

END {
  eval {
    $dbi->do('drop database foo');
    $dbi->disconnect;
  };
}

1;

__END__
