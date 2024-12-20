use strict;
use warnings;

package Faux::Context;

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
sub getCookieValue   { }
sub getInputValue    { }
sub getConfigValue   { }

########################################################################
package main;

use lib qw{.};

use Bedrock qw(slurp_file);
use Bedrock::Constants qw(:defaults :chars :booleans);
use Cwd;
use Data::Dumper;
use English qw(-no_match_vars);
use JSON;
use YAML::Tiny qw(DumpFile);
use Bedrock::XML;
use File::Temp qw(tempfile);
use File::Basename qw(fileparse);
use Test::More;
use Scalar::Util qw(reftype);

use_ok('BLM::Startup::Config');

########################################################################
sub bind_module {
########################################################################
  my ( $ctx, $config ) = @_;

  my $module = q{BLM::Startup::Config};

  my $obj = bless {}, $module;

  tie %{$obj}, $module, $ctx, $config;  ## no critic (ProhibitTies)

  return $obj;
}

# setup .xml, .json and .yml version of config file

my $obj = JSON->new->decode( scalar slurp_file(*DATA) );
my %tempfile_list;

my ( $fh, $filename );

( $fh, $filename ) = tempfile( 'XXXXX', SUFFIX => '.xml', UNLINK => $TRUE );
Bedrock::XML::writeXML( $obj, $filename );
$tempfile_list{xml} = $filename;

( $fh, $filename ) = tempfile( 'XXXXX', SUFFIX => '.json', UNLINK => $TRUE );
print {$fh} JSON->new->encode($obj);
$tempfile_list{json} = $filename;

( $fh, $filename ) = tempfile( 'XXXXX', SUFFIX => '.yml', UNLINK => $TRUE );
DumpFile( $filename, [$obj] );
$tempfile_list{yml} = $filename;

my ( undef, $path, undef ) = fileparse( $filename, qr/[^.]+[.].*$/xsm );

########################################################################
local $ENV{BEDROCK_CONFIG_PATH} = cwd;

my $ctx = Faux::Context->new( CONFIG => {} );

my $config;
########################################################################
subtest 'bind module' => sub {
########################################################################

  $config = bind_module( $ctx, {} );
  ok( !$EVAL_ERROR, 'bound module' );

  isa_ok( $config, 'BLM::Startup::Config' )
    or do {
    diag( Dumper( [$config] ) );
    BAIL_OUT('config is not instantiated properly');
    };
};

########################################################################
subtest 'read config from filename' => sub {
########################################################################
  foreach my $ext ( keys %tempfile_list ) {

    my $obj = eval { return $config->site_config( $tempfile_list{$ext} ); };

    ok( !$EVAL_ERROR && $obj && reftype($obj) eq 'HASH', "read a $ext file" )
      or diag(
      Dumper(
        [ error   => $EVAL_ERROR,
          obj     => $obj,
          reftype => reftype($obj)
        ]
      )
      );
  }
};

########################################################################
subtest 'read config from file handle' => sub {
########################################################################
  foreach my $ext ( keys %tempfile_list ) {
    open my $fh, '<', $tempfile_list{$ext}
      or BAIL_OUT( 'could not read ' . $tempfile_list{$ext} );

    my $obj = eval { return $config->site_config($fh); };

    close $fh;

    ok( !$EVAL_ERROR && $obj && reftype($obj) eq 'HASH', "read a $ext from file handle" )
      or diag(
      Dumper(
        [ error   => $EVAL_ERROR,
          obj     => $obj,
          reftype => reftype($obj)
        ]
      )
      );
  }
};

########################################################################
subtest 'invalid extension' => sub {
########################################################################
  eval { $config->site_config('foo.cfg'); };

  ok( $EVAL_ERROR, 'only .xml, .json, .yml allowed' );
};

done_testing;

########################################################################
END {

}

1;

__DATA__
{
 "table": "form_test",
 "javascript": [
     {
      "src": "https://code.jquery.com/jquery-3.7.1.min.js",
      "integrity": "sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=",
      "crossorigin": "anonymous"
     },
     {
      "src": "indexed-table-handler.js"
     },
     {
      "src": "https://code.jquery.com/ui/1.14.1/jquery-ui.js"
     }
   ],
 "link": [
    {
     "rel": "stylesheet",
     "href": "https://code.jquery.com/ui/1.14.1/themes/base/jquery-ui.css"
    }
  ],
 "database": {
   "dsn": "dbi:mysql:bedrock",
   "user": "fred",
   "password": "flintstone",
   "hostname": "docker_db_1"
 },
 "title": "Test"
}
