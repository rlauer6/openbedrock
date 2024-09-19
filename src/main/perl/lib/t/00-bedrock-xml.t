use strict;
use warnings;

use Test::More tests => 7;

use File::Temp qw( mkstemps );
use English qw(-no_match_vars);
use Data::Dumper;

BEGIN {
  use_ok('Bedrock::XML');
}

########################################################################
sub write_xml {
########################################################################
  my $xml = eval {
    local $RS = undef;

    return <DATA>;
  };

  my ( $fh, $filename ) = mkstemps( 'tagx-XXXX', '.xml' );
  print {$fh} "$xml\n";
  close $fh;

  return ( $xml, $filename );
}

my $obj = {
  foo => {
    first  => '1st',
    second => '2nd',
    third  => '3rd',
  },
  boo     => [ 1, 2 ],
  buz     => 'string',
  biz     => q{},
  encoded => q{< > & " '},
};

my ( $xml, $filename ) = write_xml();

my $xml_obj = Bedrock::XML->new($filename);

is_deeply( $xml_obj, $obj, 'new from file' )
  or diag( Dumper( [ $xml_obj, $obj ] ) );

$xml_obj = Bedrock::XML->newFromString($xml);

is_deeply( $xml_obj, $obj, 'new from string' )
  or diag( Dumper( [ $xml_obj, $obj ] ) );

my $xml_str = Bedrock::XML->writeXMLString($xml_obj);

ok( $xml_str && length $xml_str > 0, 'writeXMLString produced a string' );

is_deeply( $obj, Bedrock::XML->newFromString($xml_str), 'writeXMLString produced same object' );

unlink $filename;

Bedrock::XML::writeXML( $obj, $filename );

ok( -e $filename && -s $filename, 'writeXML(' . $filename . ')' );

unlink $filename;

open my $fh, '>', $filename
  or BAIL_OUT("could not open $filename for writing");

Bedrock::XML::writeXML( $obj, $fh );
close $fh;

ok( -e $filename && -s $filename, 'writeXML(' . $filename . ') using file handle' );

END {
  eval { unlink $filename; };
}

1;

__DATA__
<!-- test comment
multi-line comment
-->
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
  <scalar name="encoded">&lt; &gt; &amp; &quot; &apos;</scalar>
</object>
