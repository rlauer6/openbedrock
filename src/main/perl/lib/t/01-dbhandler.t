## no critic (RequireVersionVar, RequirePodSections)

use strict;
use warnings;

use Test::More tests => 13;

use DBI;
use Data::Dumper;
use English qw{-no_match_vars};
use List::Util qw{none};
use Readonly;

Readonly my $TRUE  => 1;
Readonly my $FALSE => 0;

BEGIN {
  use_ok('BLM::DBHandler');
}

require 't/db-setup.pl';

my $dbi = eval { connect_db() };

if ($dbi) {
  eval { create_db($dbi); };
}

if ( !$dbi || $EVAL_ERROR ) {
  BAIL_OUT("could not create database and table for test: $EVAL_ERROR\n");
}

########################################################################
subtest 'new' => sub {
########################################################################
  my $dbh = BLM::DBHandler->new($dbi);

  isa_ok( $dbh, 'BLM::DBHandler', 'new - no options' );

  $dbh = BLM::DBHandler->new( $dbi, max_rows => 0 );

  isa_ok( $dbh, 'BLM::DBHandler', 'new - max_rows' );

  $dbh = eval { return BLM::DBHandler->new( {} ); };

  ok( !$dbh && $EVAL_ERROR, '->new(HASH)' );

  $dbh = eval { return BLM::DBHandler->new( {} ); };

  ok( !$dbh && $EVAL_ERROR, '->new(SCALAR)' );
};

########################################################################
subtest 'dbi' => sub {
########################################################################
  my $dbh = BLM::DBHandler->new( $dbi, max_rows => 0 );

  my $dbi = $dbh->dbi();

  isa_ok( $dbi,            'DBI::db', 'dbi' );
  isa_ok( $dbh->get_dbi(), 'DBI::db', 'get_dbi' );

  eval { $dbh->dbi('bad'); };

  ok( $EVAL_ERROR, '->dbi(SCALAR)' );

  eval { $dbh->dbi( {} ); };

  ok( $EVAL_ERROR, '->dbi(HASH)' );

  eval { $dbh->dbi($dbi); };

  ok( !$EVAL_ERROR, '->dbi(DBI::db)' );

};

########################################################################
subtest 'errstr' => sub {
########################################################################
  my $dbh = BLM::DBHandler->new( $dbi, max_rows => 0, max_history => 2 );

  local $dbi->{RaiseError} = $FALSE;

  my $result
    = eval { $dbh->select('select count(*) as foo_count from boo'); };

  ok( !$result,      'SQL error' );
  ok( $dbh->get_err, 'error string set' );
  like(
    $dbh->get_err,
    qr/^MySQL\s+error\s+[(]\d+[)]:\s+.*/xsm,
    'formatted error'
  ) or diag( Dumper( [ $dbh->get_err ] ) );

  diag( Dumper( [ $dbh->get_err, $EVAL_ERROR, $dbi->{mysql_errno} ] ) );

  $dbh->select('select curtime()');
  ok( !$dbh->get_err, 'no error string' );

};

########################################################################
subtest 'do' => sub {
########################################################################
  my $dbh = BLM::DBHandler->new($dbi);

  my $query = <<'SQL';
insert into foo
   (id, name, foo, bar_phone)
 values
   (?,?,?,?)
SQL

  my $rv = $dbh->do( $query, 0, 'Rob', 'foo', q{} );

  ok( !$rv && $dbh->rows() == 1, 'inserted 1 row' )
    or diag( Dumper( [ $rv, $dbh->get_err, $dbi->{mysql_errno} ] ) );

  {
    local $dbi->{RaiseError} = $FALSE;

    my $rv = $dbh->do('delete from boo');
    ok( $rv && $rv == $dbi->{mysql_errno}, 'do returns error code' );

    diag( Dumper( [ $rv, $dbh->get_err ] ) );
  }

};

