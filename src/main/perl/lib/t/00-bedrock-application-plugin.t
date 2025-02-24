use strict;
use warnings;

package BLM::Startup::Foo;

use parent qw(Bedrock::Application::Plugin);

########################################################################
package main;
########################################################################

use Bedrock::BedrockConfig;
use Bedrock::Constants qw(:defaults :chars :booleans);
use Bedrock::Test::FauxContext qw(bind_module);
use Cwd;
use Data::Dumper;
use DBI;
use English qw(-no_match_vars);
use Scalar::Util qw(openhandle);
use Test::More;

use_ok('Bedrock::Application::Plugin');

my $plugin;

########################################################################
subtest 'TIEHASH' => sub {
########################################################################
  my $config = eval { return Bedrock::Config->new( \*DATA ); };

  if ( !$config ) {
    diag($EVAL_ERROR);
    BAIL_OUT('could not read config');
  }

  my $module = $config->{module};

  my $ctx = Bedrock::Test::FauxContext->new( CONFIG => {} );
  $plugin = bind_module( $ctx, $config );

  ok( !$EVAL_ERROR, 'bound module' );

  isa_ok( $plugin, $module )
    or do {
    diag( Dumper( [$plugin] ) );
    BAIL_OUT('plugin is not instantiated properly');
    };
};

done_testing;

########################################################################
END {

}

1;

__DATA__
<object>
 <scalar name="binding">foo</scalar>
 <scalar name="module">BLM::Startup::Foo</scalar>
 <object name="config">
 </object>
</object>
