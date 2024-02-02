#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;

use English qw(-no_match_vars);
use Data::Dumper;

BEGIN {
  use lib qw(.);

  use_ok('Bedrock::Model::Field');

  Bedrock::Model::Field->import('create_field_type');
}

done_testing;

1;
