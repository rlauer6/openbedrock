#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::Output;
use File::Temp qw(tempdir);
use JSON;
use Data::Dumper;
use Cwd qw(abs_path);

# 1. Load Real Modules
BEGIN {
  use File::Basename qw(dirname);
  my $lib = dirname(dirname(abs_path(__FILE__))) . '/lib';
  unshift @INC, $lib;
  
  require Bedrock::Service::Autocomplete;
  require Apache::Request::CGI;
}

sub setup_json_file {
    my ($dir, $filename, $data) = @_;
    my $path = "$dir/$filename";
    open my $fh, '>', $path or die "Cannot write $path: $!";
    print $fh JSON->new->encode($data);
    close $fh;
    return $path;
}

# -----------------------------------------------------------------------------
# TEST DATA
# -----------------------------------------------------------------------------
my $global_dir = tempdir( CLEANUP => 1 );
my $session_dir = tempdir( CLEANUP => 1 );

my $users_data = [ { label => 'Alice', id => 1 }, { label => 'Bob', id => 2 } ];
setup_json_file($global_dir, 'users.json', $users_data);
setup_json_file($session_dir, 'private.json', [{ label => 'SecretAgent', id => 99 }]);

# Setup Environment Defaults
$ENV{GATEWAY_INTERFACE} = 'CGI/1.1';
$ENV{REQUEST_METHOD}    = 'GET';
$ENV{SCRIPT_NAME}       = ''; 

# --- TEST CASE 1: Standard Lookup (Global File) ---
{
    local $ENV{BEDROCK_AUTOCOMPLETE_ROOT} = $global_dir;
    local $ENV{PATH_INFO}    = '/autocomplete/users.json';
    local $ENV{QUERY_STRING} = 'term=ali'; 
    local $ENV{REQUEST_URI}  = '/autocomplete/users.json?term=ali';

    my $svc = Bedrock::Service::Autocomplete->new();

    my $output = stdout_from( sub { $svc->run() } );
    my ($headers, $body) = split /\r?\n\r?\n/, $output, 2;
    
    # [FIX] Accept 'Status: 200' OR 'HTTP/1.0 200 OK'
    like($headers, qr/(?:Status:|HTTP\/[\d\.]+)\s+200/, 'Status is 200 OK');
    like($headers, qr|Content-?Type: application/json|i, 'Content-Type is JSON');
    
    my $json = eval { decode_json($body) };
    ok($json, 'Body is valid JSON');
    is(scalar @$json, 1, 'Found 1 match');
    is($json->[0]->{label}, 'Alice', 'Data matches "Alice"');
}

# --- TEST CASE 2: Session Directory Lookup ---
{
    local $ENV{BEDROCK_AUTOCOMPLETE_ROOT} = undef;
    local $ENV{PATH_INFO}    = '/autocomplete/private.json';
    local $ENV{QUERY_STRING} = 'term=secret';
    local $ENV{REQUEST_URI}  = '/autocomplete/private.json?term=secret';

    my $svc = Bedrock::Service::Autocomplete->new();
    
    # Inject session manually
    $svc->context->session({ _session_dir => $session_dir });

    my $output = stdout_from( sub { $svc->run() } );
    my ($headers, $body) = split /\r?\n\r?\n/, $output, 2;

    my $json = eval { decode_json($body) };
    ok($json, 'Body is valid JSON');
    is($json->[0]->{label}, 'SecretAgent', 'Found file in injected session dir');
}

# --- TEST CASE 3: 404 Not Found ---
{
    local $ENV{BEDROCK_AUTOCOMPLETE_ROOT} = $global_dir;
    local $ENV{PATH_INFO}    = '/autocomplete/missing.json';
    local $ENV{QUERY_STRING} = '';
    local $ENV{REQUEST_URI}  = '/autocomplete/missing.json';

    my $svc = Bedrock::Service::Autocomplete->new();

    my $output = stdout_from( sub { $svc->run() } );
    my ($headers, $body) = split /\r?\n\r?\n/, $output, 2;

    # [FIX] Check for 404 in Status OR HTTP line
    ok( $headers =~ /(?:Status:|HTTP\/[\d\.]+)\s+404/ || $output =~ /File not found/i, 'Returns 404 error state' );
}

# --- TEST CASE 4: Custom Search Key ---
{
    my $custom_dir = tempdir( CLEANUP => 1 );
    setup_json_file($custom_dir, 'custom.json', [{ name => 'Xavier', rank => 1 }]);

    local $ENV{BEDROCK_AUTOCOMPLETE_ROOT} = $custom_dir;
    local $ENV{PATH_INFO}    = '/autocomplete/custom.json';
    local $ENV{QUERY_STRING} = 'term=xav';
    local $ENV{REQUEST_URI}  = '/autocomplete/custom.json?term=xav';

    my $svc = Bedrock::Service::Autocomplete->new(
        service_config => {
            overrides => { 
                autocomplete => { search_key => 'name' } 
            }
        }
    );

    my $output = stdout_from( sub { $svc->run() } );
    my ($headers, $body) = split /\r?\n\r?\n/, $output, 2;

    my $json = eval { decode_json($body) };
    ok($json, 'Body is valid JSON');
    is($json->[0]->{name}, 'Xavier', 'Found "Xavier" using custom search_key');
}

done_testing();
