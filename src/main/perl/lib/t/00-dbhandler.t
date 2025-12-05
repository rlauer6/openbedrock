#!/usr/bin/env perl

use strict;
use warnings;

use Bedrock::Constants qw(:booleans);
use Data::Dumper;
use DBI;
use English qw(-no_match_vars);
use File::Temp qw(tempfile);
use IO::Handle;
use JSON;
use Scalar::Util qw(openhandle);
use Test::More;

plan skip_all => 'no DBI_USER set'
  if ( !$ENV{DBI_USER} || !$ENV{DBI_PASS} );

eval {
  my $host = $ENV{DBI_HOST} // '127.0.0.1';

  my $dbi = DBI->connect( 'dbi:mysql::' . $host, $ENV{DBI_USER}, $ENV{DBI_PASS} );
  return $dbi->disconnect;
};

plan skip_all => 'no database connection'
  if $EVAL_ERROR;

use_ok('BLM::DBHandler');

our $DATA_POSITION = tell *DATA;

########################################################################
subtest 'version' => sub {
########################################################################
  like( $BLM::DBHandler::VERSION, qr/\A[\d.]+\z/xsm, 'version' );
};

########################################################################
subtest 'easy_connect: environment variables' => sub {
########################################################################
  BLM::DBHandler->import(qw(easy_connect is_dbi));

  my $dbi = eval {

    return easy_connect(
      user     => $ENV{DBI_USER},
      password => $ENV{DBI_PASS},
      host     => $ENV{DBI_HOST} // 'localhost',
    );
  };

  ok( $dbi, 'easy_connect()' )
    or diag($EVAL_ERROR);

  ok( is_dbi($dbi), 'easy_connect() returns a DBI object' )
    or diag( Dumper( [ dbi => $dbi ] ) );

  $dbi->disconnect;
};

########################################################################
subtest 'easy_connect: file handle' => sub {
########################################################################
  my $password = $ENV{DBI_PASS};

  local %ENV = ();
  $ENV{DBI_PASS} = $password;

  my $fh = *DATA;
  seek $fh, $DATA_POSITION, 0;

  ok( openhandle($fh), 'is an open file handle to a data-source file' );

  my $dbi = easy_connect( $fh, undef, 1 );

  ok( is_dbi($dbi) && !$EVAL_ERROR, 'file handle, no name' );

  $dbi->disconnect;
};

########################################################################
subtest 'easy_connect: configuration file' => sub {
########################################################################
  my $fh = *DATA;

  seek $fh, $DATA_POSITION, 0;

  my $obj = Bedrock::XML->new($fh);

  my ( $fd, $filename ) = tempfile( 'jsonXXXXX', UNLINK => $TRUE, TMPDIR => $TRUE );

  print {$fd} JSON->new->pretty->encode( $obj->devolve );

  close $fd;

  my $dbi = easy_connect( data_source => $filename, name => 'bedrock', env => 1 );

  ok( is_dbi($dbi) && !$EVAL_ERROR, 'JSON file, with name' );
};

done_testing;

1;

__DATA__
<object>
  <object name="bedrock">
    <scalar name="username">root</scalar>
    <scalar name="database"></scalar>
    <scalar name="host">127.0.0.1</scalar>
    <scalar name="mysql_ssl">1</scalar>
  </object>
</object>
