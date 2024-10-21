#!/usr/bin/env perl

use strict;
use warnings;

package Test::Logger;

use Role::Tiny::With;
with 'Bedrock::Logger';

package main;

use English qw(-no_match_vars);
use Data::Dumper;

use Test::More;

use_ok('Bedrock::Logger');

done_testing;

1;
