#!/usr/bin/perl

use strict;
use warnings;

use lib qw(.);

use Test::More;
use Scalar::Util qw(blessed reftype);
use Data::Dumper;

use_ok 'Bedrock::Application';

my $app = Bedrock::Application->new;
ok( ref $app && blessed $app, 'is a blessed class' );

local @ARGV = qw(--foo --bar=biz --biz-buz=buz);

my $options = $app->get_options( specs => [qw(foo bar=s biz-buz=s)] );

ok( ref $options && reftype($options) eq 'HASH' );

ok( $options->{foo}, 'foo' );

ok( $options->{bar} eq 'biz', 'biz' );

ok( $options->{biz_buz} eq 'buz', 'biz-buz' )
  or diag( Dumper( [ options => $options ] ) );

done_testing;

1;
