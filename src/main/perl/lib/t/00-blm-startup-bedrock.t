use strict;
use warnings;

package Faux::Context;

########################################################################
sub new {
########################################################################
  my ( $class, %options ) = @_;

  my $self = bless \%options, $class;

  return $self;
}

########################################################################
sub cgi_header_in    { }
sub send_http_header { }
sub cgi_header_out   { }
sub getCookieValue   { }
sub getInputValue    { }
sub getConfigValue   { }

########################################################################
package main;
########################################################################
use Bedrock::Constants qw(:defaults :chars :booleans);

use Cwd;
use Data::Dumper;
use English qw(-no_match_vars);
use Test::More qw(no_plan);

use_ok('BLM::Startup::Bedrock');

########################################################################
sub bind_module {
########################################################################
  my ( $ctx, $config ) = @_;

  my $module = q(BLM::Startup::Bedrock);

  my $obj = bless {}, $module;

  tie %{$obj}, $module, $ctx, $config;  ## no critic (ProhibitTies)

  return $obj;
}

my $ctx = Faux::Context->new( CONFIG => {} );
my $bedrock;

########################################################################
subtest 'bind' => sub {
########################################################################
  $bedrock = bind_module($ctx, {});

  isa_ok($bedrock, 'BLM::Startup::Bedrock');
};

########################################################################
subtest 'iso_8601' => sub {
########################################################################
  my $iso_time = $bedrock->iso_8601();
  diag($iso_time);

  ok($iso_time, 'iso_8601');

  like($iso_time, qr/^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z$/xsm, 'looks like an iso8601 time?')

    or diag($iso_time);

};

########################################################################
subtest 'perl_config' => sub {
########################################################################
  my $config = $bedrock->perl_config();

  isa_ok($config, 'HASH');

  my ($installsitebin) = $bedrock->perl_config('sitebin');

  ok($installsitebin, 'installsitebin');

  like($installsitebin, qr/\//xsm, 'path');
};

########################################################################
subtest 'localtime' => sub {
########################################################################
  my $localtime = $bedrock->localtime();
  isa_ok($localtime, 'Bedrock::Array');

  ok(@{$localtime} == 9, '9 element array');
};

########################################################################
subtest 'version' => sub {
########################################################################
  my $version = $bedrock->version();

  like($version, qr/^\d+[.]\d+[.]\d+$/xsm, 'M.n.r');
};

done_testing;

END {
}

1;
