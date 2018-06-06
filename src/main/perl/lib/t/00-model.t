use strict;
use warnings;

use Test::More tests => 1;

use DBI;
use Data::Dumper;

BEGIN {
  use_ok('Bedrock::Model::Handler');
}
