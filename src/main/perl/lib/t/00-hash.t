#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 5;

use Data::Dumper;
use English qw{-no_match_vars};
use Scalar::Util qw{blessed reftype};

BEGIN {
  use_ok('Bedrock::Hash');
}

########################################################################
subtest 'new' => sub {
########################################################################
  my $hash = Bedrock::Hash->new( foo => 'bar', biz => 'buz' );

  isa_ok( $hash, 'Bedrock::Hash' );

  isa_ok( $hash, 'HASH' );

  is( keys %{$hash}, 2, '2 element hash' )
    or diag( Dumper( [$hash] ) );

  $hash = $hash->new( a => 1, b => 2, c => 3 );

  isa_ok( $hash, 'Bedrock::Hash' )
    or diag( Dumper( [$hash] ) );

  is( keys %{$hash}, 3, '3 element hash' )
    or diag( Dumper( [$hash] ) );
};

########################################################################
subtest 'get' => sub {
########################################################################

  my $hash = Bedrock::Hash->new( a => 1, b => 2 );

  my $value = eval { $hash->get('a'); };

  is( $value, 1, 'get("a"))' );
};

########################################################################
subtest 'print' => sub {
########################################################################

  my $hash = Bedrock::Hash->new( a => 1, b => 2 );

  my $value = eval { $hash->get('a'); };

  is( $value, 1, 'get("a"))' );
};

########################################################################
subtest 'devolve' => sub {
########################################################################

  # basic - top level hash is unblessed
  my $hash = Bedrock::Hash->new( foo => 'bar', biz => 'buz' );
  my $plain = $hash->devolve;

  ok( !blessed $plain,              'top-level hash is unblessed' );
  is( reftype($plain), 'HASH',      'top-level is a plain hashref' );
  is( $plain->{foo},   'bar',       'scalar value preserved' );

  # nested Bedrock::Hash devolved
  my $nested = Bedrock::Hash->new( inner => Bedrock::Hash->new( x => 1 ) );
  my $plain_nested = $nested->devolve;

  ok( !blessed $plain_nested->{inner},         'nested hash is unblessed' );
  is( reftype($plain_nested->{inner}), 'HASH', 'nested value is plain hashref' );
  is( $plain_nested->{inner}{x}, 1,            'nested scalar value preserved' );

  # nested Bedrock::Array devolved
  require Bedrock::Array;
  my $with_array = Bedrock::Hash->new( items => Bedrock::Array->new( 1, 2, 3 ) );
  my $plain_with_array = $with_array->devolve;

  ok( !blessed $plain_with_array->{items},          'nested array is unblessed' );
  is( reftype($plain_with_array->{items}), 'ARRAY',  'nested value is plain arrayref' );
  is_deeply( $plain_with_array->{items}, [ 1, 2, 3 ], 'array contents preserved' );

  # deeply nested structure
  my $deep = Bedrock::Hash->new(
    level1 => Bedrock::Hash->new(
      level2 => Bedrock::Array->new(
        Bedrock::Hash->new( leaf => 'value' )
      )
    )
  );
  my $plain_deep = $deep->devolve;

  ok( !blessed $plain_deep->{level1},                    'level1 unblessed' );
  ok( !blessed $plain_deep->{level1}{level2},            'level2 unblessed' );
  ok( !blessed $plain_deep->{level1}{level2}[0],         'leaf hash unblessed' );
  is( $plain_deep->{level1}{level2}[0]{leaf}, 'value',   'deep scalar preserved' );

  # generic blessed hashref - the new generic behaviour
  my $arbitrary = bless { key => 'val' }, 'Some::RandomClass';
  my $with_arbitrary = Bedrock::Hash->new( obj => $arbitrary );
  my $plain_arbitrary = $with_arbitrary->devolve;

  ok( !blessed $plain_arbitrary->{obj},          'arbitrary blessed hashref devolved' );
  is( reftype($plain_arbitrary->{obj}), 'HASH',  'arbitrary blessed hashref is plain hashref' );
  is( $plain_arbitrary->{obj}{key}, 'val',       'value preserved from arbitrary blessed ref' );
};

1;

## no critic (RequirePodSections)

__END__

=begin


=end
