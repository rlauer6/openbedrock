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

  my ( $fh, $filename ) = tempfile( dir => $tmpdir, CLEANUP => 1 );

  my $autocomplete = [
    { label => 'Bedrock',             value => 1 },
    { label => 'Perl',                value => 2 },
    { label => 'Perl Best Practices', value => 3 },
  ];

  print {$fh} JSON->new->pretty->encode($autocomplete);

  close $fh;

  my ( $dir, $session_id ) = $tmpdir =~ /^(.*)[\/]([^\/]+)$/xsm;

  return ( $dir, $session_id, basename($filename) );
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
    content_type => 'application/json',
    uri          => '/session/' . $filename,
    filename     => $filename,
    log_level    => 'trace',
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

    my $stdout
      = stdout_from( sub { Apache::BedrockAutocomplete::handler($handler) } );

    like( $stdout, qr/\AContent-type:\sapplication\/json\n\n/xsm, 'content header' )
      or print $handler->log->as_string;
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

  done_testing;

  unlink "$dir/tagx.xml";

  return 0;
}

exit main();

1;
