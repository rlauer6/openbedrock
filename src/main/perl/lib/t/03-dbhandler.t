#!/usr/bin/env perl

## no critic (RequireVersionVar, RequirePodSections)

use strict;
use warnings;

BEGIN {
  use lib qw(.);
}

use DBI;
use Data::Dumper;
use English qw(-no_match_vars);
use Test::More;
use Time::HiRes;

use Readonly;

Readonly my $TRUE  => 1;
Readonly my $FALSE => 0;

use Bedrock::Test::Utils qw(connect_db create_db);

my $dbi = eval { connect_db() };

if ( !$dbi ) {
  plan skip_all => 'no database connection';
}

use_ok('BLM::DBHandler');

eval { create_db($dbi); };

if ($EVAL_ERROR) {
  BAIL_OUT("could not create database and table for test: $EVAL_ERROR\n");
}

{
  no warnings 'once';  ## no critic (ProhibitNoWarnings)

  $BLM::DBHandler::BENCHMARK = 1;
}

my $dbh = BLM::DBHandler->new($dbi);

my $query = <<'SQL';
insert into foo
   (id, name, foo, bar_phone)
 values
   (?,?,?,?)
SQL

my $test_bm;

########################################################################
subtest 'unlimited history' => sub {
########################################################################
  $dbh->set_max_history(5);

  $test_bm = $dbh->benchmark( start => $PROGRAM_NAME );

  my $history_count = 0;

  ++$history_count;
  $dbh->do( $query, 0, 'Rob', 'foo', q{} );

  ++$history_count;
  $dbh->select('select count(1) as foo_count from foo');

  ++$history_count;
  $dbh->prepare('describe foo');
  $dbh->execute;

  ++$history_count;
  $dbh->select_list('select * from (select * from foo) as t');

  my $bm = $dbh->benchmark( start => 'multiple inserts', arg_list => [ 0, 'Rob', 'foo', q{} ] );

  {
    ++$history_count;

    no warnings 'once';  ## no critic (ProhibitNoWarnings)
    local $BLM::DBHandler::BENCHMARK = 0;
    local $BLM::DBHandler::HISTORY   = 0;

    for ( 0 .. 99 ) {
      $dbh->do( $query, 0, 'Rob', 'foo', q{} );
    }
  }

  $dbh->benchmark( end => $bm );

  ++$history_count;
  $dbh->benchmark( end => $test_bm );

  ++$history_count;
  $dbh->select('select count(1) as foo_count from foo');

  my $history = $dbh->history;
  is( @{$history}, $history_count, 'history count' );

  ok( $history_count == scalar $dbh->format_history( format => 'csv' ), 'csv history' );

  #print {*STDERR} $dbh->format_history( format => 'dumper' );
  #print {*STDERR} $dbh->format_history( format => 'json',  options => { pretty => 1 } );
  print {*STDERR} $dbh->format_history( format => 'table', options => { format => '6.4f' } );
  #print {*STDERR} join "\n", $dbh->format_history( format => 'csv' );

  $dbh->flush_history;

  ok( !@{ $dbh->history }, 'flush history' );
};
done_testing;

exit;

########################################################################
subtest 'limit history' => sub {
########################################################################
  no warnings 'once';  ## no critic (ProhibitNoWarnings)

  $dbh->reset_max_history();

  local $BLM::DBHandler::MAX_HISTORY = 2;

  for ( 0 .. 4 ) {
    $dbh->do( $query, 0, 'Rob', 'foo', q{} );
  }

  ok( @{ $dbh->history } == 2, 'history limit 2' )
    or diag(
    Dumper(
      [ history => $dbh->max_history,
        count   => scalar @{ $dbh->history },
      ]
    )
    );
};

########################################################################
subtest 'history off' => sub {
########################################################################
  $dbh->flush_history;

  no warnings 'once';  ## no critic (ProhibitNoWarnings)

  local $BLM::DBHandler::HISTORY = 0;

  for ( 0 .. 4 ) {
    $dbh->do( $query, 0, 'Rob', 'foo', q{} );
  }

  ok( @{ $dbh->history } == 0, 'history off' );
};

done_testing;

END {

  eval {
    if ( $dbi && $dbi->ping ) {
      $dbi->do('drop database foo');
    }
  };
}

1;

__END__
