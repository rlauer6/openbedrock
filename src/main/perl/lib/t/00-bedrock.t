#!/usr/bin/env perl

use strict;
use warnings;

use lib qw{.};

use Bedrock::Hash;
use Bedrock::Array;
use Bedrock::Test::Utils qw{:all};
use Cwd;
use Data::Dumper;
use English qw{-no_match_vars};
use File::Touch qw{touch};
use File::chdir;
use Test::More;

our %TESTS = fetch_test_descriptions(*DATA);

########################################################################

plan tests => 1 + keys %TESTS;

use_ok('Bedrock');

Bedrock->import(':all');

my $bedrock_hash  = Bedrock::Hash->new( a => 1 );
my $bedrock_array = Bedrock::Array->new( 'a', 1 );
my $regexp        = qr/abc/xsm;

########################################################################
subtest 'is_hash' => sub {
########################################################################
  ok( is_hash( {} ),          'is a hash' );
  ok( is_hash($bedrock_hash), 'a Bedrock::Hash is a hash' );

  ok( !is_hash(0),              'a scalar is not a hash' );
  ok( !is_hash( [] ),           'an array ref is not a hash' );
  ok( !is_hash($regexp),        'a regexp is not a hash' );
  ok( !is_hash($bedrock_array), 'a Bedrock::Array is not a hash' );
};

########################################################################
subtest 'is_array' => sub {
########################################################################
  ok( is_array( [] ),           'is an array' );
  ok( is_array($bedrock_array), 'a Bedrock::Array is an array' );

  ok( !is_array(0),             'a scalar not an array' );
  ok( !is_array( {} ),          'a hash ref is not an array' );
  ok( !is_array($regexp),       'a regexp not an array' );
  ok( !is_array($bedrock_hash), 'a Bedrock::Hash is not an array' );
};

########################################################################
subtest 'is_regexp' => sub {
########################################################################
  my $regexp = qr/abc/xsm;
  ok( is_regexp($regexp), 'is an regexp' )
    or do {
    diag( Dumper( [ $regexp, ref $regexp ] ) );
    BAIL_OUT('seem is_regexp is not working');
    };

  ok( !is_regexp(0),              'a scalar not an regexp' );
  ok( !is_regexp( {} ),           'a hash ref is not an regexp' );
  ok( !is_regexp($bedrock_array), 'a regexp not an regexp' );
  ok( !is_regexp($bedrock_hash),  'a Bedrock::Hash is not an regexp' );
};

########################################################################
subtest 'find_in_path' => sub {
########################################################################
  my $temp_dir = create_temp_dir( cleanup => $TRUE, dir => 'foo' );

  my @file_list = map {"$temp_dir/$_.bar"} qw{foo bar buz biz};
  push @file_list, "$temp_dir/foo/foo.bar";

  foreach (@file_list) {
    touch($_);
  }

  my $cwd = getcwd;

  my @found = find_in_path(
    find_one  => 1,
    file      => 'foo.bar',
    path_list => [$temp_dir]
  );

  is( @found, 1, 'found 1 file' )
    or diag( Dumper( [ \@found ] ) );

  is( $cwd, getcwd, 'current working directory not changed' );

  @found = find_in_path(
    find_one  => 1,
    pattern   => qr/[^.]+[.]bar$/xsm,
    path_list => [$temp_dir]
  );

  is( @found, 1, 'found 1 file' )
    or diag( Dumper( [ \@found ] ) );

  @found = find_in_path(
    pattern   => qr/[^.]+[.]bar$/xsm,
    path_list => [$temp_dir],
  );

  ok( @found == @file_list, 'found all .bar files' );

  @found = find_in_path( file => 'foo.bar', path_list => [$temp_dir] );
  ok( @found == 2, 'found two "foo.bar"s' );

  {
    local $CWD = $temp_dir;  ## no critic (ProhibitLocalVars)

    @found = find_in_path( file => 'foo.bar' );
    ok( @found == 2,
      qq{fond two "foo.bar"s in current working directory($temp_dir)} );
  }

};

1;

__DATA__
is_hash => isa hash ref
is_array => isa array ref
is_regexp => isa regexp
find_in_path => find files in path list
END_OF_PLAN
