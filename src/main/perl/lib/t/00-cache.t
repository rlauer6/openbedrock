use strict;
use warnings;

use Cwd qw{abs_path};
use Data::Dumper;

use IPC::Shareable;

use Test::More tests => 2;

BEGIN {
  # create the cache

  my %X;

  tie %X, 'IPC::Shareable',  ## no critic (ProhibitTies)
    {
    key     => 'BCFG',
    create  => 1,
    destroy => 1,
    size    => 256 * 1024
    };

  $ENV{BEDROCK_CACHE_CONFIG} = 'on';

  eval 'use Bedrock::Handler;';
}

require 't/faux-handler.pl';

my $log = q{};

my $request_handler = faux_request_handler( \$log );

my $config_path = abs_path '../../../main/bedrock/config';

local $ENV{BEDROCK_CONFIG_PATH} = $config_path;

my $handler = Bedrock::Handler->new($request_handler);
isa_ok( $handler, 'Bedrock::Handler' );

my %FOO;
tie %FOO, 'IPC::Shareable', { key => 'BCFG', create => 0 };  ## no critic (ProhibitTies)

ok( keys %FOO, 'caching' );

1;

__END__
