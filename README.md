This is the README file for the 'bedrock' project.

See [http://twiki.openbedrock.net]() for more helpful hints.

# Overview

Bedrock is a server side web development framework that can be used
with Apache web servers. It allows full stack web developers to create
dynamic web pages through the use of a small set of HTML-like
tags. Bedrock is an enabling technology that glues together HTML pages
and dynamic data (HTML form data, data from databases, and system
services) to create web applications.

Developers can extend Bedrock in interesting ways through the use of
Perl plugins.

Bedrock differs significantly from most web application development
environments that either generate HTML pages as output (e.g. CGIs,
Servlets) or are themselves programs embedded within HTML pages
(e.g. PHP, Mason, ASP, etc) by allowing the developer to assemble
pages from object oriented components.

Although Bedrock has grown to include many features, some of which are
not found in other web application environments, some interesting and
robust applications can be built with only 7 Bedrock tags and the
built-in objects **$input**, **$header**, **$session**, and **$config**:

```
    <if>
    <null>
    <var>
    <sqlselect>
    <sql>
    <sqlconnect>
    <foreach>
```

# More Information

* [Bedrock Wiki](http://twiki.openbedrock.net)
* [Bedrock Blog](http://openbedrock.blogspot.com)

# History

Starting in December of 2013 the open source project has been revived and
continues to be improved after a long period of inactivity. Version
1.6.4 was released in 2001, and since then most production
environments have been running a variation of that version, usually
with minor modifications.

Such modifications were tagged in CVS as version 1.6.5.

The project has recently been revived to allow it to run on Apache 2.x
version servers (versions through 1.6.5 worked only on Apache 1.3.x).

Subsequent versions will be labled 2.x.x.  Generally speaking version
2.0.x versions only implemented Apache 2 compatibility changes and
were, for the most part, radioactive.  Starting with version 2.1.x,
new functionality and the potential for some incompatibilty existed.
Version 2.2.x represented the first stable Apache 2+ versions.

Version 2.3.x has introduced a host of improvements in the parsers
that have enabled Bedrock to do things like arithmetic and implement a
more respectable <while> loop.  This could be at the expense of some
minor incompatibilities (which should be seen as improvements) in
previous versions of Bedrock.

See the *Prerequisites* section below for other programs that must be
installed and configured on your system before you can install the Bedrock
package.

See the `BUGS` file for information on reporting bugs.

See the `INSTALL` file for installation instructions.

See the `HACKING` file for developer build instructions and the like.

See the `NEWS` file for changes for this release, and a running list of
changes from previous releases. Any incompatibilities with previous versions
will be noted in the 'NEWS' file.

# Prerequisites

Bedrock is intended to be built on Unix and Unix-like systems, so expects a
standard set of utilities (cat, sed, awk, rm, ...) to be present. These
utilities are not explicitly listed below as prerequisites as they should be
present on any modern Unix or GNU/Linux system (or Cygwin, if the Universe
hates you ;-). We also do not explicitly list those Perl modules that are part
of the core library shipped with Perl (e.g., Data::Dumper, MIME::Base64, etc.)

The various Bedrock components are primarily implemented in Perl, so of
course, a Perl installation is needed. Current Bedrock development is done
using Perl 5.8.8, but any 5.8.x+ features that are used should be
conditional. This means that Bedrock should work with versions of Perl prior
to 5.8.x, as well.

*This information may be a bit dated.*

```
    Prerequisite        Version    Required By     URI
    ------------        ---------  -----------     ------------------------------
    Perl 5              >= 5.004   all             ftp://ftp.cpan.org/pub/CPAN/src/perl-5.8.8.tar.gz

    Apache2::Const      ???        all             http://cpan.perl.org/modules/by-module/Apache2
    CGI                 >= 3.29    all             http://cpan.perl.org/modules/by-module/CGI
    DBI                 >= 1.13    all             http://cpan.perl.org/modules/by-module/DBI/
    Date::Calc          >= 4.3     BLMs            http://cpan.perl.org/modules/by-module/Date/
    Getopt::Long        ???        cli tools       http://cpan.perl.org/modules/by-module/Getopt/
    GDBM_File           >= 1.03    BLMs            http://cpan.perl.org/modules/by-module/GDBM_File/
    IO::Stringy         ???        all             http://cpan.perl.org/modules/by-module/IO/
    JSON                ???        all             http://cpan.perl.org/modules/by-module/JSON/
    Net::FTP            >= 2.56    BLMs            http://cpan.perl.org/modules/by-module/Net/
    Net::SMTP           >= 2.15    BLMs            http://cpan.perl.org/modules/by-module/Net/
    Tie::IxHash         ???        cli tools       http://cpan.perl.org/modules/by-module/Term/
    XML::Simple         ???        BLMs            http://cpan.perl.org/modules/by-module/XML/

    Optional
    --------            
    HTML::Scrubber      ???        BLM::Startup::Input  http://cpan.perl.org/modules/by-module/HTML
    IPC::Shareable      ???        Bedrock::Apache::Bedrock http://cpan.perl.org/modules/by-module/IPC
```

If you're installing Bedrock from a Debian `.deb` file or a RedHat
`.rpm` file, you should have success letting the package managers pull
the dependencies for you.  If you insist on doing this the hard way
then you'll need to make sure you have the proper dependencies
installed before proceeding. _Assistance creating a CPAN module would
be welcome._

# Special Note Regarding Apache Versions

Bedrock 2.x has been modified and tested to work primarily in
conjunction with Apache 2.2 and later.  If you *REALLY* want to make
Bedrock 2.x work with previous versions of Apache it can be done,
however please note the following caveats:

- Apache::Bedrock (2) under `mod_perl` 1 will not work as it has been
specifically modified to work with mod_perl 2.  If this becomes an
issue or a grassroots campaign is mounted, a replacement
Apache::Bedrock that works with `mod_perl` 1 may be released in the
future.

- Bedrock running as a CGI should work with no compatibility issues
under Apache 1.x/2.0/2.2.

- To run Bedrock 2.x under Apache 2.0.x you may want to make the
following tweak after configure your site to work with Bedrock:

  - remove the word "virtual" from the `bedrock.conf.in` file found in
`src/main/bedrock/config`.  This is necessary because Apache 2.0 lacks
the `virtual` attribute on the handler and checks for existence
before invoking the handler.  This would result in a 404 error
if the directory did not exist.
```
    Action        bedrock-cgi /cgi-bin/bedrock.cgi virtual
```
  - remove the `tag` directory in the `/bedrock` directory and
replace this with an empty file:

```
    sudo rmdir /var/www/myvhost.com/htdocs/bedrock/tag
    sudo touch /var/www/myvhost.com/htdocs/bedrock/tag
```

# Installing and Configuring a Bedrock Enabled Website

Installing Bedrock __should be__ a simple 2-step process.

1. Install core-Bedrock

  - Download the tar ball and read the 'INSTALL' file or

  - Download the .deb file and use dpkg to install Bedrock and the dependencies

  - Download the .rpm file and use yum to install Bedrock and the
    dependencies

2. Configure your Apache server to enable Bedrock

  - See the 'README.Apache' file.

# Creating a persistent Session Database

Bedrock implements persistent user sessions using an application
plugin called **BLM::Startup::UserSession**.  The reference implementation
installed by Bedrock uses a MySQL database to persist user data.

There are also implementations using PostgreSQL and SQLLite.

To create the database and table necessary to use the Bedrock $session
object, you'll want to do something similar to:

    $ mysqladmin -u root -p create bedrock

    $ cat /usr/share/bedrock/create-session.sql | mysql -u root -p bedrock

See `perldoc /usr/lib/bedrock/perl5/BLM/Startup/UserSession.pm` for
more details.
