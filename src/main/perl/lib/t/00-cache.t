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
use Storable qw(thaw);

########################################################################
BEGIN {
########################################################################
  # create the cache

  my %CACHE;

  tie %CACHE, 'IPC::Shareable',  ## no critic
    {
    key     => 'BCFG',
    create  => 1,
    destroy => 1,
    size    => 256 * 1024
    };
}

my $config;
my $request_handler;

$ENV{BEDROCK_CACHE_ENGINE} = 'Shareable';
my $bedrock_handler;

########################################################################
subtest 'read config' => sub {
########################################################################

  $request_handler = Bedrock::Test::FauxHandler->new( log_level => 'trace' );

  my $config_path = abs_path '../../../main/bedrock/config';

  $ENV{BEDROCK_CONFIG_PATH} = $config_path;

  $bedrock_handler = Bedrock::Handler->new( $request_handler, cache => cache() );
  isa_ok( $bedrock_handler,          'Bedrock::Handler' );
  isa_ok( $bedrock_handler->{cache}, 'Bedrock::Cache' );
  $config = $bedrock_handler->config();
};

my %CACHE;
my $cache_key = $PROGRAM_NAME;

########################################################################
subtest 'read cache' => sub {
########################################################################

  tie %CACHE, 'IPC::Shareable',  ## no critic
    {
    key    => 'BCFG',
    create => 0
    };

  ok( keys %CACHE, 'we have some keys...' )
    or do {
    BAIL_OUT('ERROR: nothing in cache?');
    };

  # the cache will contain _config_files_processed which preserves
  # the original config file list that was processed to create the
  # config object. It is removed from the config object itself when
  # the config object is restored from the cache.
  my $cached_config = $bedrock_handler->{cache}->get($cache_key);

  ok( $cached_config, 'got something from the cache' )
    or do {
    BAIL_OUT('ERROR: nothing in cache?');
    };

  cmp_deeply( $cached_config, superhashof($config), 'config and cached config equal' )
    or do {
    diag(
      Dumper(
        [ CACHE  => \%CACHE,
          config => $config
        ]
      )
    );
    BAIL_OUT('ERROR: caching not working?');
    };
};

########################################################################
subtest 'compare object elements' => sub {
########################################################################
  my $cache_config = thaw $CACHE{$cache_key}->{d};

  for ( keys %{$config} ) {
    if ( ref $config->{$_} ) {
      is( ref $cache_config->{$_}, ref $config->{$_}, 'object types are the same' )
        or do {
        diag( Dumper( [ $config->{$_}, $cache_config->{$_} ] ) );

        BAIL_OUT("objects $_ not equal");
        };
    }
    else {
      is( $cache_config->{$_}, $config->{$_}, "scalars [$_] are equal" )
        or BAIL_OUT("scalars not equal");
    }
  }
};

$request_handler->log->close;

# diag( $request_handler->log->as_string );

done_testing;

1;

__END__
