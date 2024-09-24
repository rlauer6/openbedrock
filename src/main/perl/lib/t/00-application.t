#!/usr/bin/perl

use strict;
use warnings;

use lib qw(.);

use Test::More;
use Scalar::Util qw(blessed reftype);
use Data::Dumper;

use_ok 'Bedrock::Application';

local @ARGV = qw(--foo --bar=biz --biz-buz=buz -f boo);

my $app = Bedrock::Application->new( option_specs => [qw(foo|F bar=s biz-buz=s baz-foo-bar|f=s)] );

my $options = $app->get_options;

ok( ref $app && blessed $app, 'is a blessed class' );

ok( ref $options && reftype($options) eq 'HASH', 'options is a hash' );

ok( $options->{foo}, 'foo' );

ok( $options->{bar} eq 'biz', 'biz' );

ok( $options->{biz_buz} eq 'buz', 'biz-buz' )
  or diag( Dumper( [ options => $options ] ) );

# getters
ok( eval { $app->get_foo }, 'get_foo' );
is( eval { $app->get_bar },         'biz', 'get_bar' );
is( eval { $app->get_biz_buz },     'buz', 'get_biz_buz' );
is( eval { $app->get_baz_foo_bar }, 'boo', 'get_baz_foo_bar' );

done_testing;

1;
