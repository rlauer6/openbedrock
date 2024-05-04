#!/usr/bin/perl

use lib qw(.);

use Test::More;
use List::Util q(sum);

use Data::Dumper;

use_ok('Bedrock::Pager');

my $pager = Bedrock::Pager->new( list => [ 0 .. 13 ], page_size => 3 );

my @page = $pager->next_page;

is( $pager->get_num_pages, 5, 'number of pages' );

is( scalar(@page), 3, 'page size' );

is_deeply( \@page, [ 0 .. 2 ], 'first page' )
  or diag( Dumper( \@page ) );

@page = $pager->next_page;
is_deeply( \@page, [ 3 .. 5 ], 'next page' )
  or diag( Dumper( \@page ) );

my $page_ref = $pager->next_page;
ok( ref $page_ref, 'is a ref' );

is_deeply( $page_ref, [ 6 .. 8 ], 'return array ref' );

$pager->next_page;
$page_ref = $pager->next_page;

is( @{$page_ref}, 2, 'last page has 2 element' );

ok( !$pager->next_page, 'end of list' );

@page = $pager->rewind->next_page;
is_deeply( \@page, [ 0 .. 2 ], 'rewind' );

@page = $pager->last_page;
is_deeply( \@page, [ 12, 13 ], 'last page' );

@page = $pager->first_page;
is_deeply( \@page, [ 0 .. 2 ], 'first page' );

@page = $pager->current_page;
is_deeply( \@page, [ 0 .. 2 ], 'current_page' );

$pager->rewind;

my $counter = 0;

my $total = sum( 0 .. 13 );

is( sum( map { sum( $pager->next_page ) } ( 0 .. 4 ) ), $total, 'all pages' );

$pager->set_list( [ 0 .. 9 ] );
$pager->set_page_size(5);

is( $pager->get_num_pages, 2, 'all full pages' );

$total = sum 0 .. 9;
my $num_pages;

while ( my $page = $pager->next_page ) {
  $total -= sum @{$page};
  ++$num_pages;
}

ok( !$total, 'retrieve all full pages' );
is( $num_pages, 2, '2 pages' );

$pager->rewind;
$pager->set_page_size(2);
is( $pager->get_num_pages, 5, 'reset page size' );

done_testing;

1;
