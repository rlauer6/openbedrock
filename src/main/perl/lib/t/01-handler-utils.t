#!/usr/bin/env perl

use strict;
use warnings;

package Bedrock::Apache::TestHandler;

use Bedrock::Handler;
use Bedrock::Apache::Constants qw(:http);

use Role::Tiny::With;
with 'Bedrock::Apache::HandlerUtils';

our $BEDROCK_HANDLER;

sub bedrock_handler { return $BEDROCK_HANDLER; }

########################################################################
sub handler {
########################################################################
  my ($r) = @_;

  $BEDROCK_HANDLER = Bedrock::Handler->new($r);

  return $OK;
}

########################################################################
package main;
########################################################################

use Bedrock;
use Bedrock::Apache::Request_cgi;
use Bedrock::Apache::Constants qw($OK);
use Bedrock::Test::Utils qw(connect_db);
use Bedrock::XML;
use Bedrock::Handler qw(bind_blm_module get_blm_config);
use Cwd qw(getcwd);
use Data::Dumper;
use English qw(-no_match_vars);
use IO::Scalar;
use Test::More;

########################################################################
sub create_login_session {
########################################################################
  my ( $bedrock_handler, $username, $password ) = @_;

  my $config = $bedrock_handler->fetch_blm_config('mysql-session');

  my $user_session_config = $config->get_module_config('usersession');
  delete $user_session_config->{verbose};
  $user_session_config->{log_level} = 'error';

  my $session = eval { return $bedrock_handler->bind_blm_module('BLM::Startup::UserSession'); };

  die "unable to bind BLM::Startup::UserSesion module\n$EVAL_ERROR"
    if !$session || $EVAL_ERROR;

  BAIL_OUT('usersession config not found')
    if !$user_session_config;

  my $retval = eval { $session->register( $username, $password ); };

  die "could not register user $username\n$EVAL_ERROR"
    if !$retval && $EVAL_ERROR !~ /exists/xsm;

  $session->login( $username, $password );

  return $session;
}

my $output_buffer = q{};

########################################################################
sub create_request_handler {
########################################################################
  my $fh = IO::Scalar->new( \$output_buffer );

  local $ENV{PATH_INFO}       = $PROGRAM_NAME;
  local $ENV{PATH_TRANSLATED} = sprintf '%s/%s', getcwd, $PROGRAM_NAME;
  local $ENV{REQUEST_METHOD}  = 'GET';
  local $ENV{HTTP_COOKIE}     = q{};

  return Apache::Request_cgi->new( output_handle => $fh );
}

my $r = create_request_handler();

my $dbi = eval { return connect_db(); };

if ( !$dbi ) {
  plan skip_all => 'no database connection';
}

########################################################################
subtest 'handler' => sub {
########################################################################
  is( Bedrock::Apache::TestHandler::handler($r), $OK, 'handler return' )
    or BAIL_OUT('could not create test hander');
};

my $session;
my $username = 'fflintstone';
my $password = join q{}, map { ( 0 .. 9, 'a' .. 'z' )[ int rand 36 ] } ( 0 .. 7 );

my $bedrock_handler = Bedrock::Apache::TestHandler::bedrock_handler();

########################################################################
subtest 'check_session' => sub {
########################################################################
  eval { Bedrock::Apache::TestHandler::check_session($bedrock_handler); };

  like( $EVAL_ERROR, qr/no\sor\sexpired\ssession/xsm, 'no session' )
    or diag( Dumper( [ error => $EVAL_ERROR ] ) );

  $session = create_login_session( $bedrock_handler, $username, $password );

  my $obj = tied %{$session};

  isa_ok( $session, 'BLM::Startup::UserSession' );

  my @cookies = $obj->bake_cookies(3600);
  ok( @cookies, 'ARRAY' );

  like( $cookies[0], qr/session=/xsm, 'session cookie baked' );

  $r->headers_in( Cookie => $cookies[0] );

  eval { Bedrock::Apache::TestHandler::check_session($bedrock_handler); };

  ok( !$EVAL_ERROR, 'valid login session' )
    or diag(
    Dumper(
      [ session       => $session,
        cookies       => \@cookies,
        error         => $EVAL_ERROR,
        output_buffer => $output_buffer,
      ]
    )
    );
};

done_testing;

END {
  eval { $session->remove_user( $username, $password ); };
}

1;
