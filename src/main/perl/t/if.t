use strict;
use warnings;

use Test::More;

require "bedrock-test-bed.pl";

my $tests = bedrock_load_tests('if');

plan tests => 1+scalar(@{$tests});

use_ok('Text::TagX');

bedrock_run_tests($tests);

