use strict;
use warnings;

use Cwd qw{abs_path};
use Data::Dumper;

use Bedrock::BedrockJSON;
Bedrock::JSON->import('evolve');

use IPC::Shareable;

use Test::More tests => 5;

BEGIN {
  # create the cache

  my %X;

  tie %X, 'IPC::Shareable',  ## no critic (ProhibitTies)
    {
    key     => 'BCFG',
    create  => 1,
    destroy => 1,
    size    => 256 * 1024
    };

  local $ENV{BEDROCK_CACHE_ENABLED} = 'on';

  use_ok('Bedrock::Handler');
}

require 't/faux-handler.pl';

my $log = q{};

my $request_handler = faux_request_handler( \$log );

my $config_path = abs_path '../../../main/bedrock/config';

local $ENV{BEDROCK_CONFIG_PATH} = $config_path;

my $handler = Bedrock::Handler->new($request_handler);
my $config  = $handler->config();

isa_ok( $handler, 'Bedrock::Handler' );

my %FOO;
tie %FOO, 'IPC::Shareable', { key => 'BCFG', create => 0 };  ## no critic (ProhibitTies)

diag( Dumper [ keys %FOO ] );

ok( keys %FOO, 'caching' );

is_deeply( $FOO{'t/00-cache.t'}, $config );

is_deeply( $FOO{'t/00-cache.t'}, $config );

my $foo_config = $FOO{'t/00-cache.t'};

for ( keys %{$config} ) {
  if ( ref $config->{$_} && ref $config->{$_} ne ref $foo_config->{$_} ) {
    diag( Dumper( [ $config->{$_}, $foo_config->{$_} ] ) );

    BAIL_OUT("objects $_ not equal");
  }
  elsif ( !ref $config->{$_} && $config->{$_} ne $foo_config->{$_} ) {
    BAIL_OUT("scalars not equal");
  }
}

1;

__END__
