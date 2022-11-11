#!/usr/bin/env perl

use strict;
use warnings;

use lib qw{.};

use Bedrock::Test::Utils qw{:all};

use Data::Dumper;
use English qw{-no_match_vars};
use Test::More;

our %TESTS = fetch_test_descriptions(*DATA);

########################################################################

plan tests => 1 + keys %TESTS;

use_ok('Bedrock::Object');

Bedrock::Object->import('create_object');

########################################################################
subtest 'hash' => sub {
########################################################################
  my $obj = create_object( {} );

  isa_ok( $obj, 'Bedrock::Hash' );

  $obj = create_object( { foo => 'bar' } );

  isa_ok( $obj, 'Bedrock::Hash' );

  is( keys %{$obj}, 1, '1 key' );

  is( $obj->get('foo'), 'bar', 'foo=bar' );
};

########################################################################
subtest 'array' => sub {
########################################################################
  my $obj = create_object( [] );

  isa_ok( $obj, 'Bedrock::Array' )
    or diag( Dumper( [$obj] ) );

  my $array = [ reverse 0 .. 9 ];

  $obj = create_object($array);

  is_deeply( $obj->sort, [ 0 .. 9 ], 'sort' )
    or diag( Dumper( [ $obj->sort ] ) );

};

########################################################################
subtest 'not an object' => sub {
########################################################################

  my $not_an_object;

  is( create_object($not_an_object), $not_an_object, 'not a ref' );

  $not_an_object = 'foo';

  is( create_object($not_an_object), $not_an_object, 'not a ref' );

  $not_an_object = 0;

  is( create_object($not_an_object), $not_an_object, 'not a ref' );

  $not_an_object = sub {1};
  diag( Dumper($not_an_object) );

  is( create_object($not_an_object), $not_an_object, 'CODE ref' );

};

1;

__DATA__
hash => create a Bedrock::Hash object
array => create a Bedrock::Array object
not an object => return same object when not array or hash
END_OF_PLAN  
