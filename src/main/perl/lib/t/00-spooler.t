use strict;
use warnings;

use Data::Dumper;

use Test::More tests => 2;

BEGIN {

  use Module::Loaded;
  
  no strict 'refs';
  
  *{'Redis::new'} = sub { return 1 };
  *{'Redis::publish'} = sub { };
  
  mark_as_loaded(Redis);

  use_ok('Bedrock::Log::Spooler');
}

my $spooler = Bedrock::Log::Spooler->instance;
isa_ok($spooler, 'Bedrock::Log::Spooler');

