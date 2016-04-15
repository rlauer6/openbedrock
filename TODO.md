# The Bedrock 3 TODO List

## Benchmark

Create some benchmarks to set the state for optimizing Bedrock.


## Create a test suite

Create a test suite for Bedrock, preferably based on Test::More

## Move some features to separate packages

Try to create a lighter install by moving certain files into a
bedrock-extras RPM. Candidates might include:

* Simple BLMs
* BLM/Filter/*
* Startup BLMs (session handlers)
* Utilities (bedrock-plugin, bedrock-cache)

## Update the BUG

Update the Bedrock User's Guide based on changes over the last 2
years.

## Create a continuous integration build script

Re-write the build-bedrock-rpm script formerly used in the CVS
distribution.

## Re-implement the Bedrock parser

The Bedrock parser is not that great, but it sortakinda works.
Although it works, it limits what we can do with the Bedrock
"language", if you want to call it that.

That's a blessing in reality as it prevents us from reinventing PHP
and helps us maintain our focus on using Bedrock as a templating
engine, not a programming language.

An early design decision to implement Bedrock tags in a way that
differentiates their options from HTML attributes was to use the --
notation for options to tags.  Template::Toolkit which came along
around the same time (late '90s) that Bedrock was being developed
chose to use a syntax that clearly indicates the constructs are not
HTML tags.

    Hello [% world %]!

..in TT would look like

    Hello <var $world>!

..in Bedrock. Bedrock 3 needs to consider <% %> or [% %] as the tag
indicators.

In hindsight, I think TT got it right with that syntax, however when
we allow things like:

     [% USE DBI( database = 'dbi:mysql:dbname',
                 username = 'guest',
                 password = 'topsecret' )
     %]
     <ul>
     [% FOREACH customer IN DBI.query('SELECT * FROM customers') %]
       <li>[% customer.name %]</li>
     [% END %]
     </ul>
   
...I start to get nervous.  We wanted something that looks less like
programming.

     <sqlselect "select * from customers">
     <ul>
       <li><var $name></li>
     </ul>
     </sqlselect>

...leaving things like database connections out of the mix and
delegating them to configuration mechanisms (although the <sqlconnect>
tag does allow one to override those mechanisms).

Regardless, the parser needs work and I'd like to see the parser
become a pre-compiler that creates Bedrock p-code that can
subsequently be executed by a runtime p-code interpreter.  Primarily
this would speed page parsing.  Alternately, we could parse Bedrock
pages into Perl.  Which, achieves the same objective.

The parser also makes adding new features a bit burdensome, especially
given the way Bedrock parses tags and options.  Take for example this
type of feature you might be tempted to implement...

    <some_new_tag --option=arg>
    <some_new_tag --option>

In this case we want a tag that has an option with an "optional"
argument.  If the option exists however, it has some default meaning.
A good example might be...

    --verbose
    --verbose=3

Jay's solution was:

    --verbose --verbose --verbose

ARRGHHHH...in other words if he sees multiple instances of an option,
he increments an counter so that in a tag implementation
$options{'verbose'} would be 3.

What happens when you just go ahead and drop the argument to an option
that requires an argument?

    <some_new_tag --verbosity-level=3 $foo>
    <some_new_tag --verbosity-level $foo>

Turns out that the way Bedrock parses a tag creates a bit of a
problem since by the time a tag implementation is invoked, the parser
has done some magic on this line and essentially created a bunch of
evaluated arguments in @argv.  The tag implementation typically then
calls `$sefl->parse_options()' as below:

    my %options = ('verbosity-level=s'	=> undef,
                   'htmlencode'         => undef
		  );

    my @argv = $self->parse_options (\%options, @context);

Since the Bedrock options parser is being told (we presume as shown
above with the =s specification) that the option requires an option it
interprets the @context and returns an @argv in that light and
slurps $foo as the verbosity level.

So...as a hack, your tag implementation can, contextually determine
that your tag can and often does NOT have an argument and seeing the
next argument as something foreign (or not at all!) might rightly
assume that the option slurped up the argument!

In that case $foo will be found in $options{'verbosity-level'} and can
be safely pushed back onto @argv for further processing...

So you're code might look something like:

     unless (@argv) {
       # that's odd this tag needs an argument!
       if ($options{'verbosity-level'}) {
          # ...hmmm should I assume this was parsed incorrectly and the
          #    text was really --verbosity-level with no argument?
          # ...if $foo in my tag implementation was required to be of
          #    certain type, additional sniffing might be helpful...
          #    more evidence if (ref($options{'verbosity-level'} =~/array/i) ...
         push @argv, $options{'verbosity-level'};
         # make sure $options{'verbosity-level'} exists, but is undefined
         # which was the true intent of --verbosity-level
         $options{'verbosity-level'} = undef; 
       }
     }

Later in your tag implementation you might simple test for the
existence of 'verbosity-level' to determine if this is on or at what
level, for example...

Surprisingly, this method works in a variety of situations where you
might think the parser would just screw up.  I think as long as you
don't have two options like this, you should be good.  Bottom line,
the parser needs some work.

Bedrock expressions do not recognize operator precedence, so
parentheses are required in all circumstances except the simplest use
of an expression in an <if> tag.

    <if $foo --eq "bar">....</if>

Anything more complex that that, will require parens.

    <if (($foo --eq "bar") --and ($baz --eq "buz"))>...</if>

...and lot's of them.
