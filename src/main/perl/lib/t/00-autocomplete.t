#!/usr/bin/env perl

use strict;
use warnings;

BEGIN {
  use Bedrock;
  use File::Basename qw(dirname basename);

  my $path = dirname( $INC{'Bedrock.pm'} );
  push @INC, "$path/Bedrock", "$path/Bedrock/Text";
}

########################################################################
package Bedrock::Test::FauxSession;
########################################################################

########################################################################
sub get_session_dir {
########################################################################
  my ($self) = @_;

  return sprintf '%s/%s', @{$self}{qw(dir session)};
}

########################################################################
package main;
########################################################################

use Data::Dumper;
use English qw(-no_match_vars);
use File::Basename qw(basename);
use Bedrock::Test::FauxHandler;
use File::Temp qw(tempdir tempfile);
use JSON;
use Scalar::Util qw(reftype);
use Test::More;
use Test::Output;

########################################################################
sub create_temp_file {
########################################################################

  my $tmpdir = tempdir( CLEANUP => 1 );

  my ( $fh, $filename ) = tempfile( dir => $tmpdir, UNLINK => 1 );

  my $autocomplete = [
    { label => 'Bedrock',
      value => 1
    },
    { label => 'Perl',
      value => 2
    },
    { label => 'Perl Best Practices',
      value => 3
    },
  ];

  print {$fh} JSON->new->pretty->encode($autocomplete);

  close $fh;

  my ( $dir, $session_id ) = $tmpdir =~ /^(.*)[\/]([^\/]+)$/xsm;

  return ( $tmpdir, $session_id, $filename );
}

########################################################################
sub create_tagx_xml {
########################################################################
  my ( $dir, $session ) = @_;

  my $tagx_xml = <<"END_OF_XML";
<object>
  <scalar name='SESSION_DIR'>$dir</scalar>
</object>
END_OF_XML

  open my $fh, '>', "$dir/tagx.xml"
    or die "could not open $dir/tagx_xml for writing\n";

  print {$fh} $tagx_xml;

  close $fh;

  return;
}

########################################################################
sub main {
########################################################################
  use_ok('Apache::BedrockAutocomplete');

  my ( $dir, $session_id, $filename ) = create_temp_file;

  my $handler = Bedrock::Test::FauxHandler->new(
    content_type  => 'application/json',
    uri           => '/session/' . basename($filename),
    filename      => $filename,
    log_level     => 'trace',
    document_root => $dir,
  );

  create_tagx_xml( $dir, $session_id );

  local $ENV{BEDROCK_CONFIG_PATH} = $dir;
  {
    no strict 'refs';        ## no critic (ProhibitNoStrict)
    no warnings 'redefine';  ## no critic (ProhibitNoWarnings)

    *{'Bedrock::Apache::HandlerUtils::check_session'} = sub {
      return bless {
        session => $session_id,
        dir     => $dir
        },
        'Bedrock::Test::FauxSession';
    };

  }

########################################################################
  subtest 'content header' => sub {
########################################################################
    local $ENV{QUERY_STRING} = 'term=be';

    my $stdout = stdout_from( sub { Apache::BedrockAutocomplete::handler($handler) } );

    like( $stdout, qr/\AContent-type:\sapplication\/json\n\n/xsm, 'content header' )
      or do {
      diag($stdout);
      diag( $handler->log->as_string );
      BAIL_OUT('ERROR: first order broke! no headers!');
      };
  };

########################################################################
  subtest 'JSON payload' => sub {
########################################################################

    local $ENV{QUERY_STRING} = 'term=be';

    my $stdout
      = stdout_from( sub { Apache::BedrockAutocomplete::handler($handler) } );

    my ($json) = $stdout =~ /\n\n(.*)\z/xsm;

    my $obj = eval { return JSON->new->decode($json); };

    ok( ref($obj), 'JSON payload' );

    is( reftype($obj), 'ARRAY', 'array payload' );
  };

########################################################################
  subtest 'keys' => sub {
########################################################################

    local $ENV{QUERY_STRING} = 'term=be';

    my $stdout
      = stdout_from( sub { Apache::BedrockAutocomplete::handler($handler) } );

    my ($json) = $stdout =~ /\n\n(.*)\z/xsm;

    my $obj = eval { return JSON->new->decode($json); };

    is( reftype( $obj->[0] ), 'HASH', 'hash element' );

    is_deeply( [ sort keys %{ $obj->[0] } ], [qw(label value)], 'keys: label, value' );

    is( $obj->[0]->{label}, 'Bedrock', 'label is Bedrock' );

    is( $obj->[0]->{value}, '1', 'value is 1' );
  };

########################################################################
  subtest 'multiple results' => sub {
########################################################################

    local $ENV{QUERY_STRING} = 'term=pe';

    my $stdout
      = stdout_from( sub { Apache::BedrockAutocomplete::handler($handler) } );

    my ($json) = $stdout =~ /\n\n(.*)\z/xsm;

    my $obj = eval { return JSON->new->decode($json); };

    is( @{$obj}, 2, '2 terms found' );
  };

########################################################################
  subtest 'global directory fallback' => sub {
########################################################################
    # 1. Create a separate "Global" directory and file
    my $global_dir  = tempdir( CLEANUP => 1 );
    my $global_file = "$global_dir/global_items.json";

    my $data = [ { label => 'Global Item', value => 99 } ];

    open my $fh, '>', $global_file or die "Cannot write global file: $!";
    print {$fh} JSON->new->encode($data);
    close $fh;

    # 2. Setup a handler requesting this file
    # Note: We use a filename that DOES NOT exist in the session dir,
    # forcing the handler to look elsewhere.
    my $r_global = Bedrock::Test::FauxHandler->new(
      content_type => 'application/json',
      filename     => '/var/www/dummy/global_items.json',  # Physical path (missing)
      uri          => '/autocomplete/global_items.json',   # Logical path
      log_level    => 'error',
    );

    # 3. Set the Environment Variable
    local $ENV{BEDROCK_AUTOCOMPLETE_ROOT} = $global_dir;
    local $ENV{QUERY_STRING}              = 'term=global';

    # 4. Run the Handler
    # The mock check_session (defined in main) will pass, but the file won't be
    # found in the session dir. It should fall back to $global_dir.
    my $stdout = stdout_from( sub { Apache::BedrockAutocomplete::handler($r_global) } );

    # 5. Verify Results
    my ($json) = $stdout =~ /\n\n(.*)\z/xsm;
    my $obj = eval { JSON->new->decode($json) };

    ok( $obj, 'Got JSON response from global directory fallback' );
    is( $obj->[0]->{label}, 'Global Item', 'Correctly served content from BEDROCK_AUTOCOMPLETE_ROOT' );
  };

  done_testing;

  unlink "$dir/tagx.xml";

  return 0;
}

exit main();

1;
