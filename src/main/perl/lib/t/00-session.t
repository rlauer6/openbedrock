package Faux::Context;

use strict;
use warnings;

use Data::Dumper;
use Carp;
use Carp::Always;
use Bedrock::Context qw(parse_cookie);

########################################################################
sub new {
########################################################################
  my ( $class, %options ) = @_;

  my $self = bless \%options, $class;

  return $self;
}

########################################################################
sub cgi_header_in    { }
sub send_http_header { }
sub cgi_header_out   { }
sub headers_out      { }
########################################################################

########################################################################
sub getCookieValue {
########################################################################
  my ( $self, $name ) = @_;

  my $cookie = $ENV{HTTP_COOKIE};

  return
    if !$cookie;

  my $cookie_value = parse_cookie($cookie)->{$name};

  return $cookie_value;
}

########################################################################
sub getInputValue {
########################################################################
  my ( $self, $name ) = @_;

  carp Dumper( [ name => $name, $ENV{$name} ] );

  return $ENV{$name};
}

########################################################################
package main;
########################################################################

use strict;
use warnings;

use Test::More qw(no_plan);

use Bedrock qw(slurp_file);
use Bedrock::BedrockConfig;
use Bedrock::Constants qw(:defaults :chars :booleans);
use Cwd;
use Data::Dumper;
use DBI;
use English qw(-no_match_vars);

use_ok('BLM::Startup::UserSession');

########################################################################
sub bind_module {
########################################################################
  my ( $ctx, $config ) = @_;

  my $module = q(BLM::Startup::UserSession);

  my $obj = bless {}, $module;

  tie %{$obj}, $module, $ctx, $config;  ## no critic (ProhibitTies)

  return $obj;
}

########################################################################
my $config_path = $ENV{BEDROCK_CONFIG_PATH} // cwd;

my $config_file = sprintf '%s/mysql-session.xml', $config_path;

if ( !-e $config_file ) {
  BAIL_OUT("$config_file not found!");
}

my $config = eval { return Bedrock::Config->new($config_file); };

if ( !$config ) {
  BAIL_OUT("could not read $config_file");
}

my $dbi_host = $ENV{DBI_HOST} // '127.0.0.1';

my $session_config = $config->{config};
$session_config->{data_source} .= ":$dbi_host";

$session_config->{cookieless_sessions} = $FALSE;
$session_config->{verbose}             = $FALSE;

my $ctx = Faux::Context->new( CONFIG => { SESSION_DIR => '/tmp' } );

my ( $dsn, $username, $password )
  = @{$session_config}{qw{ data_source username password}};

my $db_available = eval {
  my $dbi = DBI->connect( $dsn, $username, $password, { PrintError => 0 } );

  my $ping = $dbi->ping ? 'up' : $EMPTY;

  $dbi->disconnect;

  return $ping;
};

my $session;

if ($db_available) {
  $session = bind_module( $ctx, $session_config );
}

SKIP: {
  skip 'no database available', 9
    if !$db_available;

########################################################################
  subtest 'TIEHASH' => sub {
########################################################################
    ok( !$EVAL_ERROR, 'bound module' );

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

      return JSON::PP->new->decode($content);
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

    $session = eval { return bind_module( $ctx, $session_config ); };

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
}

done_testing;

########################################################################
END {

}

1;

__END__
