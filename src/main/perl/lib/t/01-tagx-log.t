use strict;
use warnings;

use Data::Dumper;
use Test::More tests => 5;
use File::Temp qw/:POSIX/;
use Bedrock qw{slurp_file};

BEGIN {
  use_ok( 'TagX::Log', 'start_logger', 'log_message' );
}

my $tmpfile = tmpnam();
start_logger( LOG_FILE => $tmpfile );
ok( -e $tmpfile, 'create a log file' );

my $max_size = -s $tmpfile;  # current size of log file just opened...

log_message( undef, 'the quick brown fox ate a chicken' );

my $text = eval { slurp_file $tmpfile; };

if ( !$text ) {
  BAIL_OUT("could not read log file $tmpfile");
}

like( $text, qr/the quick brown fox ate a chicken/sm, 'logged a message' );

start_logger(
  LOG_FILE    => $tmpfile,
  LOG_MAXSIZE => -1 + $max_size
);

is( -s $tmpfile, $max_size, 'truncated' );

start_logger(
  LOG_FILE   => $tmpfile,
  LOG_FORMAT => '%c'
);

$text = eval { slurp_file $tmpfile };

if ( !$text ) {
  BAIL_OUT("could not read log file $tmpfile");
}

like(
  $text,
  qr/^\d{2}\/\d{2}\/\d{2}\s\d{2}:\d{2}:\d{2}/xsm,
  'logged with date'
);

END {
  eval { unlink $tmpfile };
}

1;

__END__
