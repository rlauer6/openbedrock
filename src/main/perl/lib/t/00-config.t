#00!/usr/bin/env perl

use strict;
use warnings;

use Bedrock::Constants qw(:defaults);
use Bedrock qw(slurp_file);
use Bedrock::Serializer qw(evolve devolve);
use Bedrock::Hash;
use Cwd qw(abs_path cwd getcwd);
use Data::Dumper;
use English qw(-no_match_vars);
use File::Temp qw(tempfile);
use JSON;
use YAML qw(Dump Load);
use List::Util qw( any );

use Test::More;

BEGIN {
  use_ok('Bedrock::BedrockConfig');
}

########################################################################
sub set_config_path {
########################################################################
  my $config_path = abs_path('../../../main/bedrock/config');

  if ( !$config_path || !-d $config_path ) {
    $config_path = cwd;
  }

  if ( !-e "$config_path/tagx.xml" ) {
    BAIL_OUT("could not find $config_path/tagx.xml");
  }

  return $config_path;
}

########################################################################

# read lines of file until '#'

########################################################################
sub read_lines {
########################################################################
  my ($fh) = @_;

  my $obj = q{};
  my $line;

  while ( $line = <$fh> ) {
    last if $line =~ /^[#]/xsm;
    $obj .= $line;
  }

  if ($line) {
    chomp $line;
  }

  return ( $obj, $line );
}

########################################################################
sub write_config {
########################################################################
  my ( $obj, $type ) = @_;

  my ( $fh, $filename ) = tempfile( 'XXXXX', SUFFIX => ".$type" );

  if ( !ref $obj ) {
    print {$fh} $obj;
  }
  else {
    if ( $type eq 'xml' ) {
      Bedrock::XML::writeXML( $obj, $fh );
    }
    elsif ( $type eq 'yaml' ) {
      print {$fh} Dump( devolve $obj );
    }
    elsif ( $type eq 'json' ) {
      print {$fh} JSON->new->pretty->encode( devolve $obj );
    }
  }

  close $fh;

  return $filename;
}

# create some arbitrary config files...all same objects
my ( $json, $xml, $yaml );

my ( $next_line, $xml_str, $yaml_str, $json_str );

while (1) {
  if ( !$next_line ) {
    $next_line = <DATA>;
  }

  last if !$next_line;

  chomp $next_line;

  my $thing = $next_line;

  for ($thing) {
    /^[#]\sxml/xsm && do {
      ( $xml_str, $next_line ) = read_lines(*DATA);

      $xml = Bedrock::XML->newFromString($xml_str);
      last;
    };

    /^[#]\syaml/xsm && do {
      ( $yaml_str, $next_line ) = read_lines(*DATA);

      $yaml = Load($yaml_str);

      if ( !ref $yaml ) {
        BAIL_OUT( "failed to deserialize yaml\n", diag( Dumper [ $yaml, $yaml_str ] ) );
      }

      last;
    };

    /^[#]\sjson/xsm && do {
      ( $json_str, $next_line ) = read_lines(*DATA);

      $json = JSON->new->decode($json_str);
      last;
    };
  }
}

# sanity check
is_deeply( $xml, $json, 'xml = json' ) or diag( Dumper [ $xml, $json ] );

is_deeply( $xml, $yaml, 'xml = yaml' ) or diag( Dumper [ $xml, $yaml ] );

is_deeply( $yaml, $json, 'yaml = json' ) or diag( Dumper [ $yaml, $json ] );

# serialize the objects

my %config_files;

my $cwd = abs_path(cwd);

$config_files{xml} = { filename => write_config( $xml, 'xml' ), obj => $xml };
$xml->{_config_path} = $cwd . q{/} . $config_files{xml}->{filename};

$config_files{yaml}
  = { filename => write_config( $yaml, 'yaml' ), obj => $yaml };

$yaml->{_config_path} = $cwd . q{/} . $config_files{yaml}->{filename};

$config_files{json}
  = { filename => write_config( $json, 'json' ), obj => $json };

$json->{_config_path} = $cwd . q{/} . $config_files{json}->{filename};

########################################################################
subtest 'Read all types' => sub {
########################################################################

  for my $t (qw/xml yaml json/) {
    my $file = $config_files{$t}->{filename};

    my $content = slurp_file( sprintf '%s/%s', $cwd, $file );

    my $config = eval { Bedrock::Config->new( $cwd . q{/} . $file ); };

    ok( $config, 'read config' )
      or do {
      diag(
        Dumper(
          [ content => $content,
            error   => $EVAL_ERROR
          ]
        )
      );
      BAIL_OUT( 'could not read config ' . $file );
      };

    is_deeply( $config, $config_files{$t}->{obj}, "type: $t" );

    unlink $config_files{$t}->{filename};
  }
};

my $config_path = set_config_path();

########################################################################
subtest 'CONFIG_PATH' => sub {
########################################################################
  local $ENV{BEDROCK_CONFIG_PATH} = undef;

  local $ENV{CONFIG_PATH} = $config_path;

  my $config = Bedrock::Config->new('tagx.xml');

  isa_ok( $config, 'Bedrock::Config' ) or diag($config);

  ok( $config->config_path && $config->config_path eq "$config_path/tagx.xml", 'config path' )
    or diag( Dumper( [ $config_path, $config->config_path ] ) );
};

########################################################################
subtest 'BEDROCK_CONFIG_PATH' => sub {
########################################################################
  delete $ENV{CONFIG_PATH};

  local $ENV{BEDROCK_CONFIG_PATH} = $config_path;

  my $config = Bedrock::Config->new('tagx.xml');

  isa_ok( $config, 'Bedrock::Config' ) or diag($config);

  ok( $config->config_path && $config->config_path eq "$config_path/tagx.xml", 'config path' )
    or diag( Dumper( [ $config_path, $config->config_path ] ) );
};

########################################################################
subtest 'default config path' => sub {
########################################################################
  local $ENV{CONFIG_PATH} = undef;

  local $ENV{BEDROCK_CONFIG_PATH} = undef;

  my $config;

  eval { $config = Bedrock::Config->new('tagx.xml'); };

  SKIP: {
    if ($EVAL_ERROR) {
      skip 'no config file found.', 2;
    }

    isa_ok( $config, 'Bedrock::Config' )
      or diag($config);

    my (@default_paths) = map {"$_/tagx.xml"} ( getcwd, $DEFAULT_BEDROCK_CONFIG_PATH );

    ok( ( $config->config_path && any { $config->config_path eq $_ } @default_paths ), 'default config path' )
      or diag( Dumper( [ $config->config_path ] ) );
  }
};

########################################################################
subtest 'xml' => sub {
########################################################################
  local $ENV{CONFIG_PATH} = $config_path;

  my $config = Bedrock::Config->new('tagx.xml');

  isa_ok( $config, 'Bedrock::Config' );

  my $xml = $config->to_xml();
  ok( $xml,       'to_xml()' );
  ok( !ref($xml), 'is scalar' );

  my $obj = Bedrock::XML->newFromString($xml);
  is_deeply( $obj, $config, 'is_deeply' );
};

########################################################################
subtest 'json' => sub {
########################################################################
  local $ENV{CONFIG_PATH} = $config_path;

  my $config = Bedrock::Config->new('tagx.xml');

  $config->config_path(undef);
  isa_ok( $config, 'Bedrock::Config' );

  my $json = $config->to_json();

  ok( $json,       'to_json()' );
  ok( !ref($json), 'is scalar' );

  my $filename = write_config( $json, 'json' );

  my $obj = JSON->new->utf8->decode($json);
  is_deeply( $obj, $config, 'is_deeply' ) or diag($obj);

  my $json_config = Bedrock::Config->new( cwd . q{/} . $filename );
  $json_config->config_path(undef);
  is_deeply( $json_config, $config );

  unlink $filename;
};

########################################################################
subtest 'yaml' => sub {
########################################################################
  my $config = Bedrock::Config->new('tagx.xml');

  isa_ok( $config, 'Bedrock::Config' );

  $config->config_path(undef);

  my $yaml = $config->to_yaml();

  ok( $yaml, 'to_yaml()' );

  ok( !ref($yaml), 'is scalar' );

  my $filename = write_config( $yaml, 'yaml' );

  my $obj = Load($yaml);
  is_deeply( $obj, $config, 'is_deeply' ) or diag($obj);

  my $yaml_config = Bedrock::Config->new( cwd . q{/} . $filename );
  $yaml_config->config_path(undef);

  is_deeply( $yaml_config, $config );

  unlink $filename;
};

########################################################################
subtest 'merge' => sub {
########################################################################
  my $config_path = set_config_path();

  my $config = Bedrock::Config->new("$config_path/tagx.xml");

  $config->merge_config( { MODULES => [ Bedrock::Hash->new( binding => 'foo', module => 'Foo::Bar' ) ], } );

  ok( any { $_->{binding} eq 'foo' } @{ $config->{MODULES} }, 'merge object' );

  # overwrite foo
  $config->merge_config(
    { MODULES => [
        Bedrock::Hash->new(
          binding   => 'foo',
          module    => 'Foo::Buz',
          overwrite => 'yes',
          config    => {}
        )
      ],
    }
  );

  my ($module) = grep { $_->{binding} eq 'foo' } @{ $config->{MODULES} };

  ok( exists $module->{module} && $module->{module} eq 'Foo::Buz', 'overwrite merged object' );
};

########################################################################
subtest 'get_module_config' => sub {
########################################################################
  my $config_path = set_config_path();

  my $config = Bedrock::Config->new("$config_path/tagx.xml");

  $config->merge_config(
    { MODULES => [
        Bedrock::Hash->new(
          binding => 'foo',
          module  => 'BLM::Startup::Buzz',
          config  => Bedrock::Hash->new( foo => 'bar' )
        ),
      ],
    }
  );

  my $input = $config->get_module_config('Buzz');

  isa_ok( $input, 'Bedrock::Hash' )
    or diag( Dumper( [ $input, $config ] ) );

  ok( exists $input->{foo} && $input->{foo} eq 'bar', 'retrieved config object' )
    or diag( Dumper( [ $input, $config ] ) );
};

########################################################################
subtest 'merge' => sub {
########################################################################
  my $config_path = set_config_path();

  my $config = Bedrock::Config->new("$config_path/tagx.xml");

  my $filename = write_config( { yaml => 'Camel' }, 'yaml' );
  $config->merge($filename);
  ok( $config->{yaml}, 'yaml file merged' );
  unlink $filename;

  $filename = write_config( { json => 'mason' }, 'json' );
  $config->merge($filename);
  ok( $config->{json}, 'json file merged' );
  ok( $config->{yaml}, 'yaml still file merged' );

  unlink $filename;
};

done_testing;

1;

__DATA__
# xml
<object>
  <object name="foo">
    <scalar name="first">1st</scalar>
    <scalar name="second">2nd</scalar>
    <scalar name="third">3rd</scalar>
  </object>
  <array name="boo">
    <scalar>1</scalar>
    <scalar>2</scalar>
  </array>
  <scalar name="buz">string</scalar>
  <scalar name="biz"></scalar>

</object>
# yaml
---
biz: ''
boo:
  - 1
  - 2
buz: string
foo:
  first: 1st
  second: 2nd
  third: 3rd
# json
{
   "boo" : [
      "1",
      "2"
   ],
   "biz" : "",
   "buz" : "string",
   "foo" : {
      "first" : "1st",
      "second" : "2nd",
      "third" : "3rd"
   }
}
