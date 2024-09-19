use strict;
use warnings;

use Test::More tests => 2;

BEGIN {
  use Bedrock;
  use File::Basename qw(dirname basename);

  my $path = dirname( $INC{'Bedrock.pm'} );
  push @INC, "$path/Bedrock", "$path/Bedrock/Text";
}

use_ok(qw{TagX::TAG::WithBody::If});

ok( TagX::TAG::WithBody::If::file_test( '-e', 'Makefile' ), 'file test' );

1;

__END__

