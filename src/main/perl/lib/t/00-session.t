package Faux::Context;

use strict;
use warnings;

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
########################################################################

########################################################################
sub getCookieValue {
########################################################################
  my ( $self, $name ) = @_;

  return $ENV{$name};
}

########################################################################
sub getInputValue {
########################################################################
  my ( $self, $name ) = @_;

  return $ENV{$name};
}

########################################################################
use strict;
use warnings;

use lib qw{.};

use Test::More tests => 10;

use Bedrock qw{slurp_file};
use Bedrock::Constants qw{:defaults :chars};
use Bedrock::BedrockConfig;
use Data::Dumper;
use DBI;
use English qw{-no_match_vars};

use_ok('BLM::Startup::UserSession');

########################################################################
sub bind_module {
########################################################################
  my ( $ctx, $config ) = @_;

  my $module = q{BLM::Startup::UserSession};

  my $obj = bless {}, $module;

  tie %{$obj}, $module, $ctx, $config;  ## no critic (ProhibitTies)

  diag( 'bind_module ', Dumper( [$obj] ) );

  return $obj;
}

########################################################################
my $config_file = "$DEFAULT_BEDROCK_CONFIG_PATH/mysql-session.xml";

my $config = eval { return Bedrock::Config->new($config_file); };

if ( !$config ) {
  BAIL_OUT("could not read $config_file");
}

my $session_config = $config->{config};
$session_config->{data_source} .= ':127.0.0.1';
$session_config->{cookieless_sessions} = 1;
$session_config->{verbose}             = 0;

my $ctx = Faux::Context->new( CONFIG => { SESSION_DIR => '/tmp' } );

my ( $dsn, $username, $password )
  = @{$session_config}{qw{ data_source username password}};

my $db_available = eval {
  my $dbi = DBI->connect( $dsn, $username, $password );

  my $ping = $dbi->ping ? 'up' : $EMPTY;

  $dbi->disconnect;

  return $ping;
};

my $session = $db_available ? bind_module( $ctx, $session_config ) : undef;

diag( 'db_available ' . $db_available );

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
    $ENV{session} = $session_id;

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

########################################################################
END {

}

1;

__END__
