#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 6;
use Bedrock::RegExp;
use Bedrock::Constants qw(:booleans);

# BSG: Testing Bedrock::RegExp functionality in isolation
########################################################################
# 1. Test basic compilation and capture
########################################################################
{
  my $re = regexp_compile('/(Bedrock)/');
  "Bedrock" =~ $re;
  my $cg = regexp_capture_group();

  is( $cg->{_1}, 'Bedrock', 'Basic capture group _1 works' );
}

########################################################################
# 2. Test escaped delimiters (The "Hinky" Check)
########################################################################
{
  # This should fail in the current version due to [^/]+
  my $re = eval { regexp_compile('/path\/to\/file/') };

  ok( $re, 'Compiled regex with escaped forward slashes' );
}

########################################################################
# 3. Test Named Capture Groups
########################################################################
{
  "key:value" =~ /(?<key>\w+):(?<val>\w+)/;
  my $cg = regexp_capture_group();

  is( $cg->{key}, 'key',   'Named capture "key" works' );
  is( $cg->{val}, 'value', 'Named capture "val" works' );
}

########################################################################
# 4. Test numeric captures (Perl < 5.25 compatibility)
########################################################################
{
  "123-456" =~ /(\d+)-(\d+)/;
  my $cg = regexp_capture_group();

  is( $cg->{_2}, '456', 'Numeric capture _2 works' );
}

########################################################################
# 5. Test regexp_evaluate (Scalar Context)
########################################################################
{
  my $cg = regexp_evaluate( "hello world", "/(hello)/" );

  is( $cg->{_1}, 'hello', 'regexp_evaluate returns correct capture hash' );
}

1;
