#!/usr/bin/env perl

use strict;
use warnings;

use Cwd qw(abs_path cwd getcwd);
use Data::Dumper;
use English qw(-no_match_vars);
use File::Temp qw(tempdir);
use Test::More;

########################################################################
use Bedrock::Test::Utils qw(connect_db create_db);

my $dbi = eval { return connect_db(); };

if ( !$dbi ) {
  plan skip_all => 'no database connection';
}
else {
  $dbi->do('use bedrock');

  my @tables = map { $_->[0] } $dbi->selectall_arrayref('show tables');

  if ( !grep { $_ eq 'form_test' } @tables ) {
    plan skip_all => 'TODO: create form_test table for test';
  }
  else {
    $dbi->disconnect;
  }
}

use_ok('BLM::IndexedTableHandler::Form');

########################################################################
subtest 'load config' => sub {
########################################################################

  my $path = tempdir( CLEANUP => 1 );

  my $config_file = sprintf '%s/forms/form_test.json', $path;

  mkdir sprintf '%s/forms', $path;

  local $RS = undef;

  my $config = <DATA>;

  open my $fh, '>', $config_file
    or BAIL_OUT("could not create temp config file\n");

  print {$fh} $config;

  close $fh;

  my $form = BLM::IndexedTableHandler::Form->new(
    form_name   => 'form_test',
    config_path => "$path/forms"
  );

  isa_ok( $form, 'BLM::IndexedTableHandler::Form' );

  isa_ok( $form->get_config, 'HASH' );
  my $handler = $form->get_handler;

  isa_ok( $handler, 'BLM::IndexedTableHandler' );

  my $dbi = $handler->dbi;
  isa_ok( $dbi, 'DBI::db' )
    or diag( Dumper( [ handler => $handler ] ) );

  $dbi->disconnect;
};

########################################################################
subtest 'default config' => sub {
########################################################################

  local $ENV{DBI_DB}   = 'bedrock';
  local $ENV{DBI_USER} = 'fred';
  local $ENV{DBI_PASS} = 'flintstone';

  my $form = BLM::IndexedTableHandler::Form->new( form_name => 'form_test', );

  isa_ok( $form, 'BLM::IndexedTableHandler::Form' );

  isa_ok( $form->get_config, 'HASH' );
  my $handler = $form->get_handler;

  isa_ok( $handler, 'BLM::IndexedTableHandler' );

  my $dbi = $handler->dbi;

  isa_ok( $dbi, 'DBI::db' )
    or diag( Dumper( [ handler => $handler ] ) );
};

done_testing;

1;

__DATA__
{
    "tables": {
        "form_test" : {
            "buttons": {
                "attributes": {
                   "class": "btn btn-secondary"
                },
                "save": {
                    "class": "btn btn-primary"
                },
                "new": {
                }
            }
        }
    },
    "javascript": [
        {
            "src": "https://code.jquery.com/jquery-3.7.1.min.js",
            "integrity": "sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=",
            "crossorigin": "anonymous"
        },
        {
            "src": "indexed-table-handler.js"
        },
        {
            "src": "https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js",
            "integrity": "sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz",
            "crossorigin": "anonymous"
        },
        {
            "src": "https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js",
            "integrity": "sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r",
            "crossorigin": "anonymous"
        }
    ],
    "meta": [
        {
            "charset": "utf8"
        },
        {
            "name": "viewport",
            "content": "width=device-width, initial-scale=1"
        }
    ],
    "link": [
        {
            "href": "https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css",
            "rel": "stylesheet",
            "integrity": "sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH",
            "crossorigin": "anonymous"
        }
    ],
    "database": {
        "dsn": "dbi:mysql:bedrock",
        "user": "fred",
        "password": "flintstone",
        "hostname": "127.0.0.1"
    },
    "title": "Test"
}
