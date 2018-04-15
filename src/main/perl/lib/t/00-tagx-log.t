use strict;
use warnings;

use Data::Dumper;
use Test::More tests => 2;
use File::Temp qw/:POSIX/;

BEGIN {
  use_ok('TagX::Log', 'start_logger', 'log_message');
}

my $tmpfile = tmpnam();
start_logger(LOG_FILE => $tmpfile);
ok(-e $tmpfile);

END {
  eval { unlink $tmpfile };
}
