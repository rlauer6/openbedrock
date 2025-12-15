#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;

# Load the module
use_ok('Bedrock::DBI::Locator');

# --- Mock Objects ---
{

  package MockConfig;
  sub new     { bless { data => $_[1] || {} }, shift }
  sub get     { return $_[0]->{data}->{ $_[1] }; }
  sub dbnames { return $_[0]->{data}->{dbnames} || {}; }
}

# --- Test Data ---
my $mock_config_hash = {
  DBI_DSN  => 'dbi:mysql:config_db',
  DBI_USER => 'config_user',
  DBI_PASS => 'config_pass',
  dbnames  => {
    'my_datasource' => {
      DBI_DSN  => 'dbi:mysql:datasource_db',
      DBI_USER => 'ds_user',
      DBI_PASS => 'ds_pass',
    }
  }
};
my $mock_config = MockConfig->new($mock_config_hash);

# --- TESTS ---

subtest 'Strategy 1: Environment Variables (Highest Priority)' => sub {
  # Setup ENV
  local $ENV{DBI_DSN}  = 'dbi:mysql:env_db';
  local $ENV{DBI_USER} = 'env_user';
  local $ENV{DBI_PASS} = 'env_pass';
  local $ENV{DBI_HOST} = 'env_host';

  my ( $dsn, $user, $pass, $host, $socket, $source ) = Bedrock::DBI::Locator->resolve(
    config  => $mock_config,
    options => { username => 'opt_user' }  # Options exist, but Env should win
  );

  is( $dsn,    'dbi:mysql:env_db', 'Environment DSN wins' );
  is( $user,   'env_user',         'Environment User wins' );
  is( $source, 'environment',      'Source reported correctly' );

  # Test Hostname injection logic (Legacy Bedrock feature)
  is( $host, 'env_host', 'Environment Host preserved' );
};

subtest 'Strategy 2: Options (Tag Attributes)' => sub {
  # Ensure ENV is clear so it falls through
  local %ENV = ();

  my ( $dsn, $user, $pass, $host, $socket, $source ) = Bedrock::DBI::Locator->resolve(
    config  => $mock_config,
    options => {
      'data-source' => 'dbi:mysql:option_db',
      'username'    => 'option_user',
      'password'    => 'option_pass'
    }
  );

  is( $dsn,    'dbi:mysql:option_db', 'Options DSN wins over config' );
  is( $user,   'option_user',         'Options User wins over config' );
  is( $source, 'options',             'Source reported as options' );
};

subtest 'Strategy 3: Data Sources (XML Lookup)' => sub {
  local %ENV = ();

  # Pass the 'dsn' option which triggers the lookup
  my ( $dsn, $user, $pass, $host, $socket, $source ) = Bedrock::DBI::Locator->resolve(
    config  => $mock_config,
    options => { dsn => 'my_datasource' }
  );

  is( $dsn,    'dbi:mysql:datasource_db', 'Lookup DSN found' );
  is( $user,   'ds_user',                 'Lookup User found' );
  is( $source, 'data_sources',            'Source reported as data_sources' );
};

subtest 'Strategy 4: Config Object (Lowest Priority)' => sub {
  local %ENV = ();

  # No options, no env -> fallback to config object
  my ( $dsn, $user, $pass, $host, $socket, $source ) = Bedrock::DBI::Locator->resolve(
    config  => $mock_config,
    options => {}
  );

  is( $dsn,    'dbi:mysql:config_db', 'Config DSN used as fallback' );
  is( $user,   'config_user',         'Config User used as fallback' );
  is( $source, 'config',              'Source reported as config' );
};

subtest 'Edge Case: Mixed Partial Configs' => sub {
  # If Options has User but no DSN, it should keep looking?
  # OR (Current behavior) it might fail if the strategy logic is strict.
  # Based on your SQLConnector.pm code: It stops at the first strategy that provides BOTH DSN and USER.

  local %ENV = ();

  my ( $dsn, $user, $pass, $host, $socket, $source ) = Bedrock::DBI::Locator->resolve(
    config  => $mock_config,
    options => {
      username => 'just_a_user'  # No DSN here
    }
  );

  # Since Options didn't have DSN, it should skip Options and find Config
  is( $dsn,  'dbi:mysql:config_db', 'Skipped incomplete Options strategy' );
  is( $user, 'config_user',         'Fell back to Config user' );
};

done_testing();

1;
