#!/usr/bin/perl env

use strict;
use warnings;

package Finder;

use Role::Tiny::With;
with 'Bedrock::Role::DocFinder';

sub new {
  return bless {}, 'Finder';
}

########################################################################
package main;
########################################################################

use Test::More;
use Cwd;
use Data::Dumper;
use English;

my $finder = eval { Finder->new(); };

ok( $finder, 'new' ) or

  do {
  diag( Dumper( [ error => $EVAL_ERROR ] ) );
  BAIL_OUT('could not instantiate Finder');
  };

my $files = eval { $finder->find_files_of_type( paths => [cwd], type => 'pm' ); };

ok( $files && @{$files}, 'find_files_of_type' )
  or do {
  diag( Dumper( [ error => $EVAL_ERROR ] ) );
  BAIL_OUT('could not find_files_of_type');
  };

my $metadata = eval {
  $finder->module_metadata( [ grep {/JSON/} @{$files} ] );
};

ok( $metadata, 'module_metadata' )
  or do {
  diag( Dumper( [ error => $EVAL_ERROR ] ) );
  };

isa_ok( $metadata, 'HASH', 'metadata' );
ok( keys %{$metadata} > 0, 'has keys' );

done_testing;

1;
