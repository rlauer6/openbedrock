use strict;
use warnings;

use Test::More;
use File::Basename;
use YAML::Syck;

require "bedrock-test-bed.pl";

my ($name) = fileparse($0, qr/(\.[^.])*/);

my $tests = bedrock_load_tests($name, 'yaml');

plan tests => 1+scalar(@{$tests});

use_ok('Text::TagX');

bedrock_run_tests($tests);

