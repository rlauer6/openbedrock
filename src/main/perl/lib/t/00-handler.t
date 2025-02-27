#!/usr/bin/perl

use strict;
use warnings;

use Bedrock qw(create_temp_dir);
use Bedrock::Constants qw(:defaults);
use Bedrock::Test::Utils qw(:all);

use Cwd qw(abs_path getcwd);
use Data::Dumper;
use English qw(-no_match_vars);
use Bedrock::Test::FauxHandler;

use Test::More;

our %TESTS = fetch_test_descriptions(*DATA);

########################################################################

plan tests => 1 + keys %TESTS;

use_ok('Bedrock::Handler');

########################################################################
my $request_handler = Bedrock::Test::FauxHandler->new;

# we should be running tests from src/main/perl directory...
my $cwd = abs_path(getcwd);

my $repo_path = 'src/main/perl/lib';
# if we are running from repo path, set source dir accordingly

my $source_path = $cwd =~ /$repo_path/xsm ? '../../bedrock/config' : $cwd;

my $config_path = create_temp_dir(
  cleanup  => $FALSE,
  dir      => 'config',
  manifest => [
    { source   => $source_path,
      dest_dir => 'config',
      files    => ['tagx.xml']
    },
    { source   => $source_path,
      dest_dir => 'config.d/startup',
      files    => ['mysql-session.xml']
    },
  ],
);

########################################################################
subtest 'config directory exists' => sub {
########################################################################
  ok( -d "$config_path/config", 'config directory exists' )
    or BAIL_OUT('could not create a temporary config directory');

  $config_path = "$config_path/config";
};

########################################################################
subtest 'full_path' => sub {
########################################################################

  my $full_path = Bedrock::Handler::full_path( $config_path, 'tagx', '.xml' );

  is( $full_path, "$config_path/tagx.xml", 'full_path()' )
    or do {
    diag( Dumper( [ full_path => $full_path ] ) );

    BAIL_OUT('could not create full_path');
    };

  ok( -e $full_path, 'tagx.xml exists in config directory' )
    or BAIL_OUT('no tagx.xml found?');
};

my $handler;

########################################################################
subtest 'new' => sub {
########################################################################
  local $ENV{BEDROCK_CONFIG_PATH} = $config_path;

  $handler = eval { return Bedrock::Handler->new($request_handler); };

  isa_ok( $handler, 'Bedrock::Handler' )
    or do {
    diag( Dumper( [ EVAL_ERROR => $EVAL_ERROR, log => $request_handler->log->as_string ] ) );
    BAIL_OUT('could not instantiate a Bedrock::Handler');
    };
};

########################################################################
subtest 'config' => sub {
########################################################################
  my $config = $handler->config;

  isa_ok( $config, 'Bedrock::Config' )
    or do {
    diag( Dumper( [ handler => $handler, $request_handler->log->as_string ] ) );
    BAIL_OUT('could not instantiate a Bedrock::Handler');
    };
};

########################################################################
subtest 'get_module_config' => sub {
########################################################################
  my $config = $handler->config;

  my $input_config = $config->get_module_config('input');

  isa_ok( $input_config, 'Bedrock::Hash' )
    or diag(
    Dumper(
      [ config         => $config,
        session_config => $input_config,
      ]
    )
    );

};

########################################################################
subtest 'is_mod_perl' => sub {
########################################################################
  local $ENV{MOD_PERL} = 'mod_perl';

  ok( $handler->is_mod_perl eq 'mod_perl', 'is_mod_perl' );
};

########################################################################
subtest 'config - no module found' => sub {
########################################################################
  local $ENV{BEDROCK_CONFIG_PATH} = $config_path;

  unlink "${config_path}.d/startup/mysql-session.xml";

  $handler = eval { return Bedrock::Handler->new($request_handler); };

  isa_ok( $handler, 'Bedrock::Handler' )
    or do {
    diag( Dumper( [ EVAL_ERROR => $EVAL_ERROR, log => $request_handler->log->as_string ] ) );
    BAIL_OUT('could not instantiate a Bedrock::Handler');
    };

  my $config = $handler->config;

  my $session_config = $config->get_module_config('usersession');

  ok( !$session_config, 'no BLM::Startup::UserSession module' )
    or diag( Dumper( [ session_config => $session_config ] ) );
};

1;

__DATA__
config directory exists => config directory create for tests
full_path          => return the full path name of a file, supplying a default extension
new                => new constructor with valid path to config directory
config             => return the Bedrock::Config object
get_module_config  => return a startup module configuration object
is_mod_perl        => test if running under mod_perl
config_no_module_found => config object with no BLM::Startup::UserSession object  
END_OF_PLAN
