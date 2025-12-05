#!/usr/bin/env perl

use strict;
use warnings;

########################################################################
package Bedrock::Apache::TestHandler;
########################################################################

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
use Bedrock::Apache::Request::CGI;
use Bedrock::Apache::Constants qw($OK);
use Bedrock::Test::Utils qw(connect_db create_db :booleans :chars);
use Bedrock::Handler qw(bind_blm_module get_blm_config);
use Bedrock::XML;
use Cwd qw(getcwd);
use Data::Dumper;
use English qw(-no_match_vars);
use File::Basename qw(fileparse);
use File::Temp qw(tempfile);
use IO::Scalar;
use Test::More;

########################################################################
sub create_mysql_session_config {
########################################################################
  my $text;

  {
    local $RS = undef;
    $text = <DATA>;
  }

  my $config = Bedrock::XML->newFromString($text);

  $config->{config}->{username} = $ENV{DBI_USER};
  $config->{config}->{password} = $ENV{DBI_PASS};

  my $xml = Bedrock::XML::writeXMLString($config);

  my ( $fh, $filename ) = tempfile( 'mysql-sessionXXXX', UNLINK => $TRUE, SUFFIX => '.xml' );

  print {$fh} $xml;

  close $fh;

  return $filename;
}

my $dbi = eval { return connect_db(); };

if ( !$dbi ) {
  plan skip_all => 'no database connection';
}

my $username = 'fflintstone';
my $password = '8edR0ck!';

my $output_buffer = $EMPTY;

my $bedrock_handler;

my $session = eval {
  ########################################################################
  # setup
  ########################################################################

  ########################################################################
  # 1. create a test database ('foo')
  ########################################################################
  create_db($dbi);

  ########################################################################
  # 2. create session table
  ########################################################################
  my $sql = <<'END_OF_SQL';
create table if not exists session
 (
  id           int(11)      not null auto_increment primary key,
  session      varchar(50)  default null,
  login_cookie varchar(50)  not null default '',
  username     varchar(50)  not null default '',
  password     varchar(64)  default null,
  firstname    varchar(30)  default null,
  lastname     varchar(50)  default null,
  email        varchar(100) default null,
  prefs        text,
  updated      timestamp    not null default current_timestamp on update current_timestamp,
  added        datetime     default null,
  expires      datetime     default null
);
END_OF_SQL

  $dbi->do($sql);

  ########################################################################
  # 3. create a request handler
  ########################################################################

  my $fh = IO::Scalar->new( \$output_buffer );
  $fh->autoflush;

  local $ENV{PATH_INFO}       = $PROGRAM_NAME;
  local $ENV{PATH_TRANSLATED} = sprintf '%s/%s', getcwd, $PROGRAM_NAME;
  local $ENV{REQUEST_METHOD}  = 'GET';
  local $ENV{HTTP_COOKIE}     = q{};

  my $r = Apache::Request::CGI->new( output_handle => $fh );

  ########################################################################
  # 4. creates and sets the global $BEDROCK_HANDLER (Bedrock::Handler)
  ########################################################################
  Bedrock::Apache::TestHandler::handler($r);

  ########################################################################
  # 5. fetch the the Bedrock::Handler object
  ########################################################################
  $bedrock_handler = Bedrock::Apache::TestHandler::bedrock_handler();

  ########################################################################
  # 6. create a mysql_session.xml configuration file
  ########################################################################
  my $config_file = create_mysql_session_config();

  ########################################################################
  # 7. create a BLM::Startup::UserSession object
  ########################################################################

  my ( $name, $path, $ext ) = fileparse( $config_file, qr/[.][^.]+$/xsm );

  my $config = $bedrock_handler->fetch_blm_config( $config_file, $path );

  my $user_session_config = $config->get_module_config('usersession');
  delete $user_session_config->{verbose};
  $user_session_config->{log_level} = 'error';

  my $session = $bedrock_handler->bind_blm_module('BLM::Startup::UserSession');

  ########################################################################
  # 8. register a user
  ########################################################################
  my $retval = $session->register( $username, $password );

  die "could not register user $username\n$EVAL_ERROR"
    if !$retval;

  return $session;
};

