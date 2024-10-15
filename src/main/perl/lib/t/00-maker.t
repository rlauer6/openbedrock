#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Data::Dumper;
use lib qw(.);
use Carp;
use Carp::Always;
use Bedrock::Test::Utils qw(connect_db create_db);
use Bedrock::Model::Field qw(:all);
use Data::Dumper;
use DBI;
use English qw(-no_match_vars);
use List::Util qw(mesh pairs);

use Test::More;

my $dbi = eval { return connect_db(); };

if ( !$dbi ) {
  plan skip_all => 'no database connection';
}

eval {
  $dbi->do('create database foo');
  $dbi->do('use foo');
};

BAIL_OUT("could not create database 'foo': $EVAL_ERROR\n")
  if $EVAL_ERROR;

########################################################################
sub cmp_models {
########################################################################
  my ( $m1, $m2 ) = @_;

  eval {

    die "arrays are not same size\n"
      if @{$m1} != @{$m2};

    foreach my $p ( pairs mesh $m1, $m2 ) {
      my ( $f1, $f2 ) = @{$p};

      if ( $f1->{field} ne $f2->{field} ) {
        die "field names are not equal\n" . Dumper( [ $f1, $f2 ] );
      }

      next
        if $f1->{type} =~ /int/xsm && $f2->{type} =~ /int/xsm;

      if ( $f1->{type} ne $f2->{type} ) {
        die "types are not equal\n" . Dumper( $f1, $f2 );
      }
    }
  };

  if ($EVAL_ERROR) {
    diag($EVAL_ERROR);
    return;
  }

  return 1;
}

my @fields = (
  id            => { type => 'id' },
  fname         => 32,
  lname         => 32,
  email         => { type => 'email' },
  address1      => 32,
  address2      => 32,
  city          => 32,
  state         => { type => 'state' },
  zip           => { type => 'zip' },
  start_date    => { type => 'date' },
  end_date      => { type => 'date' },
  position      => [ 'president', 'vice-president', 'cabinet', ],
  json          => { type => 'json' },
  date_inserted => { type => 'date_inserted' },
  last_updated  => { type => 'last_updated' },
);

my $maker;
my $model;
my @model_fields;

subtest 'create table' => sub {
  use_ok('Bedrock::Model::Maker');

  $Bedrock::Model::Field::RETURN_FIELDS = 1;
  @model_fields                         = Bedrock::Model::Field::create_model_fields(@fields);

  $model = Bedrock::Model->new( model => \@model_fields );

  $maker = Bedrock::Model::Maker->new( model => $model );

  my $class_def = $maker->as_string('US::President');
  ok( $class_def,                                   'return a string' );
  ok( $class_def =~ /^package\s+US::President;/xsm, 'return a class definition' );

  $model->set_table('president');
  $model->set_dbi($dbi);
  $model->create_table();
};

subtest 'create handler' => sub {

  # create a handler class from an existing table
  $maker = Bedrock::Model::Maker->new( dbi => $dbi, table => 'president' );

  {
    no strict 'refs';  ## no critic (ProhibitProlonged ProhibitNoStrict)

    ${'Bedrock::Model::Handler::MODEL'} = $model;

    my $handler = Bedrock::Model::Handler->new( $dbi, { table => 'president' } );

    $handler->set(
      email => 'gwashington@potus.gov',
      fname => 'George',
      lname => 'Washington',
    );

    $handler->save();

    ok( $handler->get('id'), 'saved a record' );
  }

  my $handler = Bedrock::Model::Handler->create_table(
    $dbi,
    model => $model,
    table => 'past_president',
  );

  $handler->set(
    email => 'tjefferson@potus.gov',
    fname => 'Thomas',
    lname => 'Jefferson',
  );

  $handler->save();

  ok( $handler->get('id'), 'saved another record record' );

  {
    local $Bedrock::Model::Field::RETURN_FIELDS = 1;

    my $model = [ id_field(), varchar_field( 'name', 64 ), email_field() ];

    my $handler = Bedrock::Model::Handler->create_table(
      $dbi,
      table => 'foo',
      model => $model,
    );
  }
};

subtest 'create definition' => sub {
  my @model_def = $maker->create_model_def();

  ok( cmp_models( \@model_def, \@model_fields ), 'create model from table' );
};

done_testing;

END {
  eval { $dbi->do('drop database foo'); };
}

1;
