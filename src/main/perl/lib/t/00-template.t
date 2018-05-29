use strict;
use warnings;

use Data::Dumper;

use Test::More tests => 6;

BEGIN {
  use_ok('Bedrock::Template');
}

my $text =<<eom;
<null:foo "Hello World!">
<var \$foo>
eom

my $template = new Bedrock::Template;
isa_ok($template, 'Bedrock::Template');

$template->text($text);
is($text, ${$template->text()}, 'Bedrock::Template->text()') or diag("text: $text, ". ${$template->text()});

like($template->parse(), qr/Hello World/s, 'parse()') 
  or diag("$@ " . Dumper [ ref($@) && $@->can('mesg') && ($@->mesg . $@->line) ]);

like($template->parse($text), qr/Hello World/s, 'parse($text)') 
  or diag("$@ " . Dumper [ ref($@) && $@->can('mesg') && ($@->mesg . $@->line) ]);

# create a class with method foo()
my $foo = bless {}, 'Foo';
{
  no strict 'refs';
  
  *{'Foo::bar'} = sub { return "bar" };
}

$text = '<var $foo.bar()>';

is($template->parse($text, foo => $foo), 'bar', 'parse($text) - method call') 
  or diag("$@ " . Dumper [ ref($@) && $@->can('mesg') && ($@->mesg . $@->line) ]);


