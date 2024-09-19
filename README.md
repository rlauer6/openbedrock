This is the README file for the `bedrock` project.

* See the NEWS file for changes and updates to Bedrock

# Build and Test Status
![build badge](https://github.com/rlauer6/openbedrock/actions/workflows/build.yml/badge.svg)

# RPM Build Status

![build badge](https://codebuild.us-east-1.amazonaws.com/badges?uuid=eyJlbmNyeXB0ZWREYXRhIjoiT1JrZzVFMWVTeGV6bGdWejJGQzM3V0UyZEt4RFhlTVVVYnhERHF3cEsrN0NrVFVFcGc0dUxqKzF2Y3JCSElqNnJLa0ZqK083bUhvOGVyVGQ4Z05jU25FPSIsIml2UGFyYW1ldGVyU3BlYyI6Ijk5UlFFb1R6aFNXRFNHTnkiLCJtYXRlcmlhbFNldFNlcmlhbCI6MX0%3D&branch=master)

# Overview

Bedrock is a server side web development framework that can be used
with Apache (and probably other web servers). It allows fullstack web
developers to create dynamic web pages through the use of a small set
of HTML-like tags that implement a robust templating system. Bedrock
is an enabling technology that glues together HTML pages and dynamic
data (HTML form data, data from databases, and system services) to
create web applications.

Developers can extend Bedrock in interesting ways through the use of
Perl plugins.

Bedrock differs significantly from most web application development
environments that either generate HTML pages as output (e.g. CGIs,
Servlets) or are themselves programs embedded within HTML pages
(e.g. PHP, Mason, ASP, etc). By allowing the developer to assemble
pages from object oriented components, Bedrock allows front-end web
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

# Running Bedrock in a Shell

Bedrock can also be run in a shell as a templating engine.

```
echo '<trace --output $env>' | bedrock
echo 'Bedrock says <var $input.text>' | bedrock text='Hello World!'
```

# Installation

## RPM

To install Bedrock from rpm, visit http://repo.openbedrock.net.

## Manual Install

You'll need a few Perl modules installed on your system before you
start, but `configure` will look for them before and let you know if you can build
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

## Installing as a CPAN Distribution

_Experimental_

>>Bedrock is not and may never be uploaded to CPAN, however it is
>possible to create a distribution tarball capable of being installed
>using `cpanm`.

### Prerequisites

In addition to the prerequistes for manually installing Bedrock you
will also need the artifacts listed below.

* `Pod::Checker`
* [`make-cpan-dist`](https://github.com/rlauer/make-cpan-dist.git)

Follow the instructions below to create a distribution tarball.

```
./bootstrap
./configure
cd cpan
make cpan
```
After running the above recipe you should have a tarball in the `cpan`
directory.

```
tar xfvz Bedrock-3.3.0.tar.gz
cd Bedrock-3.3.0.tar.gz
perl Makefile.PL
make && make install
```

### Differences Between the CPAN Distribution and Manual Installation

The manual installation method assumes you are trying install all of
the components of Bedrock in order to create a web application.
Accordingly, a manual install will by default, install an Apache
virtual host and all of the necessary Apache configuration files
automatically. Using the CPAN distribution tarball will install the
core Bedrock system modules that will allow you to use Bedrock as a
templating engine programmatically (using Perl modules) or using the
command line (`bedrock.pl`).

Additional files that make up the web framework are included in the
distribution but are not installed into your web application
hierarchy.

A separate utility is included for configuring your web environment
that should be run after installing Bedrock from the distribution
tarball.

See `man bedrock-web` for more details.

### Why Isn't Bedrock on CPAN

There are many good templating modules (e.g. Template::Toolkit,
Mason, HTML::Template) that are well supported by the Perl
community. Newer web application frameworks like Mojolicious are
rapidly eplacing the use of templating packages as a web development
framework. Bedrock was born in the late 90's when other solutions
were being born as well.  It was used and is still used today) by the
company that funded its development.

## Testing the Installation

There are some tests you can run that will exercise Bedrock tags and
other Perl modules.  After installing all of the pre-requisites and
installing Bedrock, try:

```
cd src/main/perl
make test
```

...and

```
cd src/main/perl/lib/
make test
```

# More Information

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
using Perl 5.16, but any 5.10.x+ features that are used should be
conditional. This means that Bedrock should work with versions of Perl prior
to 5.16 as well.

Here's a list (not guaranteed to be complete) of the packages you may
need to install:

* `automake`
* `autoconf`
* `apache2`
* `make`

# Ubuntu/Debian

_Ubuntu support via Debian packages will likely never happen, however we
believe Bedrock will run on Ubuntu using the manual installation methods._

At one time a Debian package was available for Bedrock, however the
packaging scripts have gone out of maintenance.  Volunteers welcome.
I'm going to try to resurrect the Debian packaging scripts and see if
we can get a first class package for Ubuntu users.  In the interim, take a
look at the `setup-ubuntu.sh` script as a starting point.

If you want to install Bedrock on Debian based system like Ubunutu,
first satisfy the Bedrock Perl dependencies using `apt-get` or install
them manually from CPAN.

Perl module dependencies are listed in the `configure.ac` file. Some
are marked as optional although you may need to have them installed to
build the distribution. While you may be able to load these modules
from Debian repositories, using `cpanm` [https://metacpan.org/pod/App::cpanminus](`App::cpanminus`) is
preferable as it will get you the latest version of these modules.

After satisfying dependencies, build and install Bedrock in the
standard Unix way:

```
 $ ./configure --prefix=/usr
 $ make
 $ sudo make install
```

# Testing

There is a comprehensive set of unit tests that test Bedrock and many
of the classes that make up Bedrock.  See the `README.md` files in
`src/main/perl` and `src/main/perl/lib` for details on testing your
Bedrock installation.

# Performance

* Bedrock running as a CGI should work with no compatibility issues
under Apache 1.x/2.x+
* For increased performance use `mod_perl` with Apache 2.2/2.4.

# Creating a persistent Session Database

Bedrock implements persistent user sessions using an application
plugin called **BLM::Startup::UserSession**.  The reference implementation
installed by Bedrock uses a MySQL database to persist user data.

There are also implementations using PostgreSQL, SQLite and even Redis.

To create the database and table necessary to use the Bedrock `$session`
object, you'll want to do something similar to:

```
$ cat /usr/share/bedrock/create-session.sql | mysql -u root -p bedrock
```

## More Information on Sessions

* See `perldoc BLM::Startup::UserSession` for
more details.

