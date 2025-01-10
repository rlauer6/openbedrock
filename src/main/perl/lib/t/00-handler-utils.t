#!/usr/bin/env perl

use strict;
use warnings;

use Bedrock;
use Test::More;
use Data::Dumper;
use English qw(-no_match_vars);
use IO::Scalar;
use Cwd qw(getcwd);

use_ok 'Bedrock::Apache::HandlerUtils';

done_testing;

1;
