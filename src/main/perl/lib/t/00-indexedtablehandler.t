use strict;
use warnings;

use English qw(-no_match_vars);
use Test::More tests => 2;

BEGIN {
  use lib q(.);

  use_ok('BLM::IndexedTableHandler');
}

like( $BLM::IndexedTableHandler::VERSION, qr/\A[\d.]+\z/xsm, 'version' );

1;
