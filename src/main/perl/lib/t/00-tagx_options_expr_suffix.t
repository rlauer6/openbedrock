#!/usr/bin/env perl

use strict;
use warnings;

use English qw(-no_match_vars);
use Test::More;

use Bedrock::Constants qw($EMPTY $OPTIONS_EXPR);

# ------------------------------------------------------------------------
sub _validate_suffix {
# ------------------------------------------------------------------------
  my ($suffix) = @_;

  $suffix //= $EMPTY;

  die "Invalid tag ending '/->' (use '-/>' or '/>' instead)\n"
    if $suffix eq '/-';

  return $suffix;
}

# ------------------------------------------------------------------------
my @cases = (
# ------------------------------------------------------------------------
  {
    name   => 'plain >',
    input  => q{ --foo=1 >},
    opt    => q{--foo=1},
    suffix => q{},
  },
  {
    name   => 'chomp ->',
    input  => q{ --foo=1 ->},
    opt    => q{--foo=1},
    suffix => q{-},
  },
  {
    name   => 'self-close />',
    input  => q{ --foo=1 />},
    opt    => q{--foo=1},
    suffix => q{/},
  },
  {
    name   => 'chomp self-close -/>',
    input  => q{ --foo=1 -/>},
    opt    => q{--foo=1},
    suffix => q{-/},
  },

  # Edge cases that previously worked in the wild.
  {
    name   => q{qw{} with escaped quote, plain >},
    input  => q{ qw{this isn\'t a test that should break} >},
    opt    => q{qw{this isn\'t a test that should break}},
    suffix => q{},
  },
  {
    name   => q{q{} with escaped quote, plain >},
    input  => q{ q{this isn\'t a test that should break} >},
    opt    => q{q{this isn\'t a test that should break}},
    suffix => q{},
  },
  {
    name   => q{regex literal containing escaped \> does not terminate},
    input  => q{ ("xyz" --re '/y(?<foo\>.*)$/') >},
    opt    => q{("xyz" --re '/y(?<foo\>.*)$/')},
    suffix => q{},
  },
  {
    name   => q{self-close with spaces before />, suffix is '/'},
    input  => q{ foo bar baz />},
    opt    => q{foo bar baz},
    suffix => q{/},
  },
);

for my $c (@cases) {
  my $s = $c->{input};

  ok( $s =~ s/$OPTIONS_EXPR//xsm, $c->{name} . ' matches OPTIONS_EXPR' );
  is( $1, $c->{opt},    $c->{name} . ' options text' );
  is( $3 // q{}, $c->{suffix}, $c->{name} . ' suffix token' );

  my $suffix = eval { _validate_suffix( $3 ) };
  is( $EVAL_ERROR, q{}, $c->{name} . ' suffix is valid' );
}

# /-> should be recognized and rejected (not silently accepted and not hang).
{
  my $s = q{ --foo=1 /->};

  ok( $s =~ s/$OPTIONS_EXPR//xsm, q{/-> matches OPTIONS_EXPR so we can reject it cleanly} );
  is( $3, q{/-}, q{/-> suffix token is "/-"} );

  eval { _validate_suffix($3) };
  like(
  $EVAL_ERROR,
  qr/\AInvalid\stag\sending\s'\/->'/xsm,
  "/-> is rejected with a clear error"
);

}

done_testing;

1;
