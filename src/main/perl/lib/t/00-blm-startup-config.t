use strict;
use warnings;

use Bedrock qw(slurp_file);
use Bedrock::Constants qw(:defaults :chars :booleans);
use Bedrock::Test::FauxContext qw(bind_module);

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

# setup .xml, .json and .yml version of config file

########################################################################
sub init_config_files {
########################################################################

  my $data = slurp_file(*DATA);

  my $obj = eval { return JSON->new->decode($data); };

  if ( !$obj || $EVAL_ERROR ) {
    diag(
      Dumper(
        [ data  => $data,
          obj   => $obj,
          error => $EVAL_ERROR,
        ]
      )
    );
    BAIL_OUT('unable to decode JSON config in __DATA__ section');
  }

  my %tempfile_list;

  my ( $fh, $filename );

  ( $fh, $filename ) = tempfile( 'XXXXX', SUFFIX => '.xml', UNLINK => $TRUE );
  Bedrock::XML::writeXML( $obj, $filename );
  $tempfile_list{xml} = $filename;
  close $fh;

  ( $fh, $filename ) = tempfile( 'XXXXX', SUFFIX => '.json', UNLINK => $TRUE );
  print {$fh} JSON->new->utf8->encode($obj);
  close $fh;
  $tempfile_list{json} = $filename;

  ( $fh, $filename ) = tempfile( 'XXXXX', SUFFIX => '.yml', UNLINK => $TRUE );
  DumpFile( $filename, [$obj] );
  $tempfile_list{yml} = $filename;
  close $fh;

  return %tempfile_list;
}

########################################################################
# TESTS START HERE
########################################################################
local $ENV{BEDROCK_CONFIG_PATH} = cwd;

my $ctx = Bedrock::Test::FauxContext->new( CONFIG => {} );

my $config;

my %tempfile_list = init_config_files();

########################################################################
subtest 'bind module' => sub {
########################################################################

  $config = bind_module( $ctx, {}, 'BLM::Startup::Config' );

  ok( !$EVAL_ERROR, 'bound module' )
    or do {
    diag($EVAL_ERROR);
    BAIL_OUT('could not bind module');
    };

  isa_ok( $config, 'BLM::Startup::Config' )
    or do {
    diag( Dumper( [$config] ) );
    BAIL_OUT('could not bind module');
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
