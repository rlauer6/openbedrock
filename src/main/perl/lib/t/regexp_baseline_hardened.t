#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 3;
use Bedrock::RegExp;
use Scalar::Util qw(reftype);

########################################################################
# 1. Force the /.../ branch with escaped slashes
########################################################################
{
  my $pattern = '/\/usr\/local\/bin/';
  my $re      = regexp_compile($pattern);

  # If it returns the string instead of a Regexp, it's a soft fail
  is( reftype($re), 'REGEXP', 'Actually compiled a complex path regex' );
}

########################################################################
# 2. Test nested non-capturing groups affecting numbering
########################################################################
{
  # Branch reset (?|...) isn't always handled well by 'eval sprintf'
  my $pattern = '/(?|(\d+)|(\w+))/';
  my $re      = regexp_compile($pattern);
  "123" =~ $re;
  my $cg = regexp_capture_group();

  is( $cg->{_1}, '123', 'Branch reset capture group numbering is correct' );
}

########################################################################
# 3. Test multi-line and global flags in the string
########################################################################
{
  my $pattern  = '/^start/m';
  my $re       = regexp_compile($pattern);
  my $test_str = "line1\nstart line2";

  ok( $test_str =~ $re, 'Multiline flag /m was compiled and respected' );
}

1;
