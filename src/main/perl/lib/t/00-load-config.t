#!/usr/bin/env perl

use strict;
use warnings;

use Bedrock::LoadConfig qw(load_config locate_file validate_config_paths);
use Carp;
use English qw(-no_match_vars);
use File::Temp qw(tempfile tempdir);
use IO::String;
use Test::More;
use Test::Output;

########################################################################
subtest 'Loading from a file' => sub {
########################################################################
  my ( $fh, $tempfile ) = tempfile( SUFFIX => '.json' );

  print {$fh} '{ "key": "file_test" }';
  close $fh or croak "Failed to close tempfile: $OS_ERROR";

  my $file_config = load_config($tempfile);
  is_deeply( $file_config->{key}, "file_test", 'Load JSON from filename' );

  ok( exists $file_config->{_config_path}, 'Filename test: _config_path exists' );
  is( $file_config->{_config_path}, $tempfile, 'Filename test: _config_path is correct' );

  unlink $tempfile or carp "Warning: failed to remove tempfile: $OS_ERROR";
};

########################################################################
subtest 'Loading from a filehandle' => sub {
########################################################################
  my $json_fh = IO::String->new('{ "key": "fh_test" }');

  stderr_like(
    sub { load_config($json_fh); },
    qr/unable to detect filename/,
    'load_config warns on inability to find filename'
  );

  my $fh_config = load_config($json_fh);

  is_deeply( $fh_config->{key}, "fh_test", 'Load JSON from filehandle' );
  ok( exists $fh_config->{_config_path}, 'Filehandle test: _config_path exists' );
  is( $fh_config->{_config_path}, '<filehandle>', 'Filehandle test: _config_path is correct' );
};

########################################################################
subtest 'locate_file() error handling' => sub {
########################################################################
  eval { locate_file("nonexistent.json") };
  like( $EVAL_ERROR, qr/Config file not found:/, 'locate_file fails on nonexistent file' );
};

########################################################################
subtest 'validate_config_paths() behavior' => sub {
########################################################################
  my $valid_dir       = tempdir( CLEANUP => 1 );
  my $valid_d_variant = "$valid_dir.d";

  mkdir $valid_d_variant or croak "Failed to create directory: $OS_ERROR";

  my @valid_paths = validate_config_paths($valid_dir);
  is_deeply(
    \@valid_paths,
    [ $valid_dir, $valid_d_variant ],
    'validate_config_paths returns the correct valid directories'
  );

  my @invalid_paths = validate_config_paths('this/path/does/not/exist');
  is( scalar @invalid_paths, 0, 'validate_config_paths returns an empty list for nonexistent directories' );
};

########################################################################
subtest 'DATA' => sub {
########################################################################
  my $data_config = load_config( \*DATA );

  is_deeply( $data_config->{key}, 'data_test', 'Load JSON from __DATA__' );

  ok( exists $data_config->{_config_path}, '__DATA__ test: _config_path exists' );

  is( $data_config->{_config_path}, $PROGRAM_NAME, '__DATA__ test: _config_path is correct' );
};

done_testing;

1;

__DATA__
{ "key": "data_test" }
