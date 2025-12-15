#!/usr/bin/perl

use strict;
use warnings;
use Test::More;
use Test::MockModule;
use Test::Exception;

# 1. Load the Target Module first
use_ok('Bedrock::Context');

# --- MOCKING INFRASTRUCTURE ---

# Mock Bedrock::Config
{

  package MockConfig;
  sub new { bless {}, shift }
  sub get { return $_[0]->{ $_[1] }; }
}

# Mock the Locator
my $mock_locator = Test::MockModule->new('Bedrock::DBI::Locator');
$mock_locator->mock(
  'resolve',
  sub {
    my ( $class, %args ) = @_;
    if ( $args{config}->get('has_db') ) {
      return ( 'dbi:mysql:test', 'mock_user', 'mock_pass', 'localhost' );
    }
    return undef;
  }
);

# Mock the IMPORTED easy_connect inside Bedrock::Context
my $mock_ctx_subs  = Test::MockModule->new('Bedrock::Context');
my $connect_called = 0;

$mock_ctx_subs->mock(
  'easy_connect',
  sub {
    $connect_called++;
    return bless {
      Active      => 1,
      AutoCommit  => 1,
      ping_result => 1
      },
      'MockDBIHandle';
  }
);

# Mock the DBI Handle
# Use a global flag to track rollback calls since cleanup() swallows exceptions
my $rollback_called_flag = 0;
{

  package MockDBIHandle;
  sub ping { return $_[0]->{ping_result}; }
  sub rollback { $rollback_called_flag = 1; return 1; }
  sub disconnect { $_[0]->{Active} = 0; }
}

# --- TESTS ---

subtest 'Scenario 1: Context with NO Database Config' => sub {
  my $config = MockConfig->new();
  $config->{has_db} = 0;

  my $ctx = Bedrock::Context->new(
    config  => $config,
    request => bless( {}, 'MockRequest' )
  );

  is( $ctx->get_shared_dbi(), undef, 'Returns undef when Locator finds nothing' );
  is( $connect_called,        0,     'easy_connect was NOT called' );
};

subtest 'Scenario 2: Context WITH Database Config' => sub {
  my $config = MockConfig->new();
  $config->{has_db} = 1;

  my $ctx = Bedrock::Context->new(
    config  => $config,
    request => bless( {}, 'MockRequest' )
  );

  # Test A: Initial Connection
  $connect_called = 0;
  my $dbh = $ctx->get_shared_dbi();

  ok( $dbh, 'Returned a DBI handle' );
  isa_ok( $dbh, 'MockDBIHandle' );
  is( $connect_called,              1, 'easy_connect was called exactly once' );
  is( $dbh->{mysql_auto_reconnect}, 1, 'Auto-reconnect flag was set' );

  # Test B: Caching
  my $dbh2 = $ctx->get_shared_dbi();
  is( $connect_called, 1,     'easy_connect was NOT called again (cached)' );
  is( $dbh,            $dbh2, 'The exact same handle reference was returned' );
};

subtest 'Scenario 3: Cleanup and Safety' => sub {
  my $config = MockConfig->new();
  $config->{has_db} = 1;
  my $ctx = Bedrock::Context->new( config => $config, request => {} );

  my $dbh = $ctx->get_shared_dbi();

  # Simulate a "Dirty" Plugin (Uncommitted transaction)
  $dbh->{AutoCommit} = 0;
  $rollback_called_flag = 0;  # Reset flag

  # Run cleanup. It should swallow the error, but trigger the rollback.
  lives_ok { $ctx->cleanup() } 'Cleanup ran without crashing';

  ok( $rollback_called_flag, 'Rollback was called internally' );
  is( $dbh->{Active},    0,     'Handle was disconnected' );
  is( $ctx->_shared_dbi, undef, 'Internal accessor was cleared' );
};

subtest 'Scenario 4: Reconnection after disconnect' => sub {
  my $config = MockConfig->new();
  $config->{has_db} = 1;
  my $ctx = Bedrock::Context->new( config => $config, request => {} );

  my $dbh = $ctx->get_shared_dbi();

  # Simulate DB disconnect
  $dbh->{ping_result} = 0;

  $connect_called = 0;
  my $dbh_new = $ctx->get_shared_dbi();

  is( $connect_called, 1, 'easy_connect called again because ping failed' );
  isnt( $dbh, $dbh_new, 'A fresh handle was returned' );
};

done_testing();

1;
