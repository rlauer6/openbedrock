# This is a driver script.
# Usage:
#  perl -Isrc/main/perl/lib{,/Bedrock,/Bedrock/Text} t.pl

use strict;
use warnings;

use IO::Scalar;
use Log::Log4perl qw(:easy);
use Text::TagX;

Log::Log4perl->easy_init($DEBUG);

use constant TEMPLATE => <<'TEMPLATE';
<if $foo>
    foo
<else>
    bar
</if>
TEMPLATE

my $template = IO::Scalar->new(\TEMPLATE);
my $output;

my $tx = Text::TagX->new($template, IO::Scalar->new( \$output));

my $obj = $tx->get_parse_object;
for (qw(input out_handle)) {
  delete $$obj{TagX}{$_};
}
my $ser = Dumper($obj); use Data::Dumper;
eval "\$obj = do { $ser }";   ## XXX odd: other forms of eval don't work
                              ## (return value of eval).

# This loop is to demonstrate the separation of parsing and evaluation.
for my $args (
  [ qw(foo 1) ],
  [ qw(foo 0) ],
) {
  my $symtab = TagX::Symtab->new;
  while (my ($k, $v) = splice @$args, 0, 2) {
    $symtab->{$k} = $v;
  }
  $tx->vars($symtab);
  $tx->out_handle( TagX::Output->new( IO::Scalar->new(\my $output) ) );
  $obj->finalize;

  print $output;
}
