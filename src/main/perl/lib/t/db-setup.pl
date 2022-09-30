#!/usr/bin/env perl ## no critic (RequireVersionVar)

use strict;
use warnings;

use DBI;
use English qw{-no_match_vars};

use Readonly;

Readonly my $TRUE  => 1;
Readonly my $FALSE => 0;

########################################################################
sub connect_db {
########################################################################
  my ( $user, $password, $host ) = @_;

  $user     = $user     || $ENV{DBI_USER} || 'root';
  $password = $password || $ENV{DBI_PASS} || undef;
  $host     = $host     || $ENV{DBI_HOST} || 'localhost';

  my $dbi = DBI->connect(
    sprintf( 'dbi:mysql:host=%s;', $host ),
    $user,
    $password,
    { PrintError => $FALSE,
      RaiseError => $TRUE,
      AutoCommit => $TRUE
    }
  );

  return $dbi;
}

########################################################################
sub create_db {
########################################################################
  my ($dbi) = shift;

  $dbi->do('create database foo');

  my $create_table = <<'SQL';
create table foo (
 id int auto_increment primary key,
 name varchar(100) not null default '',
 foo  varchar(100) not null,
 bar_phone varchar(10) not null default ''
)
SQL

  $dbi->do('use foo');

  return $dbi->do($create_table);
}

1;

__END__
