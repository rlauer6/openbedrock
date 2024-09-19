#!/usr/bin/env perl

use strict;
use warnings;

use Cwd;
use Test::More tests => 10;
use IO::Scalar;

use lib qw(.);

use Bedrock::Constants qw(:defaults);
use Data::Dumper;

use_ok('Bedrock::BedrockConfig');

my $config_path = $ENV{BEDROCK_CONFIG_PATH} // cwd;

my $config_file = sprintf '%s/tagx.xml', $config_path;

if ( !-e $config_file ) {
  BAIL_OUT('tagx.xml not found');
}

my $config = eval { return Bedrock::Config->new($config_file); };

isa_ok( $config, 'Bedrock::Config' )
  or BAIL_OUT("could not read config file: $config_file");

my $modules = $config->get_module_config;
isa_ok( $modules, 'ARRAY', 'get_module_config()' );

my $mysql_session_config_file = sprintf '%s/mysql-session.xml', $config_path;

if ( !-e $mysql_session_config_file ) {
  BAIL_OUT("$mysql_session_config_file not found!");
}

my $user_session_config = Bedrock::Config->new($mysql_session_config_file);

push @{$modules}, $user_session_config;

my $session_config = $config->get_module_config('Session');

isa_ok( $session_config, 'Bedrock::Hash', 'get_module_config("Session")' )
  or do {
  diag( Dumper( [$modules] ) );
  BAIL_OUT('did not find Session');
  };

like( $session_config->{param}, qr/session/xsmi, 'get_module_config("Session")' )
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

my $config_xml_tpl = <<'END_OF_XML';
<object name="test">
  <scalar name="foo">biz</scalar>
  <scalar name="MERGE_CONFIG">%s</scalar>
</object>
END_OF_XML

my $xml = sprintf $config_xml_tpl, 'no';

my $fh = IO::Scalar->new( \$xml, 'r' );

$merged_config = $new_config->merge($fh);

ok( !$merged_config->{foo}, 'MERGE_CONFIG = no' );

$xml = sprintf $config_xml_tpl, 'yes';

$fh = IO::Scalar->new( \$xml, 'r' );

$merged_config = $new_config->merge($fh);

ok( $merged_config->{foo}, 'MERGE_CONFIG = yes' );

__END__

1;
