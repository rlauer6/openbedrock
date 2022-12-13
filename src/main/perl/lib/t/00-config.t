use strict;
use warnings;

use Bedrock::Serializer qw/evolve devolve/;
use Bedrock::Hash;

use Cwd qw/abs_path cwd/;
use Data::Dumper;
use File::Temp qw/tempfile/;
use JSON::PP;
use YAML qw/Dump Load/;
use List::Util qw{ any };

use Test::More tests => 13;

BEGIN {
  use_ok('Bedrock::BedrockConfig');
}

# read lines of file until '#'
sub read_lines {
  my ($fh) = @_;

  my $obj = '';
  my $line;

  while ( $line = <$fh> ) {
    last if $line =~ /^#/;
    $obj .= $line;
  }

  chomp $line
    if $line;

  return ( $obj, $line );
}

sub write_config {
  my ( $obj, $type ) = @_;

  my ( $fh, $filename ) = tempfile( 'XXXXX', SUFFIX => ".$type" );

  if ( !ref($obj) ) {
    print $fh $obj;
  }
  else {
    if ( $type eq 'xml' ) {
      Bedrock::XML::writeXML( $obj, $fh );
    }
    elsif ( $type eq 'yaml' ) {
      print $fh Dump( devolve $obj);
    }
    elsif ( $type eq 'json' ) {
      print $fh JSON::PP->new->utf8->pretty->encode( devolve $obj);
    }
  } ## end else [ if ( !ref($obj) ) ]

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
    /^# xml/ && do {
      ( $xml_str, $next_line ) = read_lines(*DATA);

      $xml = Bedrock::XML->newFromString($xml_str);
      last;
    };

    /^# yaml/ && do {
      ( $yaml_str, $next_line ) = read_lines(*DATA);

      $yaml = Load($yaml_str);

      if ( !ref($yaml) ) {
        BAIL_OUT(
          "failed to deserialize yaml\n",
          diag( Dumper [ $yaml, $yaml_str ] )
        );
      }

      last;
    };

    /^# json/ && do {
      ( $json_str, $next_line ) = read_lines(*DATA);

      $json = JSON::PP->new->utf8->decode($json_str);
      last;
    };
  }
}

# sanity check
is_deeply( $xml,  $json, 'xml = json' )  or diag( Dumper [ $xml,  $json ] );
is_deeply( $xml,  $yaml, 'xml = yaml' )  or diag( Dumper [ $xml,  $yaml ] );
is_deeply( $yaml, $json, 'yaml = json' ) or diag( Dumper [ $yaml, $json ] );

# serialize the objects

my %config_files;
my $cwd = abs_path(cwd);

$config_files{xml} = { filename => write_config( $xml, 'xml' ), obj => $xml };
$xml->{_config_path} = $cwd . '/' . $config_files{xml}->{filename};

$config_files{yaml}
  = { filename => write_config( $yaml, 'yaml' ), obj => $yaml };
$yaml->{_config_path} = $cwd . '/' . $config_files{yaml}->{filename};

$config_files{json}
  = { filename => write_config( $json, 'json' ), obj => $json };
$json->{_config_path} = $cwd . '/' . $config_files{json}->{filename};

subtest 'Read all types' => sub {

  for my $t (qw/xml yaml json/) {
    my $config = eval {
      Bedrock::Config->new( $cwd . '/' . $config_files{$t}->{filename} );
    };

    is_deeply( $config, $config_files{$t}->{obj}, "type: $t" );

    unlink( $config_files{$t}->{filename} );
  }
};

my $config_path = abs_path("../../../main/bedrock/config");

if ( !$config_path ) {
  BAIL_OUT("could not find config path");
}
elsif ( !-e "$config_path/tagx.xml" ) {
  BAIL_OUT("could not find $config_path/tagx.xml");
}

subtest 'CONFIG_PATH' => sub {
  delete $ENV{BEDROCK_CONFIG_PATH};
  $ENV{CONFIG_PATH} = $config_path;
  my $config = Bedrock::Config->new("tagx.xml");

  isa_ok( $config, 'Bedrock::Config' ) or diag($config);
  ok(
    $config->{_config_path}
      && $config->{_config_path} eq "$config_path/tagx.xml",
    'config path'
  ) or diag( Dumper( [ $config->{_config_path}, $config ] ) );
};

