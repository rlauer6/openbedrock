use strict;
use warnings;

use Test::More tests => 2;

use lib qw{ ./Bedrock/Text };

use_ok(qw{TagX::TAG::WithBody::If});

ok( TagX::TAG::WithBody::If::file_test( '-e', 'Makefile.am' ), 'file test' );

1;

__END__

