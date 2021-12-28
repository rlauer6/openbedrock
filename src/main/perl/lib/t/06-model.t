use strict;
use warnings;

use Test::More tests => 4;

use Data::Dumper;

BEGIN {
  use_ok('Bedrock::Model::ReservedWords::MySQL');
}

my $reserved_words = eval {
  Bedrock::Model::ReservedWords::MySQL->new();
};

diag($@);

isa_ok($reserved_words, 'Bedrock::Model::ReservedWords::MySQL') or
  BAIL_OUT("could not create an object of Bedrock::Model::ReservedWords::MySQL\n$@");

isa_ok($reserved_words->get_reserved_words, 'HASH');

subtest 'is_reserved' => sub {
  foreach (qw/select group order distinct limit/) {
    ok($reserved_words->is_reserved($_), " $_ reserved?");
  }
};

