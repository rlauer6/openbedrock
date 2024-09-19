use strict;
use warnings;

use Data::Dumper;
use Test::More tests => 2;
use File::Temp qw/:POSIX/;

BEGIN {
  use Bedrock;
  use File::Basename qw(dirname basename);

  my $path = dirname( $INC{'Bedrock.pm'} );
  push @INC, "$path/Bedrock", "$path/Bedrock/Text";

  use_ok( 'TagX::Log', 'start_logger', 'log_message' );
}

my $tmpfile = tmpnam();
start_logger( LOG_FILE => $tmpfile );
ok( -e $tmpfile );

END {
  eval { unlink $tmpfile };
}
