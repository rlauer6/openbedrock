This is the README file for the `bedrock` project.

* See [http://twiki.openbedrock.net]() for more information about the
Bedrock framework.
* See the NEWS file changes and updates.

![build badge](https://codebuild.us-east-1.amazonaws.com/badges?uuid=eyJlbmNyeXB0ZWREYXRhIjoiT1JrZzVFMWVTeGV6bGdWejJGQzM3V0UyZEt4RFhlTVVVYnhERHF3cEsrN0NrVFVFcGc0dUxqKzF2Y3JCSElqNnJLa0ZqK083bUhvOGVyVGQ4Z05jU25FPSIsIml2UGFyYW1ldGVyU3BlYyI6Ijk5UlFFb1R6aFNXRFNHTnkiLCJtYXRlcmlhbFNldFNlcmlhbCI6MX0%3D&branch=main)

# Overview

Bedrock is a server side web development framework that can be used
with Apache probably web servers. It allows fullstack web
developers to create dynamic web pages through the use of a small set
of HTML-like tags. Bedrock is an enabling technology that glues
together HTML pages and dynamic data (HTML form data, data from
databases, and system services) to create web applications.

Developers can extend Bedrock in interesting ways through the use of
Perl plugins.

Bedrock differs significantly from most web application development
environments that either generate HTML pages as output (e.g. CGIs,
Servlets) or are themselves programs embedded within HTML pages
(e.g. PHP, Mason, ASP, etc). By allowing the developer to assemble
pages from object oriented components Bedrock allows front-end web
developers and back-end developers to collaborate effectively using
familiar, well documented interfaces.

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

# Installation

## RPM

To install Bedrock from rpm, visit http://repo.openbedrock.net.

## Manual Install

You'll need a few Perl modules installed on your system before you
start, but `configure` will look for them before you can build
Bedrock.

See the [Prerequisites](#prerequisites) section below for other programs that must be
installed and configured on your system before you can install the Bedrock
package.

```
git clone https://github.com/rlauer6/openbedrock.git
cd openbedrock
./bootstrap
./configure --prefix=/usr
make
sudo install
bedrock --version
```

# More Information

* [Bedrock Wiki](http://twiki.openbedrock.net)
* [Bedrock Blog](http://openbedrock.blogspot.com)
* See the `NEWS` file for changes for this release, and a running list of
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
using Perl 5.16, but any 5.8.x+ features that are used should be
conditional. This means that Bedrock should work with versions of Perl prior
to 5.16 as well.

# Ubuntu/Debian

At one time a Debian package was available for Bedrock, however the
packaging scripts have gone out of maintenance.  Volunteers welcome.
I'm going to try to resurrect the Debian packaging scripts and see if
we get a first class package for Ubuntu users.  In the interim, try
the `setup-ubuntu.sh` script or follow the instructions below.

If you want to install Bedrock on Debian based system like Ubunutu,
first satisfy the Bedrock Perl dependencies using `apt` or install
them manually from CPAN.  Here's a list (not guaranteed to be
complete) of the packages you may need to install:

Programs...

* unzip
* automake
* autoconf
* apache2
* make

Perl modules...

* libapache2-mod-perl2-dev
* libperl-AppConfig
* libappconfig-perl
* libcrypt-cbc-perl
* libcrypt-des-perl
* libcgi-pm-perl
* libdbi-perl
* libdate-calc-perl
* libio-stringy-perl
* libipc-shareable-perl
* libjson-perl
* libspreadsheet-parseexcel-perl
* libtext-csv-xs-perl
* libtie-ixhash-perl
* libxml-simple-perl
* librole-tiny-perl

After satisfying dependencies, build and install Bedrock in the
standard Unix way:

```
 $ ./configure --prefix=/usr
 $ make
 $ sudo make install
```

# Performance

* Bedrock running as a CGI should work with no compatibility issues
under Apache 1.x/2.x+
* For increased performance use `mod_perl` with Apache 2.2.

# Creating a persistent Session Database

Bedrock implements persistent user sessions using an application
plugin called **BLM::Startup::UserSession**.  The reference implementation
installed by Bedrock uses a MySQL database to persist user data.

There are also implementations using PostgreSQL and SQLite.

To create the database and table necessary to use the Bedrock $session
object, you'll want to do something similar to:

```
$ mysqladmin -u root -p create bedrock
$ cat /usr/share/bedrock/create-session.sql | mysql -u root -p bedrock
```

## More Information on Sessions

* See `perldoc /usr/lib/bedrock/perl5/BLM/Startup/UserSession.pm` for
more details.

* See [http://twiki.openbedrock.net]() for more helpful hints.
