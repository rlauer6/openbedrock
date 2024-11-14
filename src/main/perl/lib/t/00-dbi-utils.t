#!/usr/bin/env perl

use strict;
use warnings;

use lib qw(.);

use Bedrock qw(slurp_file);
use Bedrock::Test::Utils qw(:all);
use Bedrock::XML;
use Cwd;
use Data::Dumper;
use English qw(-no_match_vars);
use File::Temp qw(tempfile);
use IO::Handle;
use JSON;
use Test::More;

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

    ok( !$EVAL_ERROR, 'successfully loaded dsn' )
      or BAIL_OUT($EVAL_ERROR);

    ok( check_dsn($dsn), 'dsn looks good' );
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
subtest 'read config by name' => sub {
########################################################################

  my $config = {
    bedrock => {
      DBI_DSN      => 'dbi:mysql:bedrock:localhost',
      DBI_USER     => 'wilma',
      DBI_PASSWORD => 'Pebb1e$',
    }
  };

  my $dsn = load_dsn_from_config( $config, { name => 'bedrock' } );

  check_dsn($dsn);
};

########################################################################
subtest 'override w/env vars' => sub {
########################################################################

  my $config = {
    bedrock => {
      DBI_DB   => 'bedrock',
      DBI_HOST => 'localhost',
      DBI_USER => 'wilma',
      DBI_PASS => 'Pebb1e$',
    }
  };

  local $ENV{DBI_HOST} = '127.0.0.1';
  local $ENV{DBI_DB}   = 'foo';

  my $dsn = load_dsn_from_config( $config, { name => 'bedrock', env => 1 } );

  check_dsn($dsn);

  my ( undef, $driver, $database, $host ) = split /[:]/xsm, $dsn;

  ok( $driver eq 'mysql', 'driver is mysql' ) or diag(
    Dumper(
      [ dsn    => $dsn,
        driver => $driver
      ]
    )
  );

  ok( $database eq 'foo', 'database is foo' )
    or diag(
    Dumper(
      [ dsn      => $dsn,
        database => $database,
      ]
    )
    );

  ok( $host eq '127.0.0.1', 'host is 127.0.0.1' )
    or diag(
    Dumper(
      [ dsn  => $dsn,
        host => $host,
      ]
    )
    );

};

########################################################################
subtest 'read raw data_source' => sub {
########################################################################
  check_dsn( load_dsn_from_config( { data_source => 'dbi:mysql:bedrock:localhost' } ) );
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
    dsn_name  => 'customers',
    type      => 'json',
    driver    => 'postgres',
    filename  => $filename,
    database  => 'customers',
    host      => 'myhost',
    username  => 'app',
    password  => 'cu$omer$',
    mysql_ssl => 1,
  );

  ok( -s $filename, 'file exists' );

  my $dsn = load_dsn_from_config($filename);

  check_dsn($dsn);
};

########################################################################
subtest 'multiple configs' => sub {
########################################################################
  my $fh = *DATA;

  seek $fh, $PLAN_END, 0;

  local $RS = undef;

  my $dfh = IO::Handle->new_from_fd( $fh, 'r' );

  my $config = Bedrock::XML->new($fh);

  ok( $config, 'read config' );

  isa_ok( $config, 'Bedrock::Hash' );

  my $dsn = load_dsn_from_config( $config, { name => 'bedrock' } );
  check_dsn($dsn);

  $dsn = load_dsn_from_config( $config, { name => 'sqllite' } );
  check_dsn($dsn);

  $dsn = eval { load_dsn_from_config( $config, 'bedrock' ); };
  my $err = $EVAL_ERROR;

  ok( $err, 'option must be be hashref' );

  like( $err, qr/must\sbe\sa\shash/xsm, 'error message = must be a hash ref' );

  seek $dfh, $PLAN_END, 0;

  $dsn = load_dsn_from_config( $dfh, { name => 'sqllite' } );

  ok( $dsn, 'load dsn using file handle' );

  diag($dsn);

  check_dsn($dsn);
};

1;

__DATA__
read config from file => Read a configuration file and return a DSN
read config => Read a configuration object and return a DSN
read config by name => Read a configuration object and return a DSN
read raw data source => Read a non-named data source
override w/env vars => Override config values with environment variables
create XML file => Create an XML config file
create JSON file => Create a JSON config file
multiple configs => Read multiple configs from config file
END_OF_PLAN  
<object>
  <object name="bedrock">
    <scalar name="driver">mysql</scalar>
    <scalar name="username">fred</scalar>
    <scalar name="password">Fl1nt$t0ne</scalar>
    <scalar name="database">bedrock</scalar>
    <scalar name="mysql_ssl">1</scalar>
  </object>
  <object name="sqllite">
    <scalar name="data-source">dbi:SQLite:dbname=/tmp/test.db</scalar>
  </object>
</object>
