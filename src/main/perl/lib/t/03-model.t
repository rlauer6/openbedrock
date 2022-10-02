package MyApp::Users;

use strict;
use warnings;

use parent qw/Bedrock::Model::Handler/;

package main;

use strict;
use warnings;

use Test::More tests => 8;

use DBI;
use Data::Dumper;
use English qw{-no_match_vars};

BEGIN {
  use_ok('Bedrock::Model::Handler');
}

my $model_def = <<'EOT';
our $MODEL = Bedrock::Hash->new(
    id => Bedrock::Model::Field->new(
        {
            field => 'id',
            type  => 'int(11)',
            null  => 'no',
            extra => 'auto_increment',
            key   => 'pri'
        }
    ),
    email => Bedrock::Model::Field->new(
        {
            field => 'email',
            type  => 'varchar(100)',
            null  => 'no',
            key   => 'uni'
        }
    ),
    lname => Bedrock::Model::Field->new(
        {
            field => 'lname',
            type  => 'varchar(32)',
            null  => 'no'
        }
    ),
    fname => Bedrock::Model::Field->new(
        {
            field => 'fname',
            type  => 'varchar(32)',
            null  => 'no'
        }
    )
);
EOT

open my $fh, '>', 'users.mdl'
  or die 'could not open users.mdl';

print {$fh} $model_def;

close $fh;

my $dbi;

my $user = $ENV{DBI_USER} || 'root';
my $pass = $ENV{DBI_PASS};

eval {
  $dbi = DBI->connect( 'dbi:mysql:', $user, $pass,
    { PrintError => 0, RaiseError => 1 } );

  $dbi->do('create database foo');
  $dbi->do('use foo');
};

if ($EVAL_ERROR) {
  BAIL_OUT("could not create database 'foo': $EVAL_ERROR\n");
}

eval { MyApp::Users->_create_model($dbi); };

ok( !$EVAL_ERROR, 'create table with .mdl file' )
  or do {
  diag($EVAL_ERROR);
  BAIL_OUT(q{could not create table 'users'});
  };

my $rows = $dbi->do('describe users');
is( $rows, 4, 'table looks sane' )
  or BAIL_OUT(q{could not create table 'users'});

my $model = MyApp::Users->_add_field(
  $dbi,
  field => 'address',
  type  => 'varchar(100)',
  null  => 'yes'
);

my $migration = Bedrock::Model::Migration->new( { model => $model } );

is( $migration->should_migrate(), 1, 'should migrate' )
  or diag( Dumper $migration->get_migration );

eval { $migration->execute(); };

ok( !$EVAL_ERROR, 'execute migration' )
  or BAIL_OUT( "migration failed - $EVAL_ERROR - " . join "\n",
  @{ $migration->get_migration() } );

is( $dbi->do('describe users'), 5, 'add new column to table' );

my $users = bless $model, 'MyApp::Users';
$users = $users->new($dbi);

$users->set( email   => 'someuser@example.com' );
$users->set( fname   => 'fred' );
$users->set( lname   => 'flintstone' );
$users->set( address => '123 Rockaway Drive' );

my $id = $users->save();

like( $id, qr/\d+/xsm, 'save a record' )
  or BAIL_OUT('could not write record');

subtest 'read record' => sub {
  my $new_user = $users->new( $dbi, $id );
  is( $new_user->get('email'),   'someuser@example.com' );
  is( $new_user->get('fname'),   'fred' );
  is( $new_user->get('lname'),   'flintstone' );
  is( $new_user->get('address'), '123 Rockaway Drive' );
};

END {
  eval {
    $dbi->do('drop database foo');
    $dbi->disconnect;
  };
}

1;

__END__
