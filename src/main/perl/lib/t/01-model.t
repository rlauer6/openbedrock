package MyApp::Users;

use strict;
use warnings;

use parent qw(Bedrock::Model::Handler);

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
      null  => 'yes'
    }
  )
);

########################################################################
package main;
########################################################################

use strict;
use warnings;

use Bedrock::Test::Utils qw(connect_db create_db);
use Data::Dumper;
use DBI;
use English qw(-no_match_vars);
use Test::More;

my $dbi = eval { return connect_db(); };

if ( !$dbi ) {
  plan skip_all => 'no database connection';
}
else {
  plan tests => 2;
}

use_ok('Bedrock::Model::Handler');

eval {
  $dbi->do('create database foo');
  $dbi->do('use foo');
};

BAIL_OUT("could not create database 'foo': $EVAL_ERROR\n")
  if $EVAL_ERROR;

MyApp::Users->_create_model($dbi);

my $rows = $dbi->do('describe users');
is( $rows, 2, '_create_model()' );

END {
  eval { $dbi->do('drop database foo'); };
}

1;
