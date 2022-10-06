use strict;
use warnings;

use Test::More tests => 4;

use Data::Dumper;
use English qw{-no_match_vars};

BEGIN {
  use_ok('Bedrock::Model::ReservedWords::MySQL');
}

my $reserved_words
  = eval { return Bedrock::Model::ReservedWords::MySQL->new(); };

isa_ok( $reserved_words, 'Bedrock::Model::ReservedWords::MySQL' )
  or do {
  diag($EVAL_ERROR);

  BAIL_OUT(
    "could not create an object of Bedrock::Model::ReservedWords::MySQL\n");
  };

isa_ok( $reserved_words->get_reserved_words, 'HASH' );

########################################################################
subtest 'is_reserved' => sub {
########################################################################
  foreach (qw/select group order distinct limit/) {
    ok( $reserved_words->is_reserved($_), " $_ reserved?" );
  }
};

1;

__END__
