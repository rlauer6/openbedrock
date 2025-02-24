use strict;
use warnings;

use Bedrock qw(slurp_file);
use Bedrock::BedrockConfig;
use Bedrock::Constants qw(:defaults :chars :booleans);
use Bedrock::Test::FauxContext qw(bind_module);
use Cwd;
use DBI;
use Data::Dumper;
use English qw(-no_match_vars);
use JSON;
use Test::More;

########################################################################
sub fetch_config {
########################################################################
  my $config_path = $ENV{BEDROCK_CONFIG_PATH} // cwd;

  my $config_file = sprintf '%s/mysql-session.xml', $config_path;

  die "$config_file not found!"
    if !-e $config_file;

  my $config = eval { return Bedrock::Config->new($config_file); };

  return
    if !$config || $EVAL_ERROR;

  my $dbi_host = $ENV{DBI_HOST} // '127.0.0.1';

  my $session_config = $config->{config};
  $session_config->{data_source} .= ":$dbi_host";

  $session_config->{cookieless_sessions} = $session_config->{verbose} = $FALSE;

  $config->{config} = $session_config;

  return $config;
}

########################################################################
sub test_connect {
########################################################################
  my ($config) = @_;

  my $session_config = $config->{config};

  my ( $dsn, $username, $password )
    = @{$session_config}{qw{ data_source username password}};

  my $db_available = eval {
    my $dbi = DBI->connect( $dsn, $username, $password, { PrintError => 0 } );

    my $ping = $dbi->ping ? 'up' : $EMPTY;

    $dbi->disconnect;

    return $ping;
  };

  return $db_available;
}

########################################################################
# TESTS START HERE
########################################################################

my $config = fetch_config();

if ( !$config ) {
  diag($EVAL_ERROR);
  BAIL_OUT('could not read config file');
}

my $ctx = Bedrock::Test::FauxContext->new( CONFIG => { SESSION_DIR => '/tmp' } );

plan skip_all => 'no database available'
  if !test_connect($config);

use_ok('BLM::Startup::UserSession');

my $session;
my $session_config = $config->{config};

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
    require JSON::PP;

    my $content = slurp_file $file;

    return JSON->new->decode($content);
  };

  is_deeply( $obj, $session_config, 'object serialized correctly' )
    or diag( Dumper( [ $obj, $session_config ] ) );

  unlink $file;

  my $session_dir = $session->create_session_dir;

  rmdir $session_dir;
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
subtest 'register' => sub {
########################################################################
  my $rc = eval {
    return $session->register( 'fflintstone', 'W1lma', 'Fred', 'Flintstone', 'fflintstone@openbedrock.net' );
  };

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

}

1;

__END__
