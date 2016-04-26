use strict;
use warnings;

use File::Basename;
use Test::Bedrock qw/run/;

my ($name, $path, $ext) = fileparse($0, qr/(\.[^.])*/);

run(sprintf("t/%s.txt", $name), yaml => 1);
