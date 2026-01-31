This is the README file for the `bedrock` project. This page is mostly
geared toward maintainers. If all you want to do is install Bedrock
visit Bedrock's [DarkPAN repository](https://cpan.openbedrock.net) or
download an image from
[DockerHub](https://hub.docker.com/r/rlauer/openbedrock).


* See the [NEWS](NEWS) file for changes and updates to Bedrock

| Documentation | Description |
| ------------- | ----------- |
| [README.md](README.md) | Overview of Bedrock and this repository |
| [README-CI.md](README-CI.md) | Info on the GitHub Actions build system |
| [README-Apache.md](README-Apache.md) | Info on running Bedrock as an Apache application |
| [README-LOGS.md](README-LOGS.md) | Guide to Bedrock logging |

# Build and Test Status

![build badge](https://github.com/rlauer6/openbedrock/actions/workflows/build.yml/badge.svg)

![build badge](https://codebuild.us-east-1.amazonaws.com/badges?uuid=eyJlbmNyeXB0ZWREYXRhIjoiT1JrZzVFMWVTeGV6bGdWejJGQzM3V0UyZEt4RFhlTVVVYnhERHF3cEsrN0NrVFVFcGc0dUxqKzF2Y3JCSElqNnJLa0ZqK083bUhvOGVyVGQ4Z05jU25FPSIsIml2UGFyYW1ldGVyU3BlYyI6Ijk5UlFFb1R6aFNXRFNHTnkiLCJtYXRlcmlhbFNldFNlcmlhbCI6MX0%3D&branch=master)

# What's New

## 2025-05 - 2026-01

* Significant updates and new features have been added to make
  developing Bedrock applications in local environments easy. A new
  "miniserver" allows developers to quickly test a web application
  without the need for Apache.

### 3.7.3 

The 3.7.3 release marks a significant milestone in the maturity of the
Bedrock::Service module. The primary focus of this release is the
unification of the error-handling lifecycle and a refactoring of
`bedrock-service.cgi` to improve developer experience.

Unified error handing means that whether you are using Bedrock with
Apache and mod_perl or mod_cgi, or Bedrock's miniserver, error
handling is as robust as it can possibly be. If you are using
Bedrock::Service to create services you also get the benefit of
helpful error pages when you are parsing Bedrock content.

### 3.7.2 

The 3.7.2 release introduces several enhancements to the
Bedrock::Service framework, specifically targeting mod_cgi
compatibility, API detection, and improved error handling for web
services.

### 3.7.1

Bedrock 3.7.1 represents a major architectural refactor of
bedrock-miniserver.pl, reducing code size by approximately 15% while
improving modularity and performance. Several new features have also
been introduced in the miniserver.

### 3.7.0

Bedrock 3.7.0 represents a significant architectural improvement in
error handling and system stability. This release unifies the error
reporting pipeline across Apache/mod_perl and the Bedrock Miniserver,
ensuring consistent behavior when rendering custom error templates.

### 3.6.8

Bedrock 3.6.8 is a minor release that includes minor bug fixes and
documementation updates.

### 3.6.7

Bedrock 3.6.7 significantly enhances the Miniserver's "Accelerator Mode,"
transforming it into a fully capable development environment for Bedrock
templates. This release introduces robust environment simulation, ensuring
that static .roc files have access to standard Bedrock objects like
$session, $config, and $bedrock. It also improves logging observability
and error reporting.


### 3.6.6

Bedrock 3.6.6 introduces a multi-tenant architecture to the standalone 
miniserver, allowing multiple services to be mounted and routed 
simultaneously. This release also adds introspection capabilities to 
the core Service class and advanced route rewriting features.

### 3.6.5

Bedrock 3.6.5 focuses on hardening the standalone miniserver with
improved routing logic and custom error page support. This release
also enhances the generic service wrapper to support CLI delegation
and improves the standard Autocomplete service.

### 3.6.4

Bedrock 3.6.4 focuses on improving the local development lifecycle by 
introducing persistent sessions for the standalone miniserver. This 
release also addresses critical environment handling issues in the test 
harness and fixes session initialization logic in the core service class.

### 3.6.3

Bedrock 3.6.3 focuses on Developer Experience (DX), specifically improving 
the logging and instrumentation of the standalone miniserver. It introduces 
context-aware logging timestamps and granular performance profiling.

### 3.6.2

Bedrock 3.6.2 allows for significant performance optimization of the 
documentation service and caching layer, while also addressing several 
stability bugs in the development miniserver and shared memory driver.

### 3.6.1

Bedrock 3.6.1 introduces the Bedrock Miniserver, a lightweight standalone 
HTTP server that removes the dependency on a local Apache installation for 
development. This release also hardens the caching infrastructure against 
shared memory corruption and improves the resilience of the documentation 
service.

### 3.6.0

Bedrock version 3.6.0 is a non-breaking version that introduces a new
layer (Bedrock::Service) used to create "Modulino" style CGI scripts or
mod_perl handlers. This new layer replaces the deprecated Bedrock::CGI
class and better aligns script-based services with the Apache::Bedrock
lifecycle. The documentation server has been completely rewritten as
Bedrock::Service::Docs, serving as the first validation of this new model.

Significant improvements were also made to the caching engine. Bedrock now
intelligently handles serialization—delegating it to the engine (like
IPC::Shareable) when supported—and includes a critical patch to prevent
shared memory segment proliferation.

### 3.5.x

Bedrock version 3.5.x is a non-breaking version that introduces path based
routing. Paths can now be specified in the configuration' 'routes`
object that allows you to map URI pretty paths to Bedrock files.

### 3.4.x

Bedrock version 3.4.x is a non-breaking version that introduces a new
<cache> tag. Caching is now done using an extensible caching framework
based on Bedrock::Cache. Included in 3.4.0 is a reference
implementation using Redis. Version 3.4.1 cleans up and aligns
Bedrock's configuration caching using the new framework. It also includes
a caching engine base on IPC::Shareable.

### 3.3.x

Bedrock version 3.3.x is non-breaking version that includes a limited
number of enhancements and small bug fixes. The most noteworthy change
is a much more robust Docker image creation facility. Bedrock is now
on Dockerhub!

## 2025-05

* Download Bedrock the [DarkPAN repository](https://cpan.openbedrock.net).

## 2025-04

* Bedrock images are now available on dockerhub. [Try Bedrock
now!](https://hub.docker.com/r/rlauer/openbedrock)
* `Bedrock::Lite` - all the flavor, 1/3 less calories
  - A version of Bedrock without Apache. Useful for basic templating
    and daemons that need some of Bedrock's goodies.

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
---

> Bedrock is under constant development as it serves as the engine
> that powers [Treasurer's
> Briefcase](https://www.treasurersbriefcase.com)

---

> Note that if all you want to do is try Bedrock

# Running Bedrock in a Shell

Bedrock can also be run in a shell as a templating engine.

```
echo '<trace --output $env>' | bedrock
echo 'Bedrock says <var $input.text>' | bedrock text='Hello World!'
```

# Installation

Presumably you are installing Bedrock to do some web application
development on an Apache server. There are three basic ways to install
Bedrock to enable Bedrock on your Apache server.

First, clone the repo and make sure you have installed all of the
necessary prerequistes.

```
git clone https://github.com/rlauer6/openbedrock.git
```

The `configure` script generated by `autoconf` will check to see if
you have the necessary prerequisites before the build is started. 

See the [Prerequisites](#prerequisites) section below for a listing of
resources that must be installed and configured on your system before
you can install the Bedrock package.

> Caveat Emptor: Bedrock is under constant development so the list of
> required Perl modules that `configure` will look for may not be
> complete.

Run `./configure --help` in the project directory to see the options
available.

Presumably you are installing Bedrock to create a web application that
will run on an Apache server. There are three basic ways to enable
Bedrock on your Apache server. Here's a generalized description of
these methods:

1. The standard `autoconf` recipe:
   ```
   ./bootstrap
   ./configure
   make && make install
   ```
2. From a CPAN distribution tarball
   ```
   ./bootstrap
   ./configure
   make
   cd cpan
   make cpan
   sudo cpanm -v Bedrock-3.3.6.tar.gz
   ```
3. From RPM packages
   ```
   ./bootstrap
   ./configure
   make dist
   rpmbuild -tb bedrock-3.3.6.tar.gz
   rpm -ivh $RPMROOT/RPMS/noarch/bedrock-openbedrock-3.3.6-0.noarch.rpm
   ```

> Installing Bedrock using the standard `autoconf` recipe will not
> install things in quite the same way the CPAN distribution tarball
> method will.

## The standard `autoconf` recipe

```
git clone https://github.com/rlauer6/openbedrock.git
cd openbedrock
./bootstrap
./configure --prefix=/usr
make && sudo make install
bedrock --version
```

## From a CPAN distribution tarball

>Bedrock is not and may never be, uploaded to CPAN. However
>installling from a distribution tarball s now the preferred way of
>installing Bedrock. Vist Bedrock's
>[DarkPAN](https://cpan.openbedrock.net) to download the latest
>tarball.

Installing Bedrock using the tarball installs all of the necessary
components to enable Bedrock on your Apache server. To finalize the
installation you must run the `bedrock-site-install` script. See `man
bedrock-site-install.pl` for more information about what that script
does how to customize it for your site.

### Prerequisites

In addition to the prerequistes for manually installing Bedrock you
will also need some of the artifacts listed below for building the
CPAN tarball and Docker images. Bedrock is under constant development
so you might want to look at the Dockerfiles for your particular
environment to see all of the necessary libaries and artifacts
required.

Distribition | Dockerfile | 
------------ | ---------- |
Amazon Linux | [Dockerfile.bedrock-al2023-base](docker/Dockerfile.bedrock-al2023-base)
Debian | [Dockerfile.bedrock-debian-base](docker/Dockerfile.bedrock-debian-base)
Fedora | [Dockerfile.bedrock-fedora-base](docker/Dockerfile.bedrock-fedora-base)

*Other Prerequisites*

* [`cpanminus`](https://metacpan.org/pod/App::cpanminus)
* `CPAN::Maker`
* Apache
* `mod_perl`
* MySQL
  - client libraries
  - `DBD::mysql`
* ...and other Perl modules specified in Bedrock's CPAN distribution

Follow the instructions below to create a distribution tarball.

```
./bootstrap
./configure --prefix=/usr
cd cpan
make cpan
```

After running the above recipe you should have a tarball in the `cpan`
directory.

```
tar xfvz Bedrock-*.tar.gz
cd Bedrock-*.tar.gz
perl Makefile.PL
make && make install
```

or

`cpanm -v Bedrock*.tar.gz`

## From RPM packages

> rpm builds are likely not working properly at the moment. Current
> efforts have been directed at creating a CPAN distribution and
> Docker images. This functionality may be revisited in the
> future. The major problem with an rpm build is that Perl has become
> so out of vogue with the kids that essential rpm packages cannot be
> found in any yum repository. That leaves you with two options if you
> want to build your applications using rpms (neither of which are
> very satisfying).
1. Build your required rpms on your own...which I had been doing for a
   LONG time.
2. Package the rpm in such a way that it ignores dependencies and
   essentially becomes, for all intents and purposes a CPAN tarball.

### Differences Between the CPAN Distribution and Manual Installation

The manual installation method assumes you are trying to install all
of the components of Bedrock in order to create a web application
using an Apache server. However, rather than directly installing these
components in your web directories, the installation process stages
the components in the directory you configured as `datadir` under the
`/bedrock` subdirectory. So if you did this:

`./configure --prefix=/usr`

You will find all of the components necessary for running a Bedrock
enabled web server under `/usr/share/bedrock`.

Installing Bedrock from the CPAN distribution will install Bedrock
where you would expect them to be installed using a CPAN installation
method. After installing Bedrock from the CPAN distribution you can
use all of the Perl modules in Bedrock for templating or use the
command line version of Bedrock (`bedrock`).

```
echo '<trace --output $config>' | bedrock
```

Whether you manually install Bedrock or use the CPAN distribution the
additional files that make up the web framework are installed are not
automatically installed into your web application hierarchy.

A separate utility (`bedrock-site-install`) is included for
configuring and finalizing your web environment.  You typically would
run this utility after after installing Bedrock. The utility takes an
argument that indicates the type of your system (Redhat vs Debian) so
it will install components into the correct locations for that
distribution.

See `man bedrock-site-install` for more details.

### Why Isn't Bedrock on CPAN

There are many good templating modules (e.g. `Template::Toolkit`,
`Mason`, `HTML::Template`) that are well supported by the Perl
community. Newer web application frameworks like Mojolicious are
rapidly replacing the use of templating packages alone as a web development
framework. Bedrock was born in the late 90's when other solutions
were being born as well.  It was used (and is still used today) by the
company that funded its development.

Bedrock has been proven to be extremely useful for prototyping, rapid
application development and anything that needs a solid templating
enviroment. Give it a try! Feedback welcome!

## Tests

Bedrock includes a comprehensive set of tests that exercise the tags
as well as the Perl modules that implement Bedrock. Bedrock uses
`Test::More` and its own testing framework. To run the full suite of
tests requires a MySQL server being available.  If no server is
available those tests that require MySQL will be skipped.

See the README files is the [`perl`](src/main/perl/lib/README.md) and
[`perl/lib`](src/main/perl/lib/README.md) directories for more
information on testing Bedrock.

# Trying Bedrock with Docker

You can build a Docker image and try Bedrock in a local
environment. See the README file in the [`docker`](docker/README.md) directory for more
information about build a Docker image for different distros.

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

_Ubuntu support via Debian __packages__ will likely never happen, however 
Bedrock will run on Ubuntu using the manual installation
method or as a CPAN distribution._

At one time a Debian package was available for Bedrock, however the
packaging scripts have gone out of maintenance. Using Debiain packages
is likely to run into the same limitations as using rpms - a dirth of
necessary modules (although there do seem to be more people creating
`.deb` versions of Perl modules). 

Volunteers welcome! Take a look at the `setup-ubuntu.sh` script as a
starting point.

Perl module dependencies are listed in the `configure.ac` file. Some
are marked as optional although you may need to have them installed to
build the distribution. While you may be able to load these modules
from Debian repositories, using `cpanm`
[https://metacpan.org/pod/App::cpanminus](`App::cpanminus`) is
preferable as it will get you the latest version of these modules.

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
* For increased performance use `mod_perl` with Apache 2.2/2.4.

# Creating a Persistent Session Database

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
