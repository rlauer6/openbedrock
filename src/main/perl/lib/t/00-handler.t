use strict;
use warnings;

use lib qw{ . };

use Bedrock;
use Apache::Request_cgi;

use Cwd qw{abs_path};
use Data::Dumper;
use English qw{-no_match_vars};
use IO::Scalar;

use Test::More tests => 4;

BEGIN {
  $ENV{LogLevel} = 'debug';

  use_ok('Bedrock::Handler');
}

require 't/faux-handler.pl';

my $log = q{};

# provides /dev/null logging
my $request_handler = faux_handler( \$log );

my $config_path = abs_path '../../../main/bedrock/config';

local $ENV{BEDROCK_CONFIG_PATH} = $config_path;
local $ENV{CONFIG_PATH}         = 'config';

my $handler = Bedrock::Handler->new($request_handler);

isa_ok( $handler, 'Bedrock::Handler' );

my $config = $handler->config;
isa_ok( $config, 'Bedrock::Config' );

diag( Dumper( [ $config->get_module_config('usersession') ] ) );

local $ENV{MOD_PERL} = 'mod_perl';

ok( $handler->is_mod_perl eq 'mod_perl', 'is_mod_perl' );

1;
