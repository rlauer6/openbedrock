use strict;
use warnings;

use Test::More;
use Data::Dumper;

use_ok('BLM::IndexedTableHandler::Common');

BLM::IndexedTableHandler::Common->import(':all');

my %expected = (
  create_attribute_list => q{ checked name="foo" selected size="16" type="text" value="bedrock"},
  create_checkbox       =>
    qq{<input checked id="color" name="color" type="checkbox" value="red"/><label for="color">Red</label> <input id="color" name="color" type="checkbox" value="blue"/><label for="color">Blue</label> <input id="color" name="color" type="checkbox" value="green"/><label for="color">Green</label>},
  ,
  create_radio =>
    qq{<input checked id="color" name="color" type="radio" value="red"/><label for="color">Red</label> <input id="color" name="color" type="radio" value="blue"/><label for="color">Blue</label> <input id="color" name="color" type="radio" value="green"/><label for="color">Green</label>},
);

$expected{create_html_element} = sprintf '<input%s/>', $expected{create_attribute_list};

$expected{create_select_list}
  = qq{<select class="select-box" id="color" name="color">\n<option selected value="red">Red</option>\n<option value="blue">Blue</option>\n<option value="green">Green</option>\n</select>};

my @attributes = (
  checked  => undef,
  name     => 'foo',
  selected => 'undef',
  size     => 16,
  type     => 'text',
  value    => 'bedrock',
);

my $subtest = 'create_attribute_list';

########################################################################
subtest $subtest => sub {
########################################################################
  my $attribute_list = create_attribute_list(@attributes);

  is( $attribute_list, $expected{$subtest}, $subtest );
};

$subtest = 'create_html_element';
########################################################################
subtest $subtest => sub {
########################################################################
  my $attribute_list = create_html_element( 'input', @attributes );

  is( $attribute_list, $expected{$subtest}, $subtest );
};

$subtest = 'create_checkbox';
########################################################################
subtest $subtest => sub {
########################################################################
  my $checkbox = create_checkbox(
    'color', [qw(red)],
    { id => 'color' },
    Red   => 'red',
    Blue  => 'blue',
    Green => 'green'
  );

  is( $checkbox, $expected{$subtest}, $subtest );

  $checkbox = create_checkbox(
    { name    => 'color',
      checked => [qw(red)],
      values  => [
        Red   => 'red',
        Blue  => 'blue',
        Green => 'green'
      ]
    }
  );

  is( $checkbox, $expected{$subtest}, $subtest );
};

$subtest = 'create_radio';
########################################################################
subtest $subtest => sub {
########################################################################
  my $radio = create_radio_buttons(
    { name    => 'color',
      checked => [qw(red)],
      values  => [
        Red   => 'red',
        Blue  => 'blue',
        Green => 'green'
      ]
    }
  );

  is( $radio, $expected{$subtest}, $subtest );
};

$subtest = 'create_select_list';
########################################################################
subtest $subtest => sub {
########################################################################
  my $select_list = create_select_list(
    'color' => 'red',
    { select => { id => 'color', class => 'select-box' } },
    Red   => 'red',
    Blue  => 'blue',
    Green => 'green'
  );

  is( $select_list, $expected{$subtest} // q{}, $subtest );
};

done_testing;

1;