########################################################################
subtest 'select' => sub {
########################################################################
  my $dbh = BLM::DBHandler->new($dbi);

  my $result = $dbh->select('select count(*) as foo_count from foo');

  ok( $result, 'select returns a result' );

  my $result2 = $dbh->Select('select count(*) as foo_count from foo');
  ok( $result2, 'Select returns a result' );

  is_deeply( $result, $result2, 'Select == select' );

  isa_ok( $result, 'HASH' );

  ok( ref $result eq 'Bedrock::Hash', 'returns a Bedrock object' );

  $dbh->set_return_bedrock_refs($FALSE);

  $result = $dbh->select('select count(*) as foo_count from foo');
  ok( ref $result ne 'Bedrock::Hash', 'returns a Perl object' );

};

########################################################################
subtest 'select_list' => sub {
########################################################################
  my $dbh = BLM::DBHandler->new($dbi);

  my $result = $dbh->select_list('select * from foo');

  ok( $result, 'select_list returns a result' );

  my $result2 = $dbh->SelectList('select * from foo');

  ok( $result2, 'Select_list returns a result' );
  is_deeply( $result, $result2, 'SelectList == select_list' );

  isa_ok( $result, 'ARRAY' );

  ok(
    ref $result eq 'Bedrock::Array::Reference',
    'returns a Bedrock::Array object'
  );
  ok(
    ref $result->[0] eq 'Bedrock::Hash',
    'returns array of Bedrock::Hash objects'
  );

  $dbh->set_return_bedrock_refs($FALSE);

  $result = $dbh->select_list('select * from foo');

  ok( ref $result ne 'Bedrock::Array',     'returns a Perl array' );
  ok( ref $result->[0] ne 'Bedrock::Hash', 'returns array of hashes' );

  is_deeply(
    [ sort keys %{ $result->[0] } ],
    [ sort qw{ id name foo bar_phone} ],
    'returns all columns'
  );
};

########################################################################
subtest 'max_rows' => sub {
########################################################################
  my $dbh = BLM::DBHandler->new($dbi);

  my $max_rows = $dbh->max_rows();
  is( $max_rows, 100, 'default max_rows = 100' );

  is( $dbh->get_max_rows, 100, 'get_max_rows() == max_rows()' );

  my $query = <<'SQL';
insert into foo
   (id, name, foo, bar_phone)
 values
   (?,?,?,?)
SQL

  for ( 0 .. 199 ) {
    $dbh->do( $query, 0, 'Rob', 'foo', q{} );
  }

  my $result    = $dbh->select('select count(1) as foo_count from foo');
  my $foo_count = $result->{foo_count};

  ok( $foo_count > $dbh->max_rows(), 'number of record > default max_rows' );

  $result = $dbh->select_list('select * from foo');
  ok( $result, 'got result' );
  isa_ok( $result, 'ARRAY' );
  is( @{$result}, 100, 'max_row default == 100' );

  $dbh->max_rows(10);

  $result = $dbh->select_list('select * from foo');
  ok( $result, 'got result' );
  isa_ok( $result, 'ARRAY' );
  is( @{$result}, 10, 'max_row(10) == 10' );

  $dbh->max_rows(0);

  $result = $dbh->select_list('select * from foo');
  ok( $result, 'got result' );
  isa_ok( $result, 'ARRAY' );
  is( @{$result}, $foo_count, 'max_row(10) == ' . $foo_count );
};

########################################################################
subtest 'get_query' => sub {
########################################################################
  my $dbh = BLM::DBHandler->new( $dbi, max_rows => 0, max_history => 2 );

  my $result = $dbh->select('select count(*) as foo_count from foo');
  ok( $result, 'select' );

  #  diag( Dumper( [ $result, $dbh->get_query, $dbh->get__query ] ) );

  $result = $dbh->select('select now()');
  #  diag( Dumper( [ $result, $dbh->get_query, $dbh->get__query ] ) );

  $result = $dbh->select('select curdate()');
  #  diag( Dumper( [ $result, $dbh->get_query, $dbh->get__query ] ) );

  $result = $dbh->select('select curtime()');
  #  diag( Dumper( [ $result, $dbh->get_query, $dbh->get__query ] ) );
};

