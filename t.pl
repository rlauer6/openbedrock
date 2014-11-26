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

$tx->param(@ARGV);
 
my $error = $tx->output;

die @{$error}
    if @{$error};

print $output;
