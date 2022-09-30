use strict;
use warnings;

use Test::More tests => 2;

BEGIN {
  use_ok('BLM::DBHandler');
}

like( $BLM::DBHandler::VERSION, qr/\A[\d.]+\z/xsm, 'version' );

1;
