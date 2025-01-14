use strict;
use warnings;

use Data::Dumper;
use Test::More qw(no_plan);
use English qw(-no_match_vars);

BEGIN {
  use_ok('Bedrock::Template');
}
my $template;

########################################################################
subtest 'disable tag' => sub {
########################################################################
  my $text = <<'END_OF_TEMPLATE';
<object>
  <array name="foo">
    <scalar><var $bar></scalar>
  </array>
</object>
END_OF_TEMPLATE

  $template
    = eval { Bedrock::Template->new( { text => $text, params => { bar => 'bar' }, disable_tag => 'array' } ); };

  ok( $template && !$EVAL_ERROR, 'new' )
    or diag($EVAL_ERROR);

  isa_ok( $template, 'Bedrock::Template' );

  my $result = $template->parse();

  like( $result, qr/<array\sname="foo">\n\s*<scalar>bar<\/scalar>/xsm, 'disable tag (array)' )
    or diag( Dumper( [ result => $result ] ) );
};

########################################################################
subtest 'enable tag' => sub {
########################################################################
  $template->disable_tag( [] );

  my $result = $template->parse();

  like( $result, qr/<object>\n\s*\n\s*<scalar>bar<\/scalar>/xsm, 'enable tag (array)' )
    or diag( Dumper( [ result => $result ] ) );
};

done_testing;

1;

__DATA__

