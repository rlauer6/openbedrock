use strict;
use warnings;

use Data::Dumper;

use Test::More tests => 6;

BEGIN {

  use Module::Loaded;
  
  no strict 'refs';
  
  *{'Redis::new'} = sub { return 1 };
  *{'Redis::publish'} = sub { };
  
  mark_as_loaded(Redis);

  use_ok('Bedrock::Log::Spooler');
}

my $spooler = Bedrock::Log::Spooler->instance;

$spooler->server('foo');
is($spooler->server, 'foo', 'set/get server');

$spooler->port('1234');
is($spooler->port, '1234', 'set/get port');

$spooler->publish_env(1);
is($spooler->publish_env, 1, 'set/get publish_env');

$spooler->redis_client('redis-client');
is($spooler->redis_client, 'redis-client', 'set/get redis_client');

$spooler->channel('channel');
is($spooler->channel, 'channel', 'set/get channel');

