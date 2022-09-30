use strict;
use warnings;

use Test::More tests => 2;

BEGIN {
  use_ok('BLM::IndexedTableHandler');
}

like( $BLM::IndexedTableHandler::VERSION, qr/\A[\d.]+\z/xsm, 'version' );

1;