subtest 'BEDROCK_CONFIG_PATH' => sub {
  delete $ENV{CONFIG_PATH};
  $ENV{BEDROCK_CONFIG_PATH} = $config_path;
  my $config = Bedrock::Config->new("tagx.xml");

  isa_ok( $config, 'Bedrock::Config' ) or diag($config);
  ok(
    $config->{_config_path}
      && $config->{_config_path} eq "$config_path/tagx.xml",
    'config path'
  ) or diag( Dumper( [ $config->{_config_path}, $config ] ) );
};

subtest '/usr/lib/bedrock/config' => sub {
  delete $ENV{CONFIG_PATH};
  delete $ENV{BEDROCK_CONFIG_PATH};
  my $config = Bedrock::Config->new("tagx.xml");

  isa_ok( $config, 'Bedrock::Config' ) or diag($config);
  ok(
    $config->{_config_path}
      && $config->{_config_path} eq '/usr/lib/bedrock/config/tagx.xml',
    'config path'
  ) or diag( Dumper $config);
};

subtest 'xml' => sub {
  $ENV{CONFIG_PATH} = $config_path;
  my $config = Bedrock::Config->new("tagx.xml");
  isa_ok( $config, 'Bedrock::Config' );

  my $xml = $config->to_xml();
  ok( $xml,       'to_xml()' );
  ok( !ref($xml), 'is scalar' );

  my $obj = Bedrock::XML->newFromString($xml);
  is_deeply( $obj, $config, 'is_deeply' );
};

subtest 'json' => sub {
  $ENV{CONFIG_PATH} = $config_path;
  my $config = Bedrock::Config->new("tagx.xml");
  delete $config->{_config_path};
  isa_ok( $config, 'Bedrock::Config' );

  my $json = $config->to_json();

  ok( $json,       'to_json()' );
  ok( !ref($json), 'is scalar' );

  my $filename = write_config( $json, 'json' );

  my $obj = JSON::PP->new->utf8->decode($json);
  is_deeply( $obj, $config, 'is_deeply' ) or diag($obj);

  my $json_config = Bedrock::Config->new( cwd . '/' . $filename );
  delete $json_config->{_config_path};
  is_deeply( $json_config, $config );

  unlink($filename);
};

subtest 'yaml' => sub {
  my $config = Bedrock::Config->new('tagx.xml');
  isa_ok( $config, 'Bedrock::Config' );
  delete $config->{_config_path};

  my $yaml = $config->to_yaml();

  ok( $yaml,       'to_yaml()' );
  ok( !ref($yaml), 'is scalar' );

  my $filename = write_config( $yaml, 'yaml' );

  my $obj = Load($yaml);
  is_deeply( $obj, $config, 'is_deeply' ) or diag($obj);

  my $yaml_config = Bedrock::Config->new( cwd . '/' . $filename );
  delete $yaml_config->{_config_path};

  is_deeply( $yaml_config, $config );

  unlink($filename);
};

subtest 'merge' => sub {
  my $config_path = abs_path '../../../main/bedrock/config';

  my $config = Bedrock::Config->new("$config_path/tagx.xml");

  $config->merge_config(
    { MODULES =>
        [ Bedrock::Hash->new( binding => 'foo', module => 'Foo::Bar' ) ],
    }
  );

  ok( any { $_->{binding} eq 'foo' } @{ $config->{MODULES} },
    'merge object' );

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

  ok( exists $module->{module} && $module->{module} eq 'Foo::Buz',
    'overwrite merged object' );
};

subtest 'get_module_config' => sub {
  my $config_path = abs_path '../../../main/bedrock/config';

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

  isa_ok( $input, 'Bedrock::Hash' ) or diag( Dumper( [ $input, $config ] ) );

  ok( exists $input->{foo} && $input->{foo} eq 'bar',
    'retrieved config object' )
    or diag( Dumper( [ $input, $config ] ) );
};

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
