package MyApp::Users;

use strict;
use warnings;

use parent qw/Bedrock::Model::Handler/;

use English qw{-no_match_vars};

our $MODEL = new Bedrock::Hash(
  id => new Bedrock::Model::Field(
    { field => 'id',
      type  => 'int(11)',
      null  => 'no',
      extra => 'auto_increment',
      key   => 'pri'
    }
  ),
  email => new Bedrock::Model::Field(
    { field => 'email',
      type  => 'varchar(100)',
      null  => 'yes'
    }
  )
);

use strict;
use warnings;

use Test::More;

use DBI;
use Data::Dumper;

########################################################################
use Bedrock::Test::Utils qw(connect_db create_db);

my $dbi = eval { return connect_db(); };

if ( !$dbi ) {
  plan skip_all => 'no datbase connection';
}
else {
  plan tests => 2;
}

use_ok('Bedrock::Model::Handler');

eval {
  $dbi->do('create database foo');
  $dbi->do('use foo');
};

if ($EVAL_ERROR) {
  BAIL_OUT("could not create database 'foo': $EVAL_ERROR\n");
}
########################################################################

MyApp::Users->_create_model($dbi);
my $rows = $dbi->do("describe users");
is( $rows, 2, "create table users" );

END {
  eval { $dbi->do('drop database foo'); };
}
