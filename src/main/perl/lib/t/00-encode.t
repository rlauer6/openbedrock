#!/usr/bin/env perl

use strict;
use warnings;

use lib qw{.};

use Bedrock::Constants qw{:chars};
use Data::Dumper;
use English qw{-no_match_vars};
use Test::More;
use Test::Utils qw{:all};

our %TESTS = fetch_test_descriptions(*DATA);

########################################################################

plan tests => 1 + keys %TESTS;

use Bedrock;

use_ok('Text::URLEncode');

Text::URLEncode->import(qw{:all});

########################################################################
subtest 'htmlencode/Htmlencode' => sub {
########################################################################
  my $str = q{<>`'"&};

  htmlencode($str);

  is( $str, '&lt;&gt;&#96;&#39;&quot;&amp;', 'string htmlencoded' )
    or diag( Dumper( [$str] ) );

  $str = q{<>`'"&};

  my $encode_str = Htmlencode($str);

  is( $encode_str, '&lt;&gt;&#96;&#39;&quot;&amp;', 'string htmlencoded' );
  is( $str,        q{<>`'"&},                       'string not modified' );

  use HTML::Entities;

  $str = q{<>`'"&};

  is(
    Htmlencode($str),
    encode_entities( $str, $str ),
    'encoded like HTML::Entities'
    )
    or diag(
    Dumper( [ $str, Htmlencode($str), encode_entities( $str, $str ) ] ) );

};

subtest 'encode' => sub {
  use URI::Encode;

  my $str = q{;/?:@&=+$,<>#%"\{\}|^[]`};

  my $uri = URI::Encode->new( { encode_reserved => 1 } );

  is( uc Encode($str), $uri->encode($str), 'encode like URI::Encode' );

  is( $str, q{;/?:@&=+$,<>#%"\{\}|^[]`}, 'string not modified' );

  my $encoded_str = $uri->encode($str);

  encode($str);
  is( uc $str, $encoded_str, 'string encoded' );

};

1;

__DATA__
htmlencode => htmlencode a string
encode => uri encode
END_OF_PLAN  
