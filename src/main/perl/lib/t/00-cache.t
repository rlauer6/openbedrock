use strict;
use warnings;

use Cwd qw{abs_path};
use Data::Dumper;
use English qw{-no_match_vars};
use IO::Scalar;
use IPC::Shareable;

use Test::More tests => 2;

BEGIN {
  # create the cache

  my %X;

  tie %X, 'IPC::Shareable',
    {
    key     => 'BCFG',
    create  => 1,
    destroy => 1,
    size    => 256 * 1024
    };

  $ENV{BEDROCK_CACHE_CONFIG} = 'on';

  eval 'use Bedrock::Handler;';
}

my $request_handler = bless {}, 'Faux::Handler';
my $log = q{};

{
  no strict 'refs';

  my $logger_fh = IO::Scalar->new( \$log );

  foreach my $m (qw{ error debug warn fatal info }) {
    *{ 'Faux::Logger::' . $m } = sub {
      print ${logger_fh} @_, "\n";
    };
  }

  *{'Faux::Handler::log'} = sub {
    return bless {}, 'Faux::Logger';
  };

  *{'Faux::Handler::filename'} = sub {
    return $PROGRAM_NAME;
  };

  *{'Faux::Handler::uri'} = sub {
    return q{/};
  };

  *{'Faux::Handler::content_type'} = sub {
    return 'text/html';
  };
}

my $config_path = abs_path '../../../main/bedrock/config';

local $ENV{BEDROCK_CONFIG_PATH} = $config_path;

my $handler = Bedrock::Handler->new($request_handler);
isa_ok( $handler, 'Bedrock::Handler' );

my %FOO;
tie %FOO, 'IPC::Shareable', { key => 'BCFG', create => 0 };

diag( Dumper( \%FOO ) );

ok( keys %FOO, 'caching' );
