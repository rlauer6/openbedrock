#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Role::Tiny;

# ----------------------------------------------------------------------
# 1. Create a Mock Class that behaves like SessionManager
# ----------------------------------------------------------------------
{

  package MockSession;
  use Role::Tiny::With;

  # Simulate the storage structure of SessionManager
  sub new {
    my $class = shift;
    return bless {
      session => 'test_session_id_123',
      data    => {
        prefs => {}  # Where the token lives
      }
    }, $class;
  }

  # Mix in the Role
  with 'Bedrock::CSRF';
}

# ----------------------------------------------------------------------
# 2. Run the Tests
# ----------------------------------------------------------------------

# Instantiate
my $session = MockSession->new();
ok( $session, 'MockSession object instantiated' );

# TEST 1: Generation
my $token1 = $session->csrf_token();
ok( $token1, 'Generated CSRF token' );
like( $token1, qr/^[a-zA-Z0-9]+$/, 'Token contains only safe characters' );

# TEST 2: Persistence / Idempotency
my $token2 = $session->csrf_token();
is( $token1, $token2, 'Subsequent calls return the SAME token' );

# TEST 3: Verification (Success)
ok( $session->check_csrf_token($token1), 'check_csrf_token validates correct token' );

# TEST 4: Verification (Failure)
ok( !$session->check_csrf_token('bad_token'), 'check_csrf_token rejects invalid token' );
ok( !$session->check_csrf_token(undef),       'check_csrf_token rejects undef' );

# TEST 5: Rotation
my $token3 = $session->rotate_csrf_token();
ok( $token3, 'Rotated to a new token' );
isnt( $token1, $token3, 'New token is strictly different from the old one' );

done_testing;
1;
