#!/usr/bin/env perl

use strict;
use warnings;

use Bedrock qw(slurp_file);
use Bedrock::BedrockConfig;
use Bedrock::Constants qw(:defaults :chars :booleans);
use Bedrock::Test::FauxContext qw(bind_module);
use Bedrock::Test::Utils qw(connect_db create_db);
use Cwd;
use Data::Dumper;
use English qw(-no_match_vars);
use JSON;
use Test::More;

########################################################################
# setup
########################################################################

my $dbi = eval { return connect_db(); };

if ( !$dbi ) {
  plan skip_all => 'no database connection';
}

eval {

  create_db($dbi);

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
};

BAIL_OUT("could not create database 'foo': $EVAL_ERROR\n")
  if $EVAL_ERROR;

my $fh     = *DATA;
my $config = eval { return Bedrock::Config->new($fh); };

if ( !$config || $EVAL_ERROR ) {
  diag($EVAL_ERROR);
  BAIL_OUT('ERROR: could not load config');
}

my $session_config = $config->{config};

my @dsn = split /:/xsm, $session_config->{data_source};
$dsn[3] = $ENV{DBI_HOST} // '127.0.0.1';
$dsn[2] = 'foo';

$session_config->{username} = $ENV{DBI_USER};
$session_config->{password} = $ENV{DBI_PASS};

$session_config->{data_source}         = join q{:}, @dsn;
$session_config->{cookieless_sessions} = $FALSE;
$session_config->{verbose}             = $FALSE;
$session_config->{mysql_ssl}           = $TRUE;

my $ctx = Bedrock::Test::FauxContext->new( CONFIG => { SESSION_DIR => '/tmp' } );

########################################################################
# end of setup
########################################################################

use_ok('BLM::Startup::UserSession');

my $session;

########################################################################
subtest 'TIEHASH' => sub {
########################################################################

  $session = eval { return bind_module( $ctx, $config, 'BLM::Startup::UserSession' ); };

  ok( !$EVAL_ERROR, 'bound module' )
    or do {
    diag($EVAL_ERROR);
    BAIL_OUT('could not bind session');
    };

  isa_ok( $session, 'BLM::Startup::UserSession' )
    or do {
    diag( Dumper( [$session] ) );
    BAIL_OUT('session is not instantiated properly');
    };
};

########################################################################
subtest 'session id' => sub {
########################################################################
  ok( $session->{session}, 'session id exists' );

  like( $session->{session}, qr/^[\da-f]{32}$/xsm, 'session is a md5 hash' );
};

########################################################################
subtest 'create_session_dir' => sub {
########################################################################

  my $session_dir = $session->create_session_dir;

  ok( $session_dir, 'create_session_dir() - returns a directory' );

  ok( -d $session_dir, 'create_session_dir() - directory exists' );

  ok( -w $session_dir, 'create_session_dir() - session is writeable' );
};

########################################################################
subtest 'create_session_file' => sub {
########################################################################

  my $file = $session->create_session_file( 'test.jroc', $session_config );

  ok( -s $file, 'file written' );

  my $obj = eval {
    my $content = slurp_file $file;

    return JSON->new->decode($content);
  };

  is_deeply( $obj, $session_config, 'object serialized correctly' )
    or diag( Dumper( [ $obj, $session_config ] ) );

  unlink $file;

  my $session_dir = $session->create_session_dir;
};

my $session_id = $session->{session};

########################################################################
subtest 'close' => sub {
########################################################################
  $session->{foo} = 'bar';

  eval { return $session->closeBLM; };

  ok( !$EVAL_ERROR, 'closeBLM' )
    or diag( Dumper( [$EVAL_ERROR] ) );
};

########################################################################
subtest 'save' => sub {
########################################################################
  $ENV{HTTP_COOKIE} = 'session=' . $session->{session};

  $session = eval { return bind_module( $ctx, $config, 'BLM::Startup::UserSession' ); };

  is( $session->{foo}, 'bar', 'session saved' )
    or diag( Dumper( [$session] ) );
};

########################################################################
subtest expire_session => sub {
########################################################################
  my $dbi = $session->db_handle;

  my $session_dir = $session->create_session_dir;

  ok( -d $session_dir, "$session_dir exists" );

  my $session_id = $session->{session};

  my $sql = <<'END_OF_SQL';
update session
  set expires = date_sub(now(), interval 10 minute)
  where session = ?
END_OF_SQL

  $dbi->do( $sql, {}, $session_id );

  $config->{config}->{cleanup_session_dir} = 'yes';

  $session->closeBLM;

  ok( !-d $session_dir, "$session_dir cleaned up" );

  # session should be gone so the next attempt to create a session
  # with that id will result in creation of a new session
  local $ENV{HTTP_COOKIE} = 'session=' . $session->{session};
  $session = eval { return bind_module( $ctx, $config, 'BLM::Startup::UserSession' ); };

  ok( $session && $session->{session} ne $session_id, 'expired session causes new session' )
    or diag(
    Dumper(
      [ error   => $EVAL_ERROR,
        session => $session,
      ]
    )
    );

};

########################################################################
subtest 'register' => sub {
########################################################################

  my $rc = eval { return $session->register( 'fflintstone', 'W1lma', 'Fred', 'Flintstone', 'fflintstone@openbedrock.net' ); };

  if ( !$rc || $EVAL_ERROR ) {
    if ( $EVAL_ERROR =~ /username\sexists/xsm ) {
      diag('user exists...so presumably this worked at some point!');
    }
    else {
      BAIL_OUT( 'error trying to register a new user:' . $EVAL_ERROR );
    }
  }
  else {
    ok( $rc, 'registered user' );
  }

};

########################################################################
subtest 'login' => sub {
########################################################################
  eval { $session->login( 'fflintstone', 'Wilma' ); };

  ok( $EVAL_ERROR, 'bad login' );

  like( $EVAL_ERROR, qr/^Unable\sto\slogin\suser/xsm );

  my $session_id = $session->{session};

  eval { $session->login( 'fflintstone', 'W1lma' ); };

  ok( !$EVAL_ERROR, 'login fflintstone' )
    or diag( Dumper( [$EVAL_ERROR] ) );

  ok( $session_id ne $session->{session}, 'new session id' );

  ok( $session->{username} eq 'fflintstone', 'username is fflintstone' );
};

########################################################################
subtest 'remove user' => sub {
########################################################################

  ok( $session->remove_user( 'fflintstone', 'W1lma' ), 'remove user' );

  eval { $session->login( 'fflintstone', 'W1lma' ); };

  ok( $EVAL_ERROR, 'removed user cannot login' );
};

done_testing;

########################################################################
END {
  eval {
    if ( $dbi && $dbi->ping ) {
      $dbi->do('drop database foo');
    }
  };
}

1;

__DATA__
<!-- Bedrock MySQL Sessions -->
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

    <!-- MySQL connect information -->
    <scalar name="data_source">dbi:mysql:bedrock:db</scalar>
    <scalar name="username">fred</scalar>
    <scalar name="password">flintstone</scalar>
    <scalar name="table_name">session</scalar>
    <scalar name="mysql_ssl">1</scalar>

    <object name="cookie">
      <scalar name="path">/</scalar>
      <scalar name="expiry_secs">3600</scalar>
      <scalar name="domain"></scalar>
    </object>
  </object>
</object>
