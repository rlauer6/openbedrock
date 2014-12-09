use strict;
use warnings;

use Test::More;

use Bedrock::Template;
use FindBin qw($Bin);

my $dir = "$Bin/template-tests";
if (! -d $dir) {
    plan skip_all => "$dir is not a directory";
}

my @in = glob("$dir/*.input");
if (0 == @in) {
    plan skip_all => "$dir does not contain any input files";
}

plan tests => scalar @in;

for my $input (@in) {
    test_input($input);
}

exit;

sub test_input {
    my $input_file = shift;
    my $input_text = do {
        open my $fh, '<', $input_file
            or die "cannot open $input_file for reading: $!";
        local $/;
        <$fh>
    };

    my $template = Bedrock::Template->new($input_text);
    my $generated_output = $template->parse;
    my $test_name = substr $input_file, length($dir) + 1;
    $test_name =~ s/\.input$//;

    (my $output_file = $input_file) =~ s/\.input$/.output/;
    if (-r $output_file) {
        my $expected_output = do {
            open my $fh, '<', $output_file
                or die "cannot open $output_file for reading: $!";
            local $/;
            <$fh>
        };
        is $generated_output, $expected_output, $test_name;
    } else {
        # Generate output.  This is simply for convenience.
        open my $fh, '>', $output_file
            or die "cannot open $output_file for writing: $!";
        print $fh $generated_output;
        ok 1, "generated output for $test_name";
    }
}
