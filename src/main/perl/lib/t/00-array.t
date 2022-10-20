#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 25;

use Data::Dumper;
use English qw{-no_match_vars};
use Scalar::Util qw{blessed reftype};

BEGIN {
  use_ok('Bedrock::Array');
}

########################################################################
subtest 'new' => sub {
########################################################################
  my $array = Bedrock::Array->new( 0 .. 9 );

  isa_ok( $array, 'Bedrock::Array' );

  isa_ok( $array, 'ARRAY' );

  is( @{$array}, 10, '10 element array' )
    or diag( Dumper( [$array] ) );

  $array = $array->new( 1, 2, 3 );

  isa_ok( $array, 'Bedrock::Array' );

  is( @{$array}, 3, '3 element array' )
    or diag( Dumper( [$array] ) );
};

########################################################################
subtest 'get' => sub {
########################################################################

  my $array = Bedrock::Array->new( reverse 0 .. 4 );

  foreach ( 0 .. $#{$array} ) {
    is( $array->get($_), $#{$array} - $_ );
  }

  eval { $array->get('foo'); };

  ok( $EVAL_ERROR && $EVAL_ERROR =~ /index\smust\sbe\sinteger/xsm,
    'bad index' )
    or diag( Dumper( [$EVAL_ERROR] ) );
};

########################################################################
subtest 'sort' => sub {
########################################################################
  my $array = Bedrock::Array->new( 0 .. 9 );

  my $sorted_array = $array->sort( 'desc', 'num' );

  is_deeply(
    $sorted_array,
    [ ( reverse 0 .. 9 ) ],
    'numeric sort - descending'
  );

  my $new_array = $array->new( reverse 0 .. 9 );

  $sorted_array = $new_array->sort( 'asc', 'num' );

  is_deeply( $sorted_array, [ ( 0 .. 9 ) ], 'numeric sort - descending' );

  $array        = $array->new( 'a' .. 'z' );
  $sorted_array = $array->sort( 'desc', 'alpha' );
  is_deeply(
    $sorted_array,
    [ reverse 'a' .. 'z' ],
    'alpha sort - descending'
  );

  $array        = $array->new( reverse 'a' .. 'z' );
  $sorted_array = $array->sort( 'asc', 'alpha' );
  is_deeply( $sorted_array, [ 'a' .. 'z' ], 'alpha sort - ascnding' );

};

########################################################################
subtest 'splice' => sub {
########################################################################
  my $array = Bedrock::Array->new( 0 .. 9 );

  $array = $array->splice( 8, 1 );
  is( @{$array}, 9, 'length is reduced by 1' );

  is( $array->[8], 9, 'removed 9th element (8)' )
    or diag( Dumper( [$array] ) );

  $array = $array->splice(7);
  is( @{$array}, 7, 'remove last two elements' );

  $array = $array->splice( 7, 3, 7, 8, 9 );
  is( @{$array}, 10, 'add 3 elements' );
  is_deeply( $array, [ 0 .. 9 ], '0..9' );

};
########################################################################
subtest 'shift' => sub {
########################################################################
  my $array = Bedrock::Array->new( 0 .. 9 );
  is( $array->shift, 0, 'first element' );
  is( $array->shift, 1, 'second element' );

};

########################################################################
subtest 'unshift' => sub {
########################################################################
  my $array = Bedrock::Array->new( 0 .. 9 );

  is( $array->unshift('x'), 11, 'unshift x' );

  is( @{$array}, 11, 'added 1 element' );

  is( $array->get(0), 'x', 'first element is x' )
    or diag( Dumper( [$array] ) );

  my $foo = [ 0 .. 9 ];

  is( $array->unshift($foo), 21, 'add a reference to an array' );

  is_deeply( $array, [ ( 0 .. 9 ), 'x', ( 0 .. 9 ) ],
    'new array is correct' );
};

########################################################################
subtest 'push' => sub {
  my $array = Bedrock::Array->new;
  $array->push( 0 .. 9 );

  is( @{$array}, 10, 'push 10 items on array' );
};

########################################################################
subtest 'pop' => sub {
########################################################################
  my $array = Bedrock::Array->new( 0 .. 9 );
  is( $array->pop(), 9, 'pop()' );

  is( @{$array}, 9, 'reduced array by 1' );

  my $new_array = $array->pop(5);

  is( @{$array}, 4, 'popped 5' );
  is_deeply( $array, [ 0, 1, 2, 3 ], 'array shortened' )
    or diag( Dumper( [ $array, $new_array ] ) );

};

########################################################################
subtest 'join' => sub {
########################################################################
  my $array = Bedrock::Array->new( 0 .. 9 );

  is( $array->join(','), ( join ',', 0 .. 9 ), 'join(",")' );

};

########################################################################
subtest 'bedrock_xml' => sub {
########################################################################
  my $array = Bedrock::Array->new( 0 .. 9 );
  my $xml   = $array->bedrock_xml;

  ok( $xml, 'bedrock_xml()' );
  like( $xml, qr/<array\s*>.*<\/array>/xsm, '<array>...</array>' );

  require Bedrock::XML;
  is_deeply( $array, Bedrock::XML->newFromString($xml) );

  $xml = $array->bedrock_xml('foo');
  like( $xml, qr/<object\s*>.*<\/object>/xsm, '<object>...</object>' );
  is_deeply( { foo => $array }, Bedrock::XML->newFromString($xml) );

};

########################################################################
subtest 'devolve' => sub {
########################################################################
  my $array = Bedrock::Array->new( 0 .. 9 );

  ok( !blessed $array->devolve, 'not blessed' );
  require Bedrock::Hash;

  my $foo = Bedrock::Hash->new( foo => $array );
  $array = $array->new( $foo, 0, 2, 4, $array->new( 0 .. 9 ) );

  my $new_array = $array->devolve;

  ok( !blessed $new_array,      'new array not blessed' );
  ok( !blessed $new_array->[0], 'hash not blessed' );
  ok( !blessed $new_array->[4], '4th element not blessed' );
};

########################################################################
subtest 'grep' => sub {
########################################################################
  my $array = Bedrock::Array->new(qw{ the quick brown fox ate a fish });

  is_deeply( $array->grep('^q'), ['quick'], 'single value' );

  eval { $array->grep('qr/quick/*/xsm') };

  ok( $EVAL_ERROR && $EVAL_ERROR =~ /invalid\spattern/ixsm,
    'invalid pattern' )
    or diag( Dumper( [$EVAL_ERROR] ) );

  is_deeply( $array->grep('qr/^f/xsmi'), [qw{ fox fish }], 'qr//' )
    or diag( Dumper( [ $array->grep('qr/^f/xsmi') ] ) );

};

########################################################################
subtest 'isEmpty' => sub {
########################################################################
  my $array = Bedrock::Array->new();

  ok( $array->isEmpty, 'array is empty' )
    or diag( Dumper( [ $array->isEmpty ] ) );

  $array = $array->new( 0 .. 9 );
  ok( !$array->isEmpty, 'array is not empty' )
    or diag( Dumper( [ $array->isEmpty ] ) );
};

########################################################################
subtest 'iterator' => sub {
########################################################################
  my $array = Bedrock::Array->new( 0 .. 9 );

  my $iterator = $array->iterator;

  my @new_array;

  while ( $iterator->valid() ) {
    push @new_array, $iterator->next();
  }

  is_deeply( $array, [@new_array] );

};

########################################################################
subtest 'json' => sub {
########################################################################
  my $array = Bedrock::Array->new( 0 .. 9 );

  my $json = $array->json;

  ok( $json, 'returned a json string' );

  diag( Dumper( [ $json, length $json ] ) );

  like( $json, qr/\[.*\]/xsm, 'looks like JSON array' );

  require JSON::PP;

  is_deeply(
    $array,
    eval { JSON::PP->new->decode($json) },
    'is a JSON string'
  ) or diag( Dumper( [ $json, $EVAL_ERROR ] ) );
};

########################################################################
subtest 'length' => sub {
########################################################################
  my $array = Bedrock::Array->new( 0 .. 9 );

  is( $array->length(),    10, 'array length is 10' );
  is( $array->new->length, 0,  '0 length array' );
};

########################################################################
subtest 'list' => sub {
########################################################################
  my $array = Bedrock::Array->new( 0 .. 9 );
  my @list  = $array->list();

  is( @list, 10, 'list of 10 items' );

  is_deeply( [ $array->list ], [ 0 .. 9 ], 'lists == array' )
    or diag( Dumper( [ $array->list ] ) );

};

########################################################################
subtest 'map' => sub {
########################################################################
  my $array = Bedrock::Array->new( 0 .. 4 );

  $array = $array->map('%02d');

  is_deeply( $array, join q{}, map { sprintf '%02d', $_ } 0 .. 4 );

};

########################################################################
subtest 'matches' => sub {
########################################################################
  my $array = Bedrock::Array->new(qw{ Bill William billy Bobbly Wilhelm });

  my $matches = $array->matches( '^w', 'i' );
  is_deeply( $matches, [qw{ William Wilhelm }] );

  $matches = eval { $array->matches( '^w', 'zf' ); };
  ok( $EVAL_ERROR && $EVAL_ERROR =~ /invalid\sflags/xsm, 'invalid flag' );

  $matches = $array->matches( '[ie]l', 'g' );
  is( @{$matches}, 5, '5 matches' );
  is_deeply( $matches, [qw{il il il il el}], 'correct matches' );

  $array->push("Zelda\nMelba");
  $matches = $array->matches('Melba');
  is( @{$matches}, 1, 'one match of Melba' );

  $matches = $array->matches('^Melba');
  is( @{$matches}, 0, 'no match of Melba' );

  $matches = $array->matches( '^Melba', q{m} );
  is( @{$matches}, 1, 'one match of ^Melba w/flags' );
};

########################################################################
subtest 'recordset' => sub {
########################################################################

  my @records = (
    { foo => 'bar',
      id  => 1,
    },
    { foo => 'buz',
      id  => 2,
    },
    { foo => 'baz',
      id  => 3,
    },
    { foo => 'biz',
      id  => 4,
    },
  );

  my $array = Bedrock::Array->new(@records);
  $array->recordset;
  isa_ok( $array, 'Bedrock::RecordSet' );

  $array = Bedrock::Array->new( @records, 0 );

  eval { $array->recordset; };

  ok( $EVAL_ERROR && $EVAL_ERROR =~ /invalid\selement\stype/xsm,
    'invalid element' );

  eval { Bedrock::Array->new( {}, @records )->recordset; };

  my $error = 'elements\sof\srecordsets\sshould\shave\skeys';
  ok( $EVAL_ERROR && $EVAL_ERROR =~ /\A$error/xsm, 'no keys' )
    or diag( Dumper( [$EVAL_ERROR] ) );

  eval { Bedrock::Array->new( { foo => 15 }, @records )->recordset; };

  ok( $EVAL_ERROR && $EVAL_ERROR =~ /is\snot\sa\svalid\srecord/xsm,
    'invalid record' )
    or diag( Dumper( [$EVAL_ERROR] ) );

  $array = Bedrock::Array->new(@records)->recordset;

  my $new_recordset = $array->sort( 'id', 'desc', 'num' );
  isa_ok( $new_recordset, 'Bedrock::RecordSet' );

  is_deeply(
    [ map { $_->{id} } @{$new_recordset} ],
    [ reverse 1 .. 4 ],
    'sort a recordset'
  );

  is_deeply(
    [ map { $_->{id} } @{ $new_recordset->sort( 'id', 'asc', 'num' ) } ],
    [ 1 .. 4 ],
    'sort ascending'
  );

  @records = (
    { lname => 'Smith',
      fname => 'Bob',
    },
    { lname => 'Smith',
      fname => 'Robert',
    },
    { lname => 'Anderson',
      fname => 'Frank',
    },
  );

  $array = Bedrock::Array->new(@records)->recordset;

  my $sorted_array
    = $array->sort( 'lname', 'asc', 'alpha', 'fname', 'desc', 'alpha' );

  is_deeply(
    [ map { $_->{lname} } @{$sorted_array} ],
    [qw{ Anderson Smith Smith}],
    'two field sort ascending/descending'
  ) or diag( Dumper( [$array] ) );

  is_deeply( [ map { $_->{fname} } @{$sorted_array} ],
    [qw{ Frank Robert Bob}], 'two field sort ascending/descending' )
    or diag( Dumper( [$array] ) );

  is_deeply( [ map { $_->{lname} } @{ $array->sort('lname') } ],
    [qw{ Anderson Smith Smith}], 'default' )
    or diag( Dumper( [$array] ) );

};

########################################################################
subtest 'reverse' => sub {
########################################################################
  my $array = Bedrock::Array->new( 0 .. 9 );

  is_deeply( $array->reverse, [ reverse 0 .. 9 ] );

};

########################################################################
subtest 'set' => sub {
########################################################################
  my $array = Bedrock::Array->new( 0 .. 9 );

  my $old = $array->set( 0, 1 );

  is( $array->[0], 1, 'set first element to 1' );

  is( $old, 0, 'returns previous value' );

  eval { $array->set( 'foo', 'bar' ); };

  ok( $EVAL_ERROR && $EVAL_ERROR =~ /index\smust\sbe\sinteger/xsm,
    'index must be integer' );
};

########################################################################
subtest 'xml' => sub {
########################################################################
  my $array = Bedrock::Array->new( 0 .. 9 );

  my $xml = $array->xml( RootName => 'range', XMLDecl => 1 );

  like( $xml, qr/\A<[?]xml.*>\n\z/xsm, 'looks like xml' );
};

########################################################################
subtest 'dumper' => sub {
########################################################################
  my $array = Bedrock::Array->new( 0 .. 9 );

  ok(1);

  diag( $array->regular() );
  diag( $array->compact() );
};

1;

__END__

=begin

[x] bedrock_xml
[x] devolve
[x] get
[x] grep
[x] isEmpty
[x] iterator
[x] join
[x] json
[x] length
[x] list
[x] map
[x] matches
[x] new
[x] pop
[x] push
[ ] recordset
[x] reverse
[x] set
[x] shift
[x] sort
[x] splice
[x] unshift
[x] xml

=end
