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

my $field = create_field_type( name => 'foo', type => 'int' );
isa_ok( $field, 'Bedrock::Model::Field', 'isa Bedrock::Model::Field' );

$field = create_field_type(
  name   => 'foo',
  type   => 'decimal',
  length => '10.2'
);
isa_ok( $field, 'Bedrock::Model::Field', 'isa Bedrock::Model::Field' );

$field = auto_increment_field('foo');
isa_ok( $field, 'Bedrock::Model::Field', 'isa Bedrock::Model::Field' );

$field = money_field('cost');
isa_ok( $field, 'Bedrock::Model::Field', 'isa Bedrock::Model::Field' );

done_testing;

1;
