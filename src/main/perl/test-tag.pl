#!/usr/bin/env perl

use strict;
use warnings;

use File::Basename;
use English qw(-no_match_vars);
use Cwd;

use Bedrock::Test qw(run config);

########################################################################
my ( $name, $path, $ext ) = fileparse( $PROGRAM_NAME, qr/[.][^.]+$/xsm );

my $test_path = $ENV{TEST_PATH} // cwd;

my $test_file = sprintf '%s/t/%s.yml', $test_path, $name;

my $config = config( getcwd . '/t/config' );

$config->{LogLevel} = $ENV{LogLevel};

run( $test_file, yaml => 1, config => $config );

1;

## no critic (RequirePodSections)

__END__

=pod

=head1 PUBLIC

test-tag.pl - run a unit test described by a YAML file

=head1 USAGE

 ln -s test-tag.pl t/00-some-test.t

 prove -v t/00-some-test.t

=head1 DESCRIPTION

This is a script interface to a test harness (L<Bedrock::Test>) based
on L<Test::More> that is used to test Bedrock tags.

Bedrock unit tests for tags are implemented using a YAML file that
describes each test and the success criteria.  Each F<YAML> file
specifies a snippet of Bedrock which exercises some feature of a tag.

A suitable environment (logging, configuration) for the test is
initialized by the harness similar to that provided by Bedrock when it
processes Bedrock files. The test is then executed by passing the test
I<snippet> to Bedrock's tag processor. Test results are analyzed by
the L<Bedrock::Test> harness using L<Test::More> comparison methods
and the criteria for success you provide in the YAML file.

The F<test-tag.pl> script uses the name portion of the F<.t> symbolic
link to determine the name of the F<.yml> test description that will
be passed to the C<Bedrock::Test::run()> method.

=head1 FORMAT OF TEST DESCRIPTIONS

Test descriptions are YAML files that can define several keys for each
test. At a minimum you need to provide the I<test> and
the expected I<result>.

   ---
   name: <sink:foo>
   comment: test the <sink> object creation
   test: <sink:foo>foo</sink>
   result: foo
   op: is

By default the C<result> value is compared (equality) with the output
produced by the test snippet. If the result is exactly equal to the
output, then the test is successful. If you want to compare the result
in a different way you can include a key C<op> that specifies one of
the other comparison methods.

=head2 Test Description Sections

=over 5

=item * name

The name of the test. The name is displayed in the TAP output.

=item * comment

An arbitrary comment to help you remember what the test does.

=item * test

Th Bedrock snippet that defines the test.

=item * include

Instead of placing the test inside this YAML file, you can also
specify the name of a file that contains the test snippet. The default
extension should be F<.roc>. This is useful, for example for testing
your snippet using Bedrock CLI first, then simply using that F<.roc>
file as your test snippet.

To use F<boo.roc> in the current directory:

Example:

 include: boo

To use F<boo.roc> from the tests directory:

 include: t/boo

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

default: C<is>

When using the C<like> operator, you should specify the regular
expression in the same way you would in a a Perl script by placing
the regular expression between two slashes. Some examples from actual tests:

 t/01-multi-line.yml-result: /foo,bar,biz/
 t/02-null.yml-error: /invalid type/
 t/02-null.yml-result: /\s*test, bar, test\s*/
 t/03-if.yml:result: "/doesn't look like/"
 t/04-foreach.yml-result: /foo=1,0,bar=2,1,biz=3,2/
 t/04-foreach.yml-result: /1:Larry\n2:Moe/
 t/06-open.yml-result: /ok\nok\nok\nok/
 t/10-try.yml-result: '/^\s*error: invalid type\s*$/s'
 t/19-pebble.yml-result: /foo\s=>\s.*<var\s+\$ARGV\.join\(","\)>/xsm
 t/20-benchmark.yml-result: /2\..* wallclock/
 t/21-sqlselect.yml-result: /[\da-f]{32}/

=item * error

A string enclosed with slashes that is used in a regular expression to
test the value of an exception expected to be thrown by Bedrock.

=item * env

If you want to inject or override an enviroment variable you can
create a hash of key/value pairs that will replace or add to the
existing environment. For example, some tests in your file might
require environment variables that you've passed on the command line:

 DBI_HOST=localhost prove -v t/00-some-test.t

...but in the same test file you later need to use a different value
for the environment variable. Add an C<env> section to the test and
add the new values. These will be injected into the environment for
just that test.

 env:
   DBI_HOST: my-server
   DBI_PASS: flintstone
   DBI_USER: fred

=item * config

Similar to overriding environment variables, you can override values
in Bedrock's configuration by specifying them in the C<config>
section. You may want to do this to temporarily change the values for
one particular test in your test suite.

 name: <sqlconnect> dsn, but no user
 env:
   DBI_USER:
   DBI_PASS:
 config:
   DBI_USER:
   DBI_PASS:
   DBI_DSN:
   DBI_HOST:
 test: |
   <try>
     <sqlconnect:dbi --verbose dbi:mysql:bedrock:localhost mysql_socket $env.DBI_SOCKET>
     <iif $dbi success 'no dbi'>
   <catch>
     <var $@>
   </try>
 result: '/no user found/'
 op:like

I<Note in the test above we could have used the C<error:> section to
determine if Bedrock throws the proper exception. In general, tests
should be short and use the minimum amount of Bedrock processing that
exercises the precise feature you are testing.>

 name: <sqlconnect> dsn, but no user
 env:
   DBI_USER:
   DBI_PASS:
 config:
   DBI_USER:
   DBI_PASS:
   DBI_DSN:
   DBI_HOST:
 test: |
   <sqlconnect:dbi --verbose dbi:mysql:bedrock:localhost mysql_socket $env.DBI_SOCKET>
 result: '/no user found/'
 op:like

=back


=head2 Testing Tips

=head3 Testing Exceptions

To test the value of an exception thrown by Bedrock, set the key
C<error` instead of `result>.  Use regular expression (enclosed in //)
for the C<like> operator.

 name: invalid type
 test: <null:hashref:foo foo>
 error: /invalid type/
 op: like

=head3 Testing Long Snippets

To test longer Bedrock snippets, use the literal form of YAML and the
chomp (-) indicator to remove final new lines.

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

=head3 Regular Expressions

Remember that Bedrock is a templating tool and preserves all of your
whitespace including newlines. Remember to include the new line
character in your regular expresssions if you have new lines in your
tests.

Note in the test below that we have multiple tests of the output, each
on a new line.

 name: open w/csv filter
 comment: create a file, write contents, close file, read contents
 test: |-
   <sink><array:foo a b c >
   <open:fd --filter=csv --mode="w" "foo.csv">
   <null $fd.print($foo)>
   <null $fd.close()>
   <open:fd --filter=csv --mode="r" "foo.csv">
   <null:boo  $fd.getline()></sink>
   <if --array $boo>ok</if>
   <if $boo.[0] --eq 'a'>ok<else>not an "a"</if>
   <if $boo.[1] --eq 'b'>ok<else>not a "b"</if>
   <if $boo.[2] --eq 'c'>ok<else>not a "c"</if>
 result: /ok\nok\nok\nok/
 op: like

=head1 AUTHOR

Rob Lauer - rclauer@gmail.com

=cut
