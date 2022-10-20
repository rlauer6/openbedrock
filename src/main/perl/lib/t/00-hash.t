#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 4;

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

  diag( Dumper( [ $hash->print() ] ) );
  diag( Dumper( [ $hash->compact() ] ) );
  diag( Dumper( [ $hash->regular() ] ) );

  is( $value, 1, 'get("a"))' );
};

1;

## no critic (RequirePodSections)

__END__

=begin


=end
