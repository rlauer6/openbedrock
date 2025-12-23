use strict;
use warnings;

use Test::More;
use Time::HiRes qw(sleep);

# 1. Load the module
BEGIN { use_ok('Bedrock::Cache::Memory'); }

# 2. Instantiate
my $cache = new_ok('Bedrock::Cache::Memory');

# 3. Test Basic Set/Get
ok( $cache->set( 'foo', 'bar' ), 'set() returns true' );
is( $cache->get('foo'), 'bar', 'get() retrieves the value' );

# 4. Test Exists
ok( $cache->exists('foo'),  'exists() returns true for existing key' );
ok( !$cache->exists('baz'), 'exists() returns false for missing key' );

# 5. Test Overwrite
$cache->set( 'foo', 'baz' );
is( $cache->get('foo'), 'baz', 'set() overwrites existing value' );

# 6. Test TTL (Time To Live)
$cache->set( 'short_lived', 'value', ttl => 1 );
is( $cache->get('short_lived'), 'value', 'Value exists immediately after set with TTL' );

diag("Sleeping 1.1s to test expiration...");
sleep(1.1);

is( $cache->get('short_lived'), undef, 'Value is undef after TTL expires' );
ok( !$cache->exists('short_lived'), 'exists() returns false after TTL expires' );

# 7. Test Clear (Process-Wide)
$cache->set( 'persistent', 1 );
my $cache2 = Bedrock::Cache::Memory->new();  # Simulation of another instance in same process

is( $cache2->get('persistent'), 1, 'Cache is shared process-wide' );

ok( $cache->clear(), 'clear() returns true' );

is( $cache->get('persistent'),  undef, 'Value is gone after clear()' );
is( $cache2->get('persistent'), undef, 'Value is gone from other instances too' );

done_testing();

1;
