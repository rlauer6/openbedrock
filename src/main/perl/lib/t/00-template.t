use strict;
use warnings;

use Data::Dumper;

use Test::More tests => 6;
use English qw{-no_match_vars};

BEGIN {
  use_ok('Bedrock::Template');
}

my $text = <<'EOT';
<null:foo "Hello World!">
<var $foo>
EOT

my $template = Bedrock::Template->new;
isa_ok( $template, 'Bedrock::Template' );

$template->text($text);
is( $text, ${ $template->text() }, 'Bedrock::Template->text()' )
  or diag( "text: $text, " . ${ $template->text() } );

like( $template->parse(), qr/Hello\sWorld/xsm, 'parse()' )
  or diag(
  "$EVAL_ERROR "
    . Dumper [
         ref($EVAL_ERROR)
      && $EVAL_ERROR->can('mesg')
      && ( $EVAL_ERROR->mesg . $EVAL_ERROR->line )
    ]
  );

like( $template->parse($text), qr/Hello\sWorld/xsm, q{'parse($text)} )
  or diag(
  "$EVAL_ERROR "
    . Dumper [
         ref($EVAL_ERROR)
      && $EVAL_ERROR->can('mesg')
      && ( $EVAL_ERROR->mesg . $EVAL_ERROR->line )
    ]
  );

# create a class with method foo()
my $foo = bless {}, 'Foo';

{
  no strict 'refs';  ## no critic (ProhibitNoStrict)

  *{'Foo::bar'} = sub { return "bar" };
}

$text = q{<var $foo.bar()>};  ## no critic (RequireInterpolationOfMetachars)

is( $template->parse( $text, foo => $foo ),
  'bar', q{parse($text) - method call} )  ## no critic (RequireInterpolationOfMetachars)
  or diag(
  "$EVAL_ERROR "
    . Dumper [
         ref($EVAL_ERROR)
      && $EVAL_ERROR->can('mesg')
      && ( $EVAL_ERROR->mesg . $EVAL_ERROR->line )
    ]
  );

