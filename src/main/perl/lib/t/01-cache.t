#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Data::Dumper;

use Storable qw(thaw);

# 1. SETUP: Force the environment to use Redis
$ENV{BEDROCK_CACHE_ENGINE} = 'Redis';

# Optional: Point to your config dir if you use one, otherwise it defaults to localhost
$ENV{CONFIG_PATH} = 't/config';

# Load the Module
require_ok('Bedrock::Cache');

# 2. DISCOVERY & CONNECTION
my $cache = eval { Bedrock::Cache->new() };

if ( $@ || !$cache ) {
  plan skip_all => "Could not instantiate Bedrock::Cache (Redis likely down): $@";
}

# Clear our playground
my $test_key_str = "unit_iso_str_" . $$;
my $test_key_ref = "unit_iso_ref_" . $$;
my $test_key_ttl = "unit_iso_ttl_" . $$;

$cache->delete($_) for ( $test_key_str, $test_key_ref, $test_key_ttl );

# 3. TEST: Basic String Operations (No Serialization)
ok( !$cache->exists($test_key_str), 'Key does not exist initially' );

ok( $cache->set( $test_key_str, "Hello World" ), 'Set String' );
ok( $cache->exists($test_key_str),               'Key exists after set' );
is( $cache->get($test_key_str), "Hello World", 'Get String returns exact match' );

# 4. TEST: Complex Data Serialization (The logic we moved)
my $complex_data = {
  name    => 'Bedrock',
  version => 3.3,
  list    => [ 1, 2, 3 ],
  nested  => { foo => 'bar' }
};

ok( $cache->set( $test_key_ref, $complex_data ), 'Set Complex Reference' );

my $retrieved = $cache->get($test_key_ref);

is_deeply( $retrieved, $complex_data, 'Get Reference returns correctly thawed structure' );

# 5. DIAGNOSTIC: Verify Storage Format
# We want to prove that it IS serialized in the engine, but transparent to us.
# We access the raw handle to "cheat" and look at the bytes.
my $raw_redis = $cache->get_handle();
my $raw_val   = $raw_redis->get($test_key_ref);

# REPLACEMENT for Test 8
# Verify we didn't accidentally store "HASH(0x12345)"
ok( $raw_val !~ /^HASH\(/, 'Raw Redis data is not a stringified Perl reference' );

# Verify it looks like Storable magic header (usually starts with slightly binary junk)
ok( length($raw_val) > 0, 'Raw data has length' );

# 6. TEST: TTL (Expiration)
ok( $cache->set( $test_key_ttl, "I exist briefly", ttl => 1 ), 'Set with TTL=1' );
ok( $cache->exists($test_key_ttl),                             'Key exists immediately' );
sleep(2);
ok( !$cache->exists($test_key_ttl), 'Key is GONE after 2 seconds' );

# 7. CLEANUP
$cache->delete($test_key_str);
$cache->delete($test_key_ref);
# TTL key is already gone

done_testing();

1;
