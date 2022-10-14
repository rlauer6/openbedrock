#!/usr/bin/env perl ## no critic (RequireVersionVar)

use strict;
use warnings;

use DBI;
use English qw{-no_match_vars};
use Data::Dumper;

use Readonly;

Readonly my $TRUE  => 1;
Readonly my $FALSE => 0;

########################################################################
# Usage      : connect_db( options )
# Purpose    : connect to MySQL server
# Parameters : options : hash or hashref, defaults using DBI_
#                        parameters in environment
#                      : user
#                      : password
#                      : host
#                      : database
#                      : mysql_*  => additonal connect options
#                      : ...      => additonal options to DBI->connect
# Returns    : open database handle
# Errors     : whatever DBI throws
########################################################################
sub connect_db {
########################################################################
  my (@argv) = @_;

  my %connect_options;

  if ( !@argv ) {
    %connect_options = (
      host         => $ENV{DBI_HOST},
      database     => $ENV{DBI_DB} || q{},
      user         => $ENV{DBI_USER},
      password     => $ENV{DBI_PASS},
      mysql_socket => $ENV{DBI_SOCKET} || q{},
    );
  }
  elsif ( !ref $argv[0] ) {
    %connect_options = @argv;
  }
  else {
    %connect_options = %{ $argv[0] };
  }

  my $dbi;

  my $user = delete $connect_options{user};
  $user //= 'root';

  my $password = delete $connect_options{password};
  $password //= undef;

  my $host     = delete $connect_options{host};
  my $database = delete $connect_options{database};

  my %mysql_options = (
    host     => $host     || 'localhost',
    database => $database || q{},
  );

  foreach my $opt ( keys %connect_options ) {
    if ( $opt =~ /\Amysql_/xsm ) {
      $mysql_options{$opt} = $connect_options{$opt};
      delete $connect_options{$opt};
    }
  }

  my $connect_str = join q{;},
    map { "$_=" . $mysql_options{$_} // q{} } keys %mysql_options;

  $connect_str = sprintf 'dbi:mysql:%s', $connect_str;

  $connect_options{AutoCommit} //= $TRUE;
  $connect_options{RaiseError} //= $TRUE;
  $connect_options{PrintError} //= $FALSE;

  return DBI->connect( $connect_str, $user, $password, \%connect_options );
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
