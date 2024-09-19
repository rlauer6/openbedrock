use strict;
use warnings;

use Test::More;

use DBI;
use Data::Dumper;
use English qw{-no_match_vars};

########################################################################
use Bedrock::Test::Utils qw(connect_db create_db);

my $dbi = eval { return connect_db(); };

if ( $EVAL_ERROR || !$dbi ) {
  plan skip_all => 'no database connection';
}

eval { return create_db($dbi); };

BAIL_OUT('could not create database')
  if $EVAL_ERROR;

plan tests => 4;

use_ok('BLM::IndexedTableHandler')
  or BAIL_OUT($EVAL_ERROR);

########################################################################

my $ith;

########################################################################
subtest 'new' => sub {
########################################################################
  $ith = eval { return BLM::IndexedTableHandler->new( $dbi, 0, undef, 'foo' ); };

  isa_ok( $ith, 'BLM::IndexedTableHandler' )
    or BAIL_OUT($EVAL_ERROR);
};

########################################################################
subtest 'curtime' => sub {
########################################################################
  my $curtime = eval { $ith->curtime(); };

  ok( $curtime, 'curtime()' );
  like( $curtime, qr/\d{2}:\d{2}/xsm, 'looks like a time' );
};

########################################################################
subtest 'now' => sub {
########################################################################
  my $now = eval { $ith->now() };

  ok( $now, 'now' );

  like( $now, qr/^\d{4}-\d{2}-\d{2}\s\d{2}:\d{2}:\d{2}$/xsm, 'looks like data' ) or diag($now);
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
