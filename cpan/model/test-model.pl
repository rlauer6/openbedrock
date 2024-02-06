#!/usr/bin/perl

use strict;
use warnings;

use Data::Dumper;
use English                 qw(-no_match_vars);
use Bedrock::Model::Handler qw(easy_connect);
use Bedrock::Model;
use Bedrock::Model::Field qw(:all);

########################################################################
sub main {
########################################################################
  my $dbi = easy_connect();

  my @fields = eval {
    no warnings 'once';  ## no critic (ProhibitNoWarnings)

    local $Bedrock::Model::Field::RETURN_FIELDS = 1;

    return (
      id_field(),
      varchar_field( 'name',    32 ),
      varchar_field( 'address', 64 ),
      zip_field('zip'),
      enum_field( 'position', [ 'president', 'vice-president', 'cabinet', ] ),
      json_field('json'),
      date_inserted_field(),
      last_updated_field(),
    );
  };

  die "no fields: $EVAL_ERROR\n";

  my $model = Bedrock::Model->create(
    $dbi,
    model => \@fields,
    table => 'users'
  );

  return 0;
}

exit main();

1;
