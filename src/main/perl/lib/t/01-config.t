#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 8;

use lib qw{.};

use Bedrock::Constants qw{:defaults};
use Data::Dumper;

use_ok('Bedrock::BedrockConfig');

my $config = Bedrock::Config->new("$DEFAULT_BEDROCK_CONFIG_PATH/tagx.xml");

isa_ok( $config, 'Bedrock::Config' );

my $modules = $config->get_module_config;
isa_ok( $modules, 'ARRAY', 'get_module_config()' );

my $user_session_config
  = Bedrock::Config->new("$DEFAULT_BEDROCK_CONFIG_PATH/mysql-session.xml");
push @{$modules}, $user_session_config;

my $session_config = $config->get_module_config('Session');

isa_ok( $session_config, 'Bedrock::Hash', 'get_module_config("Session")' )
  or do {
  diag( Dumper( [$modules] ) );
  BAIL_OUT('did not find Session');
  };

like( $session_config->{param},
  qr/session/xsmi, 'get_module_config("Session")' )
  or diag( Dumper( [$session_config] ) );

my $input_config = $config->get_module('Input');

isa_ok( $input_config, 'Bedrock::Hash', 'get_module("Input")' )
  or do {
  diag( Dumper( [$input_config] ) );
  BAIL_OUT('could not find Input');
  };

$input_config->{config}    = { foo => 'bar' };
$input_config->{overwrite} = 'yes';

my $new_config = $config->merge_config( { MODULES => [$input_config] } );
isa_ok( $new_config, 'Bedrock::Hash', 'merge_config()' );

my $merged_config = $new_config->get_module_config('input');
is( $merged_config->{foo}, 'bar', 'merge_config()' );

__END__

1;
