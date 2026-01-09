#!/usr/bin/env perl

use strict;
use warnings;

use Apache::Bedrock qw(cache);
use Bedrock;
use Bedrock::Handler;
use Bedrock::BedrockJSON;
use Bedrock::Constants qw(:booleans);
use Bedrock::Test::FauxHandler;
use Carp::Always;
use Cwd qw(abs_path cwd);
use Data::Dumper;
use English qw(-no_match_vars);
use IPC::Shareable;
use Test::Deep;
use Test::More;
use Test::Output;
use Storable qw(thaw nfreeze);

# Load the module to apply the Monkey Patch
use Bedrock::Cache::Shareable;

# Use the same GLUE key as defined in the module
my $glue = 'BCFG';

# Pre-declare the cache variable for "backdoor" verification
my %raw_ipc_cache;

########################################################################
subtest 'initialize shared memory (Server Simulation)' => sub {
########################################################################
  # Clean up any previous segments to ensure a clean slate
  IPC::Shareable->clean_up;

  my %options = (
    key     => $glue,
    create  => 1,
    destroy => 1,
    size    => 5 * 1024 * 1024,  # 5MB Head Segment
    mode    => 0666,
  );

  # Create the segment manually (mimicking the parent Apache process)
  # We use the raw tie here to verify the low-level connection works
  eval { tie %raw_ipc_cache, 'IPC::Shareable', $glue, \%options; };

  is( $EVAL_ERROR, '', 'Shared memory segment created successfully' );
  ok( tied %raw_ipc_cache, 'Backdoor variable tied to shared memory' );
};

my $config;
my $request_handler;

# Force the engine to Shareable for this test
$ENV{BEDROCK_CACHE_ENGINE} = 'Shareable';
$ENV{BEDROCK_CACHE_KEY}    = $glue;

my $bedrock_handler;

########################################################################
subtest 'instantiate bedrock handler with cache' => sub {
########################################################################

  $request_handler = Bedrock::Test::FauxHandler->new( log_level => 'trace' );

  my $config_path = abs_path '../../../main/bedrock/config';

  $ENV{BEDROCK_CONFIG_PATH} = $config_path;

  # This instantiates Bedrock::Cache -> Bedrock::Cache::Shareable
  $bedrock_handler = Bedrock::Handler->new( $request_handler, cache => cache() );

  isa_ok( $bedrock_handler,        'Bedrock::Handler' );
  isa_ok( $bedrock_handler->cache, 'Bedrock::Cache' );

  # Verify we loaded the correct engine
  isa_ok( $bedrock_handler->cache->{engine}, 'Bedrock::Cache::Shareable' );

  $config = $bedrock_handler->config();
  ok( $config, 'Config object loaded' );
};

my $cache_key = $PROGRAM_NAME;

########################################################################
subtest 'verify segment stability (The "Ghost Segment" Test)' => sub {
########################################################################
  # 1. Count current segments on the system
  my $initial_segments = IPC::Shareable->ipcs();
  diag("Initial Shared Memory Segments: $initial_segments");

  # 2. Store a complex object via the Bedrock Cache API
  # The config object contains nested hashes and arrays.
  # Without the monkey patch, this would spawn new segments.
  $bedrock_handler->cache->set( $cache_key, $config );

  # 3. Store another complex object to be sure
  $bedrock_handler->cache->set( 'stress_test', { foo => [ 1 .. 100 ], bar => { baz => 'qux' } } );

  # 4. Count segments again
  my $final_segments = IPC::Shareable->ipcs();
  diag("Final Shared Memory Segments: $final_segments");

  # 5. Assert equality
  is( $final_segments, $initial_segments, 'No new shared memory segments were created (Monkey Patch Verified)' )
    or diag("FAILURE: Segment count increased from $initial_segments to $final_segments");
};

########################################################################
subtest 'verify data integrity via backdoor (Envelope Check)' => sub {
########################################################################
  # Access the data via the raw %raw_ipc_cache tied in the first subtest.
  # This verifies that the data physically exists in the shared segment.

  ok( exists $raw_ipc_cache{$cache_key}, 'Key exists in raw IPC hash' );

  # Retrieve the value directly from the tied hash
  # IPC::Shareable (patched) should thaw the envelope automatically.
  my $envelope = $raw_ipc_cache{$cache_key};

  ok( $envelope, 'Got envelope from raw cache' );
  is( ref $envelope, 'HASH', 'Envelope is a hash reference' );

  # Verify Envelope Structure
  ok( exists $envelope->{d}, 'Envelope has payload key (d)' );
  ok( exists $envelope->{e}, 'Envelope has expiry key (e)' );

  # Verify Payload Format
  # With "Smart Serialization", the payload is the actual object (ref), not a string.
  my $payload = $envelope->{d};

  # FIX: Compare the ref type of the payload to the original object.
  # If $config is 'Bedrock::Config', $payload must also be 'Bedrock::Config'.
  is( ref $payload, ref $config, 'Payload type matches original object (Native Serialization verified)' );

  # We no longer need to thaw() manually because IPC::Shareable did it for us.
  cmp_deeply( $payload, superhashof($config), 'Retrieved config matches original via backdoor' );
};

########################################################################
subtest 'verify data integrity via API' => sub {
########################################################################
  # Standard API usage (what the app sees)
  my $cached_config = $bedrock_handler->cache->get($cache_key);

  ok( $cached_config, 'Got config from cache API' );
  cmp_deeply( $cached_config, superhashof($config), 'Config matches original via API' );
};

########################################################################
subtest 'compare object elements detail' => sub {
########################################################################
  my $cached_config = $bedrock_handler->cache->get($cache_key);

  for ( keys %{$config} ) {
    if ( ref $config->{$_} ) {
      is( ref $cached_config->{$_}, ref $config->{$_}, "object types are the same for key [$_]" );
    }
    else {
      is( $cached_config->{$_}, $config->{$_}, "scalars [$_] are equal" );
    }
  }
};

########################################################################
subtest 'cleanup' => sub {
########################################################################
  # Clear via API
  $bedrock_handler->cache->clear();

  # Verify via backdoor
  my $count = scalar keys %raw_ipc_cache;
  is( $count, 0, 'Cache cleared successfully' );
};

$request_handler->log->close;

done_testing;

1;
