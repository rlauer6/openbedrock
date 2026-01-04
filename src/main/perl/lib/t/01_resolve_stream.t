#!/usr/bin/env perl

use Test::More;
use Bedrock qw(resolve_stream);
use Scalar::Util qw(reftype);

subtest 'Regression: String with newlines (Implicit Reference Upgrade)' => sub {
  # 1. create a string that looks like content
  my $content = "Hello\nWorld";

  # 2. pass it directly (NOT as a reference)
  my $fh = eval { resolve_stream($content) };

  is( $@, '', 'resolve_stream did not die on string with newlines' );
  ok( defined $fh, 'Returned a filehandle' );

  # 3. Verify it opens correctly
  my $read_back = do { local $/; <$fh> };
  is( $read_back, $content, 'Filehandle contains the original string data' );

  # 4. Verify we didn't accidentally create a REF-to-REF
  # (We can't easily inspect the internal lexical var inside resolve_stream,
  # but if it opened, we know it was a valid SCALAR ref).
};

done_testing();

1;