########################################################################
subtest 'date_format' => sub {
########################################################################
  my $dbh = BLM::DBHandler->new($dbi);

  my $date = eval { $dbh->date_format('foo'); };

  ok( !$date && $EVAL_ERROR =~ /not\sa\svalid\sdate/xsm, 'invalid date' )
    or diag( Dumper( [ $date, $EVAL_ERROR ] ) );

  $date = $dbh->date_format('2022-09-20');

  ok( $date, 'returned a value' );

  $date = $dbh->date_format();

  like(
    $date,
    qr/^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z$/xsm,
    'ISO 8601 format'
  ) or diag( Dumper( [$date] ) );

  $date = $dbh->date_format( undef, '%a %b %e %H:%i:%S %Y', -4 );
  my $perl_date = scalar localtime time;

  while ( $perl_date =~ s/\s\s/ /xsmg ) { };  # remove multiple whitespace

  ok( $date eq $perl_date, 'localtime formatted correctly' )
    or
    diag( Dumper( [ $dbh->get_args, $dbh->get_query, $date, $perl_date ] ) );
};

########################################################################
subtest 'get_bind_args/bind_vars' => sub {
########################################################################
  my $dbh = BLM::DBHandler->new($dbi);

  my @bind_args = ( 0, 'r%' );

  my $query = <<'SQL';
select *
  from foo
  where id > ? and name like ?
SQL

  my $result = $dbh->select( $query, @bind_args );

  ok( $result, 'got result using bind vars with select' );

  my $args = $dbh->get_args;
  isa_ok( $dbh->get_args, 'ARRAY' );

  my @bind_vars = $dbh->bind_vars;

  ok( @{$args} == @bind_vars,
    'get_args, bind_vars return arrays of same length' )
    or diag( $args, $dbh->bind_vars );

  is_deeply( $args, \@bind_vars, 'get_args, bind_vars return same object' );

  is_deeply( $args, \@bind_args, q{get_args == (0, '%r')} )
    or diag( Dumper( [ $args, \@bind_args ] ) );

  $query = <<'SQL';
select * from foo where id = ?
SQL

  $result = $dbh->select_list( $query, 1 );

  is( $dbh->get_args->[0], 1, 'get_args - select_list' );

  $dbh->do( 'delete from foo where name like ? and id > ?', '%r', 0 );

  is( $dbh->get_args->[0], '%r', 'get_args - do' );

  ok( $dbh->arg_list );

  ok( $dbh->get_arg_list );

  is( $dbh->get_arg_list, '%r|0', 'formatter arg list' );

  diag( Dumper( [ $dbh->arg_list ] ) );
};

########################################################################
subtest 'query/get_query' => sub {
########################################################################
  my $dbh = BLM::DBHandler->new($dbi);
  my @history;

  my $query = <<'SQL';
select now()
SQL

  push @history, $query;

  $dbh->select($query);
  is( $dbh->query, $query, 'query()' );

  $query = <<'SQL';
select curtime()
SQL

  push @history, $query;
  $dbh->select($query);
  is( $dbh->query, $query, '2nd query()' );

  is( $dbh->get_query, $query, 'get_query()' );

  is_deeply( [ reverse @history ], $dbh->get__query, 'query history' )
    or diag( Dumper( [ \@history, $dbh->get__query ] ) );

};

########################################################################
subtest 'commit/rollback' => sub {
########################################################################
  my $dbh = BLM::DBHandler->new($dbi);

  local $dbi->{AutoCommit} = $FALSE;

  my $result = $dbh->select('select count(*) foo_count from foo');
  ok( $result->{foo_count} > 0, 'foo has records' );

  $dbh->do('delete from foo');
  $result = $dbh->select('select count(*) foo_count from foo');

  is( $result->{foo_count}, 0, 'deleted all records' );
  $dbh->rollback;

  $result = $dbh->select('select count(*) foo_count from foo');
  ok( $result->{foo_count} > 0, 'rollback successful' );

  $dbh->do('delete from foo');
  $dbh->commit;

  $result = $dbh->select('select count(*) foo_count from foo');
  is( $result->{foo_count}, 0, 'commit successful' );
};

END {
  eval {
    if ( $dbi && $dbi->ping ) {
      $dbi->do('drop database foo');
    }
  };
}

1;

__END__
