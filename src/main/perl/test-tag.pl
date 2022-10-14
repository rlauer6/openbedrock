#!/usr/bin/env perl

use strict;
use warnings;

use File::Basename;
use English qw{-no_match_vars};

use Test::Bedrock qw{run};

my ( $name, $path, $ext ) = fileparse( $PROGRAM_NAME, qr/[.][^.]+$/xsm );

my $test_file = sprintf 't/%s.yml', $name;
my $log_file  = $ENV{LOGFILE} || 'bedrock-test.log';

run(
  $test_file,
  yaml    => 1,
  logfile => $log_file,
);

1;

## no critic (RequirePodSections)

__END__

=pod

=head1 NAME

test-tag.pl - run a unit test described by a YAML file

=head1 USAGE

 ln -s test-tag.pl t/00-some-test.t

 prove -v t/00-some-test.t

=head1 DESCRIPTION

Script interface for L<Test::Bedrock>. Uses the name portion of the
F<.t> symbolic link to construct the name of the F<.yml> test
description passed to the C<run()> method.

=head1 TEST DESCRIPTIONS

Test descriptions are YAML files that defines several keys
for each test.

   ---
   name: <sink:foo>
   comment: test the <sink> object creation
   test: <sink:foo>foo</sink>
   result: foo

=over 5

=item * name

The name of the test. The name is displayed in the TAP output.

=item * comment

An arbitrary comment to help you remember what the test does.

=item * test

Th Bedrock snippet that defines the test.

=item * result

The expected result

=item * op

An operator to be used to compare the expected result with the actual
result of the test.

 is
 isnt
 like
 unlike
 cmp_ok
 qr

default: C<is>

=item * error

A string enclosed with slashes that is used in a regular expression to
test the value of an exception expected to be thrown by Bedrock.

=back

By default the C<result> value is compared (equality) with the output
produced by the test snippet. If the result is exactly equal to the
output, then the test is successful. If you want to compare the the
result in a different way you can include a key C<op> to use other
comparison methods.

=head2 Testing Tips

=head3 Testing Exceptions

To test the value of an exception thrown by Bedrock, set the key
C<error` instead of `result>.  Use regular expression (enclosed in //)
for the C<like> operator.

    ---
    name: invalid type
    test: <null:hashref:foo foo>
    error: /invalid type/
    op: like

=head3 Testing Long Snippets

To test longer Bedrock snippets, use the literal form of YAML and the
chomp (-) indicator to remove final new lines.

    ---
    name: <try/catch>
    test: |-
      <try>
        <null:hashref:foo foo>
      <catch 'invalid type'>
        <flush>1</catch>
    result: 1

Of course, feel free to flex your regexp prowess!!

    ---
    name: <try/catch>
    test: |
      <try>
        <null:hashref:foo foo>
      <catch 'invalid type'>
        1
      </try>
    result: /^\s*1\s*$/s
    op: like

=head1 AUTHOR

Rob Lauer - rclauer@gmail.com

=cut
