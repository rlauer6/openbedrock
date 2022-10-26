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

use Bedrock::Constants qw{:defaults};
use Bedrock::BedrockConfig;
use Data::Dumper;
use English qw{-no_match_vars};

use_ok('BLM::Startup::UserSession');

########################################################################
sub bind_module {
########################################################################
  my ( $ctx, $config ) = @_;

  my $module = q{BLM::Startup::UserSession};

  my $obj = bless {}, $module;

  tie %{$obj}, $module, $ctx, $config;  ## no critic (ProhibitTies)

  return $obj;
}

########################################################################
my $config_file = "$DEFAULT_BEDROCK_CONFIG_PATH/mysql-session.xml";

my $config = eval { return Bedrock::Config->new($config_file); };

BAIL_OUT("could read $config_file")
  if !$config;

my $session_config = $config->{config};
$session_config->{data_source} .= ':127.0.0.1';
$session_config->{cookieless_sessions} = 1;
$session_config->{verbose}             = 0;

my $ctx = Faux::Context->new( CONFIG => { SESSION_DIR => '/tmp' } );

my $session = eval { return bind_module( $ctx, $session_config ); };

########################################################################
subtest 'TIEHASH' => sub {
########################################################################
  ok( !$EVAL_ERROR, 'bound module' );

  isa_ok( $session, 'BLM::Startup::UserSession' );
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

my $file;

########################################################################
subtest 'create_session_file' => sub {
########################################################################
  $file = $session->create_session_file( 'test.jroc', $session_config );

  ok( -s $file, 'file written' );

  my $obj = eval {
    open my $fh, '<', $file
      or die "could not open $file for reading\n";

    local $RS = undef;

    require JSON::PP;

    my $content = <$fh>;

    close $fh;

    return JSON::PP->new->decode($content);
  };

  is_deeply( $obj, $session_config, 'object serialized correctly' )
    or diag( Dumper( [ $obj, $session_config ] ) );
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
  my $rc = $session->register(
    'fflintstone', 'W1lma',
    'Fred',        'Flintstone',
    'fflintstone@openbedrock.net'
  );

  ok( $rc, 'registered user' );
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

subtest 'remove user' => sub {

  ok( $session->remove_user( 'fflintstone', 'W1lma' ), 'remove user' );

  eval { $session->login( 'fflintstone', 'W1lma' ); };

  ok( $EVAL_ERROR, 'removed user cannot login' );
};

########################################################################
END {
  if ( -e $file ) {
    unlink $file;

    my $session_dir = $session->create_session_dir;
    rmdir $session_dir;
  }

}

1;

__END__
