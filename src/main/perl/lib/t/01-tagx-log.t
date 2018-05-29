use strict;
use warnings;

use Data::Dumper;
use Test::More tests => 5;
use File::Temp qw/:POSIX/;

BEGIN {
  use_ok('TagX::Log', 'start_logger', 'log_message');
}

sub slurp {
  my $tmpfile = shift;
  
  open (my $fh, "<$tmpfile") or die "could not open log file";
  
  my $text = eval {
    local $/;
    <$fh>;
  };

  close $fh;
  
  return $text;
}

my $tmpfile = tmpnam();
start_logger(LOG_FILE => $tmpfile);
ok(-e $tmpfile, 'create a log file');

my $max_size = -s $tmpfile; # current size of log file just opened...

log_message(undef, "the quick brown fox ate a chicken");

my $text = eval {
  slurp $tmpfile;
};

BAIL_OUT("could not read log file $tmpfile")
  unless $text;

like($text, qr/the quick brown fox ate a chicken/, 'logged a message');

start_logger(
	     LOG_FILE => $tmpfile,
	     LOG_MAXSIZE => -1 + $max_size
	    );

is(-s $tmpfile, $max_size, 'truncated');

start_logger(
	     LOG_FILE => $tmpfile,
	     LOG_FORMAT => '%c'
	    );

$text = eval {
  slurp $tmpfile
};

BAIL_OUT("could not read log file $tmpfile")
  unless $text;

like($text, qr/^\d{02}\/\d{02}\/\d{02} \d{02}:\d{02}:\d{02}/, 'logged with date');

END {
  eval { unlink $tmpfile };
}
