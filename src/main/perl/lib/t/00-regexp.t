#!/usr/bin/env perl

use strict;
use warnings;

use lib qw{.};

use Bedrock::Test::Utils qw{:all};

use Data::Dumper;
use English qw{-no_match_vars};
use Test::More;
use Log::Log4perl::Level;

use Scalar::Util qw{ reftype };

our %TESTS = fetch_test_descriptions(*DATA);

########################################################################

plan tests => 1 + keys %TESTS;

use_ok('Bedrock::RegExp');

Bedrock::RegExp->import(qw( regexp_compile regexp_capture_group));

my $logger = Bedrock::RegExp::get_logger();
$logger->level( $ENV{DEBUG} ? $TRACE : $ERROR );

########################################################################
subtest 'regexp_compile' => sub {
########################################################################

  my $str = 'qr/thisnot\sis\sa\stest/xsmi';

  my $regexp = eval { regexp_compile($str); };

  isa_ok( $regexp, 'REGEXP' )
    or do {
    diag( Dumper( [ $str, $regexp, reftype($regexp), $EVAL_ERROR ] ) );
    BAIL_OUT('could not compile regexp');
    };

  $str = 'foo';

  $regexp = eval { regexp_compile($str); };

  is( $regexp, $str, 'not a regular expression to compile' );

  ok( $str =~ $regexp, 'but still matches' );

  $str = 'qr/foo//';

  $regexp = eval { regexp_compile($str); };

  ok( $EVAL_ERROR, 'bad regular expression' )
    or diag(
    Dumper( [ regexp_compile($str), $str, reftype($str), $EVAL_ERROR ] ) );
};

########################################################################
subtest 'regexp_capture_group' => sub {
########################################################################
  my $str = 'qr/this\sis\sa\stest/xsmi';

  my $regexp = eval { regexp_compile($str); };

  isa_ok( $regexp, 'REGEXP' )
    or do {
    diag( Dumper( [ $str, $regexp, reftype($regexp), $EVAL_ERROR ] ) );
    BAIL_OUT('could not compile regexp');
    };

  'this is a test' =~ $regexp;

  my $capture_groups = regexp_capture_group();
  isa_ok( $capture_groups, 'HASH' );

  ok( !keys %{$capture_groups}, 'no capture groups' )
    or diag( Dumper( [ $capture_groups, $regexp, $str ] ) );

  $str = 'qr/(is).*(?<foo>test)/xsmi';

  $regexp = regexp_compile($str);

  isa_ok( $regexp, 'REGEXP' );

  'this is a test' =~ $regexp;

  $capture_groups = regexp_capture_group();

  isa_ok( $capture_groups, 'HASH' );

  is( keys %{$capture_groups}, 3, '3 capture groups' )
    or diag( Dumper( [ $capture_groups, $regexp, $str ] ) );

  is( $capture_groups->{'_1'}, 'is' );

  is( $capture_groups->{'_2'}, 'test' );

  is( $capture_groups->{'foo'}, 'test' );
};

########################################################################
subtest 'regexp_evaluate_group' => sub {
########################################################################
  my $regexp = 'qr/(?<foo>[ia]s)/xsmi';

  my $str = 'this is a test of a regexp that has a bunch of captured groups';

  my %capture_group = regexp_evaluate( $str, $regexp, 1 );
  is( keys %capture_group, 2, '2 capture groups' );

  ok( $capture_group{'_1'}, '_1 exists in capture group' );

  isa_ok( $capture_group{'_1'}, 'ARRAY' )
    or diag( Dumper( \%capture_group ) );

  is( @{ $capture_group{'_1'} }, 3, '3 matches found' );

  is( scalar( grep { $_ =~ /[ia]s/xsm } @{ $capture_group{'_1'} } ),
    3, '3 matched [ia]s' );

  ok( $capture_group{foo}, 'foo exists in capture group' );

  isa_ok( $capture_group{foo}, 'ARRAY' );

  is( @{ $capture_group{foo} }, 3, '3 matches found' );

  is( scalar( grep { $_ =~ /[ia]s/xsm } @{ $capture_group{foo} } ),
    3, '3 matched [ia]s' );
};

1;

__DATA__
regexp_compile => compile a regular expression
regexp_capture_group => return the capture groups
regexp_evaluate_group => compile and evaluate
  
END_OF_PLAN  