isa_ok( $session, 'BLM::Startup::UserSession' )
  or do {
  diag($EVAL_ERROR);
  BAIL_OUT('ERROR: test setup failed!');
  };

# Bedrock::Apache::HandlerUtils

########################################################################
# [ ] check_session
########################################################################
subtest 'check_session (expired)' => sub {
########################################################################
  eval { Bedrock::Apache::TestHandler::check_session($bedrock_handler); };

  like( $EVAL_ERROR, qr/no\sor\sexpired\ssession/xsm, 'no session' )
    or diag( Dumper( [ error => $EVAL_ERROR ] ) );
};

########################################################################
subtest 'check_session (valid)' => sub {
########################################################################

  $session->login( $username, $password );

  my $r = $bedrock_handler->request;
  STDOUT->autoflush;
  $r->send_http_header;

  my ( $content_type, $cookie ) = split /\s+/xsm, $output_buffer;

  $r->headers_in( Cookie => $cookie );

  eval { Bedrock::Apache::TestHandler::check_session($bedrock_handler); };

  ok( !$EVAL_ERROR, 'valid login session' )
    or diag(
    Dumper(
      [ session => $session,
        error   => $EVAL_ERROR,
      ]
    )
    );
};

########################################################################
# [ ] get_cookie
########################################################################
subtest 'get_cookie' => sub {
  my ( $content_type, $cookie ) = split /\s+/xsm, $output_buffer;

  my $r = $bedrock_handler->request;

  my $session_cookie = Bedrock::Apache::TestHandler::get_cookie( $r, 'session' );

  ok( $cookie, 'got a session cookie' );

  ok( $cookie eq "session=$session_cookie;", 'session value correct' )
    or diag(
    Dumper(
      [ cookie         => $cookie,
        session_cookie => "session=$session_cookie;",
      ]
    )
    );
};

########################################################################
# [ ] get_session_cookie
########################################################################
subtest 'get_session_cookie' => sub {
  my ( $content_type, $cookie ) = split /\s+/xsm, $output_buffer;

  my $r = $bedrock_handler->request;

  my $session_cookie = Bedrock::Apache::TestHandler::get_session_cookie($r);  # $r->get_session_cookie();

  ok( $cookie, 'got a session cookie' );

  ok( $cookie eq "session=$session_cookie;", 'session value correct' )
    or diag(
    Dumper(
      [ cookie         => $cookie,
        session_cookie => "session=$session_cookie;",
      ]
    )
    );
};

########################################################################
# [ ] bind_session/validate_session
########################################################################
subtest 'bind_session' => sub {

  my $r = $bedrock_handler->request();

  my $session = Bedrock::Apache::TestHandler::bind_session($bedrock_handler);

  isa_ok( $session, 'BLM::Startup::UserSession' );
};

########################################################################
# [ ] set_error_status
########################################################################
subtest 'set_error_status' => sub {
  my $r = $bedrock_handler->request;

  Bedrock::Apache::TestHandler::set_error_status( $r, 'not found' );
  $r->send_http_header;

  ok( $output_buffer, 'head sent' );
  like( $output_buffer, qr/Status: 404/sm, 'Status: 404' );
};

done_testing;

END {
  eval {
    if ( $dbi && $dbi->ping ) {
      $dbi->do('drop database foo');
    }
  };
}

1;

__DATA__
<object>
  <scalar name="binding">session</scalar>
  <scalar name="session">yes</scalar>
  <scalar name="module">BLM::Startup::UserSession</scalar>
  <object name="config">
    <scalar name="verbose">2</scalar>
    <scalar name="param">session</scalar>
    <scalar name="login_cookie_name">session_login</scalar>
    <scalar name="login_cookie_expiry_days">365</scalar>
    <scalar name="purge_user_after">30</scalar>
    <scalar name="data_source">dbi:mysql:foo:localhost</scalar>
    <scalar name="username"></scalar>
    <scalar name="password"></scalar>
    <scalar name="mysql_ssl">1</scalar>
    <scalar name="table_name">session</scalar>
    <object name="cookie">
      <scalar name="path">/</scalar>
      <scalar name="expiry_secs">3600</scalar>
      <scalar name="domain"></scalar>
    </object>
  </object>
</object>
