#!/usr/bin/env perl

use strict;
use warnings;

use lib qw(.);

use Bedrock::Test::Utils qw(:all);
use Bedrock qw(slurp_file);
use Bedrock::XML;
use JSON;
use Data::Dumper;
use English qw(-no_match_vars);
use Test::More;
use File::Temp qw(tempfile);
use Cwd;

our %TESTS = fetch_test_descriptions(*DATA);

########################################################################

plan tests => 2 + keys %TESTS;

use_ok('Bedrock::DBI::Utils');

eval {
  Bedrock::DBI::Utils->import('load_dsn_from_config');
  Bedrock::DBI::Utils->import('create_dsn_file');
};

ok( !$EVAL_ERROR );

########################################################################
sub check_dsn {
########################################################################
  my ($dsn) = @_;

  ok( $dsn, 'created dsn' );

  ok( $dsn =~ /^dbi:/xsm, 'smells likes a dsn' )
    or diag( Dumper( [ dsn => $dsn ] ) );

  my ( undef, $driver, $database, $host ) = split /:/xsm, $dsn;

  ok( defined $driver, 'driver ok' );

  ok( defined $database, 'database ok' );

  ok( defined $host, 'host ok' );

  return $TRUE;
}

########################################################################
subtest 'read config from file' => sub {
########################################################################
  my @paths = sprintf '%s/../../bedrock/config/data-sources.xml', cwd;

  push @paths, sprintf '%s/share/config/data-sources.xml', cwd;
  my ($config_file) = map { -e $_ ? $_ : () } @paths;

  SKIP: {
    skip 'no data-sources file found', 1 if !$config_file;

    my $dsn = eval { load_dsn_from_config($config_file) };

    ok( check_dsn($dsn) );
  }
};

########################################################################
subtest 'read config' => sub {
########################################################################

  my $config = {
    bedrock => {
      DBI_DSN      => 'dbi:mysql:bedrock:localhost',
      DBI_USER     => 'wilma',
      DBI_PASSWORD => 'Pebb1e$',
    }
  };

  my $dsn = load_dsn_from_config($config);

  check_dsn($dsn);

  check_dsn( load_dsn_from_config( { data_source => $dsn } ) );
};

########################################################################
subtest 'create XML config' => sub {
########################################################################
  my ( $fh, $filename ) = tempfile(
    'data-source-XXXX',
    tmpdir => $TRUE,
    UNLINK => $TRUE,
  );
  close $fh;

  create_dsn_file(
    type     => 'xml',
    driver   => 'postgres',
    filename => $filename,
    database => 'customers',
    host     => 'myhost',
  );

  ok( -s $filename, 'file exists' );

  my $dsn = load_dsn_from_config($filename);

  check_dsn($dsn);
};

########################################################################
subtest 'create JSON config' => sub {
########################################################################
  my ( $fh, $filename ) = tempfile(
    'data-source-XXXX',
    tmpdir => $TRUE,
    UNLINK => $TRUE,
  );

  create_dsn_file(
    type     => 'json',
    driver   => 'postgres',
    filename => $filename,
    database => 'customers',
    host     => 'myhost',
  );

  ok( -s $filename, 'file exists' );

  my $dsn = load_dsn_from_config($filename);

  check_dsn($dsn);

};

1;

__DATA__
read config from file => Read a configuration file and return a DSN
read config => Read a configuration object and return a DSN
create XML file => Create an XML config file
create JSON file => Create a JSON config file
END_OF_PLAN  
