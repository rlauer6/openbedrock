#!/usr/bin/env perl

use strict;
use warnings;

use Carp;
use English qw(-no_match_vars);
use File::Basename;
use File::Spec;
use File::Temp qw(tempfile);
use IO::String;
use Test::More;

require 'load-config.pl';  # Ensure we load the module

# 1️⃣ Test a temporary file (must have a valid extension!)
my ( $fh, $tempfile ) = tempfile( SUFFIX => '.json' );  # ✅ Ensure it has a valid extension
print {$fh} '{ "key": "file_test" }';
close $fh;                                              # Close so _load_config() can read it

my $file_config = _load_config($tempfile);
is_deeply( $file_config->{key}, "file_test", 'Load JSON from filename' );
ok( exists $file_config->{_config_path}, 'Filename test: _config_path exists' );
is( $file_config->{_config_path}, $tempfile, 'Filename test: _config_path is correct' );

unlink $tempfile;                                       # ✅ Clean up the temp file

# 2️⃣ Test a filehandle using IO::String
my $json_fh   = IO::String->new('{ "key": "fh_test" }');
my $fh_config = _load_config($json_fh);

is_deeply( $fh_config->{key}, "fh_test", 'Load JSON from filehandle' );
ok( exists $fh_config->{_config_path}, 'Filehandle test: _config_path exists' );
is( $fh_config->{_config_path}, '<filehandle>', 'Filehandle test: _config_path is correct' );

# 3️⃣ Test the __DATA__ section filehandle
my $data_config = _load_config( \*DATA );

is_deeply( $data_config->{key}, "data_test", 'Load JSON from __DATA__' );
ok( exists $data_config->{_config_path}, '__DATA__ test: _config_path exists' );
is( $data_config->{_config_path}, '<filehandle>', '__DATA__ test: _config_path is correct' );

done_testing();

1;  # Always return true for module-style test scripts

__DATA__
{ "key": "data_test" }
