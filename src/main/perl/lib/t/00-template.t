use strict;
use warnings;

use Data::Dumper;
use Test::More;
use English qw(-no_match_vars);

BEGIN {
  use_ok('Bedrock::Template');
}

my $template;

my $text = <<'END_OF_TEMPLATE';
<null:foo "Hello World!">
<var $foo>
END_OF_TEMPLATE

########################################################################
subtest 'new' => sub {
########################################################################

  $template = Bedrock::Template->new;
  isa_ok( $template, 'Bedrock::Template' );
};

########################################################################
subtest 'text' => sub {
########################################################################
  $template->text($text);

  is( $text, ${ $template->text() }, 'Bedrock::Template->text()' )
    or diag( "text: $text, " . ${ $template->text() } );
};

########################################################################
subtest 'parse' => sub {
########################################################################

  like( $template->parse(), qr/Hello\sWorld/xsm, 'parse()' )
    or diag( "$EVAL_ERROR "
      . Dumper [ ref($EVAL_ERROR) && $EVAL_ERROR->can('mesg') && ( $EVAL_ERROR->mesg . $EVAL_ERROR->line ) ] );

  like( $template->parse($text), qr/Hello\sWorld/xsm, q{'parse($text)} )
    or diag( "$EVAL_ERROR "
      . Dumper [ ref($EVAL_ERROR) && $EVAL_ERROR->can('mesg') && ( $EVAL_ERROR->mesg . $EVAL_ERROR->line ) ] );
};

########################################################################
subtest 'invoke a method on a class' => sub {
########################################################################
  # create a class with method foo()
  my $foo = bless {}, 'Foo';

  {
    no strict 'refs';  ## no critic (ProhibitNoStrict)

    *{'Foo::bar'} = sub { return "bar" };
  }

  $text = q{<var $foo.bar()>};  ## no critic (RequireInterpolationOfMetachars)

  is( $template->parse( $text, foo => $foo ), 'bar', q{parse($text) - method call} )  ## no critic (RequireInterpolationOfMetachars)
    or diag( "$EVAL_ERROR "
      . Dumper [ ref($EVAL_ERROR) && $EVAL_ERROR->can('mesg') && ( $EVAL_ERROR->mesg . $EVAL_ERROR->line ) ] );
};

########################################################################
subtest 'new w/options' => sub {
########################################################################
  my $text = <<'END_OF_TEMPLATE';
<var $bar>
END_OF_TEMPLATE

  $template = Bedrock::Template->new( $text, bar => 'foo' );

  isa_ok( $template, 'Bedrock::Template' );

  my $result = $template->parse();
  ok( $result eq "foo\n", 'template, key/value' )
    or diag($result);

  $template = Bedrock::Template->new( { text => $text, params => { bar => 'foo' } } );
  isa_ok( $template, 'Bedrock::Template' );

  $result = $template->parse();

  ok( $result eq "foo\n", 'template, key/value' )
    or diag( Dumper( [ result => $result ] ) );

  $template = Bedrock::Template->new( { template => *DATA, params => { bar => 'foo' } } );
  isa_ok( $template, 'Bedrock::Template' );

  $result = $template->parse();

  ok( $result eq "foo\n", 'template, key/value' )
    or diag( Dumper( [ result => $result ] ) );
};

done_testing;

1;

__DATA__
<var $bar>
