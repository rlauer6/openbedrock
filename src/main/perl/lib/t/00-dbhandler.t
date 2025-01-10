#!/usr/bin/env perl

use strict;
use warnings;

BEGIN {
  use lib qw(.);
}

use Bedrock::Constants qw(:booleans);
use Data::Dumper;
use English qw(-no_match_vars);
use File::Temp qw(tempfile);
use IO::Handle;
use JSON;
use Scalar::Util qw(openhandle);
use Test::More;

plan skip_all => 'no DBI_USER set'
  if !$ENV{DBI_USER} || !$ENV{DBI_PASS};

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
  local %ENV = ();

  my $fh = *DATA;
  seek $fh, $DATA_POSITION, 0;

  ok( openhandle($fh), 'is an open file handle' );

  my $dbi = easy_connect($fh);

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

  my $dbi = easy_connect( data_source => $filename, name => 'bedrock' );

  ok( is_dbi($dbi) && !$EVAL_ERROR, 'JSON file, with name' );
};

done_testing;

1;

__DATA__
<object>
  <object name="bedrock">
    <scalar name="username">fred</scalar>
    <scalar name="password">flintstone</scalar>
    <scalar name="database">bedrock</scalar>
  </object>
</object>
