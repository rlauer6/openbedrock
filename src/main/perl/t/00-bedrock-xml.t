#!/usr/bin/perl

use strict;
use warnings;

use Data::Dumper;
use English qw(-no_match_vars);
use File::Temp qw(tempfile);
use Scalar::Util qw(reftype);

use Test::More;

########################################################################
# first order broke tests...
########################################################################

########################################################################
use_ok('Bedrock::XML');
########################################################################

########################################################################
# trim leading whitespace
########################################################################
my $xml = <<'END_OF_XML';
   <object>
<!-- comment -->
<scalar name="foo">foo</scalar>
   </object>
END_OF_XML

my $obj = eval { return Bedrock::XML->newFromString($xml); };

ok( !$EVAL_ERROR && ref($obj), 'trim leading whitespace' )
  or diag($EVAL_ERROR);

ok( reftype($obj) eq 'HASH', 'isa hash' );
ok( $obj->{foo} eq 'foo',    'read a scalar' );

########################################################################
# comments
########################################################################
$xml = <<'END_OF_XML';
<object>
<!-- comment -->
  <scalar name="foo">foo</scalar>
</object>
END_OF_XML

$obj = eval { return Bedrock::XML->newFromString($xml); };

ok( !$EVAL_ERROR && ref($obj), 'comments' )
  or diag($EVAL_ERROR);

ok( reftype($obj) eq 'HASH', 'isa hash' );
ok( $obj->{foo} eq 'foo',    'read a scalar' );

########################################################################
# multi-line comments#
#######################################################################
$xml = <<'END_OF_XML';
<object>
<!-- multi-line comment 
adfadfadf
<foo>
 -->
  <scalar name="foo">foo</scalar>
  <array name="boo">
    <scalar>1</scalar>
    <scalar>2</scalar>
    <scalar>3</scalar>
    <scalar>4</scalar>
  </array>
</object>
END_OF_XML

$obj = eval { return Bedrock::XML->newFromString($xml); };

ok( !$EVAL_ERROR && ref($obj), 'multi-line comments' )
  or diag($EVAL_ERROR);

ok( reftype($obj) eq 'HASH',           'isa hash' );
ok( $obj->{foo} eq 'foo',              'read a scalar' );
ok( reftype( $obj->{boo} ) eq 'ARRAY', 'read an array' );
is_deeply( $obj->{boo}, [ 1, 2, 3, 4 ], 'array elements are correct' );

########################################################################
# read from file
#######################################################################
my ( $fh, $filename ) = tempfile( UNLINK => 1 );

print {$fh} $xml;

close $fh;

$obj = Bedrock::XML->new($filename);

ok( !$EVAL_ERROR && ref($obj), 'read from file' )
  or diag($EVAL_ERROR);

ok( reftype($obj) eq 'HASH', 'isa hash' );

ok( $obj->{foo} eq 'foo', 'read a scalar' )
  or diag( Dumper( [ obj => $obj ] ) );

########################################################################
# read from file handle
#######################################################################

open $fh, '<', $filename
  or BAIL_OUT("could not reopen $filename");

$obj = Bedrock::XML->new($fh);

close $fh;

ok( !$EVAL_ERROR && ref($obj), 'read from filehandle' )
  or diag($EVAL_ERROR);

ok( reftype($obj) eq 'HASH', 'isa hash' );

ok( $obj->{foo} eq 'foo', 'read a scalar' )
  or diag( Dumper( [ obj => $obj ] ) );

########################################################################
done_testing;
########################################################################

1;
