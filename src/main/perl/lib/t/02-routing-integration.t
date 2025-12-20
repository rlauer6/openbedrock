#!/usr/bin/env perl

use strict;
use warnings;

use Apache::Bedrock;
use Bedrock::Test::FauxHandler;
use Bedrock::XML qw(writeXML);
use Cwd qw(abs_path);
use Data::Dumper;
use English qw(-no_match_vars);
use File::Basename qw(dirname fileparse);
use File::Temp qw(tempfile);
use Test::More;

# Define '0' as success (standard for mod_perl handlers)
use constant APACHE_OK => 0;

########################################################################
sub create_route_config {
########################################################################
  my ($routes) = @_;

  my ( $fh, $temp_filename ) = tempfile( SUFFIX => '.xml', UNLINK => 1 );

  Bedrock::XML->writeXML( $routes, $fh );

  $fh->close;

  $ENV{CONFIG_PATH} = dirname( abs_path($temp_filename) );

  return;
}

# -------------------------------------------------------------------------
# SETUP: Physical Resource
# -------------------------------------------------------------------------
# We create one dummy file to satisfy (-e $r->filename) checks in the handler.
# This acts as the physical target for our file-based tests.
my ( $fh, $temp_filename ) = tempfile( SUFFIX => '.html', UNLINK => 1 );

print {$fh} <<'END_OF_HTML';
<html>
  <body>
    Default Content
  </body>
</html>
END_OF_HTML

close $fh;
$temp_filename = abs_path($temp_filename);

my $basename       = fileparse($temp_filename);
my $file_route_uri = "/$basename";

# -------------------------------------------------------------------------
# TEST GROUP 1: Standard File-Based Routing
# -------------------------------------------------------------------------
subtest 'Standard File-Based Routing' => sub {
  my @file_tests = (
    { name     => 'Valid Physical File',
      filename => $temp_filename,
      uri      => $file_route_uri,
      method   => 'GET',
      expect   => APACHE_OK,
    },
    { name     => 'Missing File (404)',
      filename => '/tmp/ghost_file.html',
      uri      => '/ghost.html',
      method   => 'GET',
      expect   => 404,
    },
  );

  foreach my $t (@file_tests) {
    # 1. Localize Environment
    local %ENV = %ENV;
    $ENV{DOCUMENT_ROOT}  = q{};
    $ENV{REQUEST_METHOD} = $t->{method};
    $ENV{REQUEST_URI}    = $t->{uri};

    # 2. Instantiate FauxHandler
    my $r = Bedrock::Test::FauxHandler->new(
      filename  => $t->{filename},
      method    => $t->{method},
      uri       => $t->{uri},
      buffer    => 1,
      log_level => 'debug',
    );

    # 3. Execute
    my $status = eval { Apache::Bedrock::handler($r) };

    is( $EVAL_ERROR, q{},          "$t->{name}: Handler ran without crashing" );
    is( $status,     $t->{expect}, "$t->{name}: Status matches" );

    #$r->log->close;
    #diag( $r->log->as_string );
  }
};

# -------------------------------------------------------------------------
# TEST GROUP 2: Config-Driven Routing (Bedrock::Router)
# -------------------------------------------------------------------------
subtest 'Config-Driven Routes (Bedrock::Router)' => sub {

  # 1. Define the Routes Config
  #    This matches the structure expected by Bedrock::Router
  create_route_config(
    { routes => [
        { pattern  => '/user/:id',
          template => 'user_profile.html',
        },
        { pattern  => '/api/search',
          template => 'search_results.html',
        }
      ]
    }
  );

  # 3. Test a Matching Route
  #    We use a URI that matches the pattern but implies a virtual file
  my $uri = '/user/42';

  local %ENV = %ENV;
  $ENV{DOCUMENT_ROOT}  = q{};
  $ENV{REQUEST_METHOD} = 'GET';
  $ENV{REQUEST_URI}    = $uri;

  # We pass the temp_filename as 'filename' to satisfy any initial
  # (-e) checks the handler might do before handing off to the router.
  my $r = Bedrock::Test::FauxHandler->new(
    filename  => $temp_filename,
    uri       => $uri,
    method    => 'GET',
    buffer    => 1,
    log_level => 'debug',
  );

  # 4. Execute Handler
  my $status = eval { Apache::Bedrock::handler($r) };

  is( $EVAL_ERROR, q{}, 'Config-Route: Handler executed successfully' );

  # If the router matched, it should return success (0)
  # or the result of the controller dispatch.
  # It should NOT be 404.
  is( $status, APACHE_OK, "Config-Route: Router matched and returned OK (0)" );

  # Optional: Verify captured params if you have a way to inspect the context
  # my $ctx = Bedrock::Context->get;
  # is($ctx->param('id'), 42, "Config-Route: Captured ID parameter");
};

done_testing();

1;
