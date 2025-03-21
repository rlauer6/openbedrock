#!/usr/bin/env perl

use strict;
use warnings;

use Bedrock;
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

########################################################################
BEGIN {
########################################################################
  # create the cache

  my %CACHE;

  tie %CACHE, 'IPC::Shareable',  ## no critic (ProhibitTies)
    {
    key     => 'BCFG',
    create  => 1,
    destroy => 1,
    size    => 256 * 1024
    };

  local $ENV{BEDROCK_CACHE_ENABLED} = 'on';

  stderr_like( sub { use_ok('Bedrock::Handler'); }, qr/successfully/xsm, 'initialize caching' );
}

########################################################################
sub main {
########################################################################

  my $config;
  my $request_handler;

########################################################################
  subtest 'read config' => sub {
########################################################################
    $request_handler = Bedrock::Test::FauxHandler->new( log_level => 'trace' );

    my $config_path = abs_path '../../../main/bedrock/config';

    local $ENV{BEDROCK_CONFIG_PATH} = $config_path;

    local $ENV{BEDROCK_CACHE_ENABLED} = 'on';

    my $handler = Bedrock::Handler->new($request_handler);

    $config = $handler->config();

    isa_ok( $handler, 'Bedrock::Handler' );
  };

  my %CACHE;
  my $cache_key = $PROGRAM_NAME;

########################################################################
  subtest 'read cache' => sub {
########################################################################

    tie %CACHE, 'IPC::Shareable', { key => 'BCFG', create => 0 };  ## no critic (ProhibitTies)

    ok( keys %CACHE, 'caching' )
      or diag( Dumper [ keys => keys %CACHE ] );

    # the cache will contain _config_files_processed which preserves
    # the original config file list that was processed to create the
    # config object. It is removed from the config object itself when
    # the config object is restored from the cache.
    cmp_deeply( $CACHE{$cache_key}, superhashof($config), 'config and cached config equal' )
      or diag( Dumper( [ CACHE => \%CACHE, config => $config ] ) );
  };

########################################################################
  subtest 'compare object elements' => sub {
########################################################################
    my $cache_config = $CACHE{$cache_key};

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

  return 0;
}

exit main();

1;

__END__
