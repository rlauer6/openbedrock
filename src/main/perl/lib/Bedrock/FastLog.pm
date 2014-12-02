package Bedrock::FastLog;

# This is a source filter for some ad-hoc logging on demand.  The advantage
# of using the source filter is that logging carries no penalty in
# production: these are just comments.
#
# To use, add lines like this to your code:
    # log "var: ", Dumper($var);
# This gets converted to warnings, at least in this simple initial
# implementation.

use strict;
use warnings;

BEGIN {
  if ($ENV{BEDROCK_FASTLOG}) {
    require Filter::Simple;
    Filter::Simple::FILTER(
      sub {
        s/^\s+#\s*log\b(.*?)$/warn$1;/mg;
      }
    );
  }
}

1;
