use strict;
use warnings;

use Test::More tests => 4;

BEGIN {
  use_ok('Bedrock::Template');
}

use Data::Dumper;

my $text =<<eom;
<null:foo "Hello World!">
<var \$foo>
eom

my $template = Bedrock::Template->new();

$template->text($text);

is($text, ${$template->text()}, 'Bedrock::Template->text()') or diag("text: $text, ". ${$template->text()});

like($template->parse(), qr/Hello World/s, 'Bedrock::Template->parse()') 
  or diag("$@ " . Dumper [ $@->mesg, $@->line ]);

like($template->parse($text), qr/Hello World/s, 'Bedrock::Template->parse($text)') 
  or diag("$@ " . Dumper [ $@->mesg, $@->line ]);

