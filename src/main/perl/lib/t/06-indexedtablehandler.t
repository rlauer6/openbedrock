#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;

use DBI;
use Data::Dumper;
use English qw{-no_match_vars};

########################################################################
require 't/db-setup.pl';

my $dbi = eval {
  my $dbh = connect_db();

  create_db($dbh);

  return $dbh;
};

diag($EVAL_ERROR);

if ( $EVAL_ERROR || !$dbi ) {
  plan skip_all => 'could not create database';

  diag($EVAL_ERROR);
}
else {
  plan tests => 4;
}

use_ok('BLM::IndexedTableHandler')
  or BAIL_OUT($EVAL_ERROR);

########################################################################

my $ith;

########################################################################
subtest 'new' => sub {
########################################################################
  $ith
    = eval { return BLM::IndexedTableHandler->new( $dbi, 0, undef, 'foo' ); };

  isa_ok( $ith, 'BLM::IndexedTableHandler' )
    or BAIL_OUT($EVAL_ERROR);
};

my $table_definition;

########################################################################
subtest 'get_table_dir' => sub {
########################################################################

  $table_definition = $ith->get_table_dir();

  isa_ok( $table_definition, 'HASH' )
    or diag( Dumper( [$table_definition] ) );
};

########################################################################
subtest 'get_enum_values' => sub {
########################################################################
  my ($field) = grep { $table_definition->{$_}->{Type} =~ /^enum/xsm }
    keys %{$table_definition};

  if ( !$field ) {
    diag( Dumper( [$table_definition] ) );
  }

  SKIP: {
    skip 'no enum field', 1 if !$field;

    my $enum_values = eval { $ith->get_enum_values($field); };

    isa_ok( $enum_values, 'ARRAY' )
      or diag( Dumper( [ $field, $enum_values, $EVAL_ERROR ] ) );

    my $enum_def = $table_definition->{$field}->{Type};

    my @values;

    if ( $enum_def =~ /\Aenum(.*)\z/xsm ) {
      @values = sort eval $1;
    }

    is_deeply( [ sort @{$enum_values} ], \@values, 'enum set matches' )
      or diag( Dumper( [ $enum_def, $enum_values, \@values ] ) );
  }

};

END {
  eval {
    if ( $dbi && $dbi->ping ) {
      $dbi->do('drop database foo');
      $dbi->disconnect;
    }
  };
}

1;

__END__
