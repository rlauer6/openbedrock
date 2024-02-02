#!/usr/bin/env perl

use strict;
use warnings;

########################################################################
package main;
########################################################################

use Test::More;

use DBI;
use Data::Dumper;
use English qw{-no_match_vars};

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

use_ok('BLM::IndexedTableHandler')
  or BAIL_OUT($EVAL_ERROR);

########################################################################
my $config = {
  tables => {
    foo => {
      set => { name => sub { return uc $_[2]; } },
      get => { name => sub { return lc $_[0]->{ $_[1] }; } },
    }
  }
};

my $ith = BLM::IndexedTableHandler->new( $dbi, 0, $config, 'foo' );

$ith->set( name => 'rob' );

is( $ith->{name}, 'ROB', 'set' );

is( $ith->get('name'), 'rob', 'get' );

my $foo_config = $config->{tables}->{foo};

my $bar_foo = bless $ith, 'Bar::Foo';
@Bar::Foo::ISA = qw(BLM::IndexedTableHandler);

no strict 'refs';  ## no critic

*{'Bar::Foo::set_uc'} = $foo_config->{set}->{name};
*{'Bar::Foo::get_lc'} = $foo_config->{get}->{name};

# by function name
$foo_config->{set}->{name} = 'set_uc';
$foo_config->{get}->{name} = 'get_lc';

$bar_foo->set( name => 'lauer' );

is( $bar_foo->{name}, 'LAUER', 'set_uc()' );

is( $bar_foo->get('name'), 'lauer', 'get_uc()' );

done_testing;

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
