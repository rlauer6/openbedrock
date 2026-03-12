#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Bedrock::Serializer qw(clone);
use Bedrock::Hash;
use Bedrock::Array;

use Data::Dumper;

use_ok('Bedrock::Serializer');

my $obj = [ { foo => 'bar' }, [ qw(1 2 3), { bar => 'foo' }, bless( {}, 'FOO' ) ] ];

$obj = clone($obj);

ok( ref($obj) eq 'Bedrock::Array' );

ok( ref( $obj->[0] ) eq 'Bedrock::Hash' )
  or diag( ref( $obj->[0] ) );

ok( ref( $obj->[1] ) eq 'Bedrock::Array' )
  or diag( ref( $obj->[1] ) );

ok( ref( $obj->[1]->[3] ) eq 'Bedrock::Hash' )
  or diag( ref( $obj->[1]->[3] ) );

ok( ref( $obj->[1]->[4] ) eq 'FOO' )
  or diag( Dumper( [ obj => $obj ] ) );

$obj = $obj->devolve;

done_testing;

1;
