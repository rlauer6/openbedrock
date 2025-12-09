use strict;
use warnings;

package MyApp::Users;

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
  first_name => Bedrock::Model::Field->new(
    { field => 'first_name',
      type  => 'varchar(32)',
      null  => 'no',
    }
  ),
  last_name => Bedrock::Model::Field->new(
    { field => 'last_name',
      type  => 'varchar(32)',
      null  => 'no',
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

use Data::Dumper;
use English qw(-no_match_vars);
use Test::More;

use_ok('Bedrock::Model::Handler');

my $create_statement = eval { return MyApp::Users->create_table() };

ok( !$EVAL_ERROR, 'no errors' )
  or do {
  diag($EVAL_ERROR);
  BAIL_OUT('ERROR: could not describe table');
  };

like( $create_statement, qr/^create\s+table/xsm, 'create statement' )
  or diag($create_statement);

done_testing;

1;

__END__
