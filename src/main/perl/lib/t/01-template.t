use Test::More tests => 4;

use strict;
use warnings;

package MIME::Lite;
  
sub new { bless {}, shift; }
sub send{}

package main;

BEGIN {
  use Module::Loaded;
  
  mark_as_loaded(MIME::Lite);
  
  use_ok('Bedrock::Template::Email');
}

my $text =<<eom;
<null:foo "Hello World!">
<var \$foo>
eom

use Data::Dumper;

my $template = new Bedrock::Template::Email;
isa_ok($template, 'Bedrock::Template::Email');

$template->text($text);
is($text, ${$template->text()}, 'Bedrock::Template::Email->text()') or diag("text: $text, ". ${$template->text()});

eval {
  $template->email_message($text, foo => 'bar', to => 'rlauer6@comcast.net', from => 'support@bedrock.org', subject => 'test');
};

is($@, '', 'send an email');


