#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;

use English qw(-no_match_vars);
use Data::Dumper;

BEGIN {
  use lib qw(.);

  use_ok('Bedrock::Model::Field');

  Bedrock::Model::Field->import(':all');
}

diag(Dumper( [ int => create_field_type(name => 'foo', type => 'int')]));
diag(Dumper( [ decimal => create_field_type(name => 'foo', type => 'decimal', length => '10.2')]));
diag(Dumper( [ auto_increment => auto_increment_field('foo')]));
diag(Dumper( [ money => money_field()]));

done_testing;

1;
