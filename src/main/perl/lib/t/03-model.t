use strict;
use warnings;

package MyApp::Users;

use parent qw(Bedrock::Model::Handler);

########################################################################
package main;
########################################################################

BEGIN {
  use lib qw(.);
}

use Bedrock::Test::Utils qw(connect_db create_db);
use Bedrock::Model::Field qw(varchar_field);
use DBI;
use Data::Dumper;
use English qw(-no_match_vars);
use Test::More;

########################################################################
sub create_model_file {
########################################################################

  my $model_def = <<'END_OF_MODEL';
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
END_OF_MODEL

  open my $fh, '>', 'users.mdl'
    or die 'could not open users.mdl';

  print {$fh} $model_def;

  close $fh;

  return;
}

########################################################################

my $dbi = eval { return connect_db(); };

if ( !$dbi ) {
  plan skip_all => 'no database connection';
}
else {
  plan tests => 3;
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
subtest 'create a table and handler' => sub {
########################################################################
  create_model_file();

  my $handler = eval { return MyApp::Users->create_model($dbi); };

  isa_ok( $handler, 'Bedrock::Model::Handler', 'create a model handler' );

  ok( !$EVAL_ERROR, 'create table with .mdl file' )
    or do {
    diag("ERROR: $EVAL_ERROR");
    BAIL_OUT(q{could not create table 'users'});
    };

  my $rows = $dbi->do('describe users');

  is( $rows, 4, 'table looks sane' )
    or BAIL_OUT(q{could not create table 'users'});
};

########################################################################
subtest 'model migration' => sub {
########################################################################
  # this adds a field to the model, not the table
  local $Bedrock::Model::Field::RETURN_FIELDS = 1;
  my $model = MyApp::Users->add_field( $dbi, varchar_field( 'address', 100 ), );

  #  my $migration = Bedrock::Model::Migration->new( { model => $model } );
  #
  #  is( $migration->should_migrate(), 1, 'should migrate' )
  #    or diag( Dumper $migration->get_migration );

  # but I didn't need to create the migration object...
  my $migration = $model->get_migration;

  isa_ok( $migration, 'Bedrock::Model::Migration', 'migration object created automagically?' )
    or BAIL_OUT('no migration object');

  is( $migration->should_migrate(), 1, 'should migrate' )
    or diag( Dumper $migration->get_migration );

  eval { return $migration->execute(); };

  ok( !$EVAL_ERROR, 'execute migration' )
    or do {
    diag(
      Dumper(
        [ EVAL_ERROR => [$EVAL_ERROR],
          migration  => [ $migration->get_migration() ]
        ]
      )
    );
    BAIL_OUT('migration failed');
    };

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

  my $new_user = $users->new( $dbi, $id );
  is( $new_user->get('email'),   'someuser@example.com', 'email correct' );
  is( $new_user->get('fname'),   'fred',                 'fname correct' );
  is( $new_user->get('lname'),   'flintstone',           'lname correct' );
  is( $new_user->get('address'), '123 Rockaway Drive',   'address correct' );
};

END {
  eval {
    $dbi->do('drop database foo');
    $dbi->disconnect;
  };

  if ( -e 'users.mdl' ) {
    unlink 'users.mdl';
  }
}

1;

__END__
