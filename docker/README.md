# README

This the README file for describing how to create Docker images
and run a Bedrock enabled Apache server inside a Docker container.

# Overview

This directory contains Docker build and supporting files for building
Docker images based on several distributions described below.

| Distribution | Dockerfile | Description |
| ------------ | ---------- | ----------- |
| Debian | Dockerfile.debian-base | Debian distribution (`trixie`) - base image |
| Debian | Dockerfile.debian | Debian distribution (`trixie`) |
| Fedora | Dockerfile.fedora-base | Fedora distribution (42) - base image |
| Fedora | Dockerfile.fedora | Fedora distribution (42) |
| Amazon Linux | Dockerfile.al2023-base | Amazon Linux 2023 - base image |
| Amazon Linux | Dockerfile.al2023 | Amazon Linux 2023 |

Each of these Dockerfiles will create a Docker image that includes the
latest verison of Bedrock built specifically for that distribution. To
speed development of Bedrock itself, base images are created for
Debian, Fedora and Amazon Linux that contain the Apache server
(`mod_perl` enabled) and the current list of Perl module
dependencies. The base images *do not* contain Bedrock.

It can take a relatively long time to build all of the
dependencies. By creating a base image that contains all of the
dependencies minus Bedrock itself it becomes easier to make changes to
Bedrock and test the results.

## Adding New Dependencies

1. Edit the `cpanfile` and add a line like:
   ```
   requires "Foo::Bar", "0.01";
   ```
2. Run `carton` as root...see note below
   ```
   sudo PERL5LIB=$PERL5LIB  $(command -v carton) install
   ```
3. Build the base images and the Bedorck Apache images
   ```
   for a in debian fedora al2023; do \
     make $a-base && make $a; \
   done
   ```
4. Go get a cup of coffee...this will take some time!

> You need to run `carton` as root because building `Apache2::Request`
> needs to build `libapreq2` which by default gets installed in
> directories owned by root. There is probably a way to prevent this,
> however I have tried --prefix= with no success and it seems to have
> some hard coded install paths.

# CI for Bedrock

See [README-github.md](docker/README-github.md) for details regarding
how to create the Docker image used for continuous integration when
commits are pushed to GitHub. Builds may fail in the GitHub Actions
even if they succeed in a local environment if the local environment
is different that the CI container. You can debug the GitHub build by
using the `bedrock-test` container locally.

```
docker run --rm -it bedrock-test /bin/bash
```

...then inside the container:

```
./build-github
```

# Building the Bedrock Images

A `Makefile.am` is included in the `docker` directory that will create
Docker images based on various distros described above.  The
Dockerfiles for each of these flavors attempts to build the
dependencies for that environment, each of which have their own way of
building some of them.  Installing the dependencies for the image can
be a lengthy process. You can shortcut building the image and just
install Bedrock or website updates manually inside your container. See
[Bedrock Enabled Apache Website](#bedrock-enabled-apache-website).

## Build Process Steps

Since you are reading the `README` in the `docker` directory you are
presumably interested in creating Docker images for running a Bedrock
website. The latest releases of the images can be found in
[dockerhub](https://hub.docker.com/r/rlauer/openbedrock).

The `Makefile.am` here will create Docker images for three
Linux distributions:

| Image | Description |
| ----- | ----------- |
| `bedrock-debian` | image based on `debian:trixie`  |
| `bedrock-fedora` | image based on `fedora:42`        |
| `bedrock-al2023` | image based on `amazonlinux:2023` |

When you run `make` in the `docker` directory it will run create a
CPAN distribution that is then used to install Bedrock on each image.

To create the images:

```
make && make images
```

`make images` will create the base images which include all
dependencies for building Bedrock for each of the supported
distributions. After the base images are created it will create the
final images by installing Bedrock in the base image and running the
`bedrock-site-install` script that installs and configures the
Bedrock enabled Apache website.

You can use this site for developing Bedrock applications or for
exploring Bedrock.

To build an image based on just one of the Linux distributions:

```
make && make {target}
```

Where `{target}` is one of:

* `debian`
* `fedora`
* `al2023`

After building and running a Docker container from one of the
images you created, verify that Bedrock is installed and working properly.

```
docker run -d -p 80:80 bedrock-debian
curl http:://localhost/itworks.rock
```

## Docker Compose

This directory also contains a `docker-compose.yml` file you can use
to bring up a LAMB (Linux/Apache/MySQL/Bedrock) stack.


```
OS=debian DOCKERIMAGE=bedrock-$OS DOCKERFILE=Dockerfile.bedrock-$OS \
  docker compose up
```

Once your stack is launched visit the Bedrock documentation at
http://localhost/bedrock to verify installation and learn more about
Bedrock. The site is protected with Basic Authentication, username is
`fred`, password is `flintstone`.


See [Bedrock Documenation](#bedrock-documentation) for more details
regarding how to enable or disable the documentation server. 

## LocalStack & Redis

The `docker-compose.yml` file also contains the configurations to
bring up a Redis server and the
[LocalStack](https://www.localstack.cloud/) (AWS emulator)
environments.

These can be enabled using the `--profile` option when you invoke
`docker-compose`.

There are Bedrock plugins for working with AWS services. Redis can be
used for session management, caching and other applications using
Bedrock plugins.

```
docker-compose --env debian.env --profile redis --profile localstack up
```

# Bedrock Enabled Apache Website

After the base image containing all of Bedrock and Apache's
dependencies have been installed the final image is created. During
that creation the Apache environment is finalized and a Bedrock
enabled website is installed using the `bedrock-site-install`
script. Essentially the final image is produced like this:

```
cpanm -n -v Bedrock-Core-m.n.r.tar.gz
cpanm -n -v Bedrock-m.n.r.tar.gz
bedrock-site-install --distro=redhat
```

The install script will use the environment file for the version of
Apache (default 2.4) and the distribution (redhat or debian) chosen to
configure the installation process using the Bedrock `site-config.inc`
file.

| File | Description | Configured By |
| ---- | ----------- | ------------- |
| apache22-env-debian | Apache 2.2 for Debian configuration | manually |
| apache24-env-debian | Apache 2.4 for Debian configuration | manually |
| apache22-env-redhat | Apache 2.2 for Redhat configuration | manually |
| apache24-env-redhat | Apache 2.4 for Redhat configuration | manually |
| site-config.inc | Site configuration | `apache2x-env-{distro}` | 
| bedrock.conf.roc | Bedrock's Apache configuration template | `site-config.inc` |
| bedrock-manifest.roc | Files to be installed by the `bedrock-site-install` | `site-config.inc` |

> Hint: If a change is made to Bedrock or the files to be installed to
> enable the Apache website, you can shortcut the image creation
> process. Copy the new Bedrock distribution to the container and
> install Bedrock using `cpanm`.

```
docker cp Bedrock-3.3.13.tar.gz docker_web_1:/tmp
```

...then inside the container:

```
cpanm -n -v Bedrock-3.3.13.tar.gz
```

>If necessary run the site installation script
> (`bedrock-site-install`). If new dependencies are added you'll need
> to add those before restarting the web server (`apachectl graceful`).

Using the distribution environment file (e.g. `apache24-env-debian`)
and the site configuration (`site-config.inc`), the installation
script customizes the configuration files described below.

## `bedrock.conf`

The `bedrock.conf` file is copied to your Apache configuration
directory. This file essentially _Bedrock enables_ your site.  It uses
the values in the `site-config.inc` file to configure the final
`bedrock.conf` file from the `bedrock.conf.roc` file. If you make
changes to this file while running your container, be sure to test
your configuration before restarting the server.

```
httpd -t -f /etc/httpd/conf/http.conf && apachectl graceful
```

> Warning: If you do not test the configuration first and an error
> occurs the container will exit since Apache is run as process 1.

## `tagx.xml`

This is Bedrock's configuration file.  It controls the various
paths and features enabled for your Bedrock site.

## `mysql-session.xml`

This file configures the `BLM::Startup::UserSession` plugin which
implements persistent sessions based on a MySQL table. It
contains the basic plugin configuration directives and the database
configuration for the container environment.

## `data-sources.xml`

Likewise this file contains a database configuration for the database
running inside the container environment.

## Bedrock Documentation

By default Bedrock documentation is enabled (See `ALLOW_BEDROCK_INFO`
in `tagx.xml`) however your webserver document directory must have an
empty `/bedrock` directory created (this was done for you by
`bedrock-site-install`). You can then access documentation at
http://localhost:8080/bedrock

The Bedrock documentation page (`/bedrock`) is protected by a Basic
Auth challenge (username: `fred`, password: `bedrock`). The page is
protected by default because it might expose configuration information
if you enabled that in your `tagx.xml` file.

> The reference container is designed to be used in a _local
> development environment_. For production sites, make sure you do not
> include the directives in your Apache configuration which enable
> this URI. Edit the appropriate environment file
> (e.g. apache24-debian.env) and set `BEDROCK_DOCS_ENABLED` to *Off*
> then re-run `bedrock-site-install`.

# Connecting to the MySQL Server

To connect to the MySQL server running in your container
environment follow the instructions below.

## Connecting to `localhost`

To connect to the MySQL server running in the container without using
TCP you need to expose the socket to your host.  The
`docker-compose.yml` file will mount `/tmp/mysqld` locally to
`/var/run/mysqld` on the container. This will allow you to connect to
the container's MySQL instance on `localhost`.  You must provide the
path to the socket file when connecting.

```
mysql -u root -p -h localhost -S /tmp/mysqld/mysqld.sock
```

Using DBI:

```
use DBI;

  my %mysql_options = (
    host         => $ENV{DBI_HOST},
    mysql_socket => $ENV{DBI_SOCKET},
    database     => $ENV{DBI_DB},
  );
 
  my $dsn = 'dbi:mysql:';
  $dsn .= join q{;}, map { "$_=" . $dsn_options{$_} } keys %mysql_options;

  my $dbi = DBI->connect($dsn, $user, $password);

```

## Connecting via TCP

Use 127.0.0.1 or find the IP address of the MySQL server running in the container:

```
export DBI_HOST=$(docker inspect bedrock_db_1 | \
 jq -r '.[]|.NetworkSettings.Networks.docker_default.IPAddress')
 
mysql -u root --password=bedrock -h $DBI_HOST
```

# Bedrock Application Development

## Using a Remote Host

If you're doing your development on a remote server that is not
publicly accessible (but accessible to you via ssh) and you want to
view your application in your local browser you'll need to setup an
ssh tunnel.

### Creating an SSH Tunnel

Typically I connect to my development server (EC2) via a bastion host
using my Chromebook. Running Linux on my Chromebook allows me to use
terminal programs like GNOME `terminal` or `terminator` to access
remote servers.

My EC2 development server is behind a firewall accessible only from
the bastion host in the same subnet.  The bastion host is accessible
__only__ from my home's IP address.

The goal is to run a Docker container _on my development EC2 instance_
exposing port 80 to my bastion host while using an ssh tunnel through
the bastion host whenever my local browser on my Chromebook accesses
port 8080.  The setup Looks something like this...

```
   +--------------+    +--------------+    +--------------+
   | Chromebook   |    | Bastion Host |    |     EC2      |
   |              | 22 |              | 22 |              |
   |   8080:22----+----+--> 22 -> 80 -+----+-> 80:docker  |
   |     |        |    |              | 80 |              |
   +-----+--------+    +--------------+    +--------------+
         ^
         |
         |
+--------+----------------------+
| http://localhost:8080/bedrock |
+-------------------------------+

```

>Note: By default Chrome on your Chromebook is unable to access ports
>opened in your Linux container.  You must configure your Chromebook
>for port forwarding. Do this by going to the settings menu on your
>Chromebook. Go to the setting menu on your Chromebook, then click on
>_About ChromeOS_. In the Developers section click on _Linux development
>environment_. Click on _Port forwarding_. Enable 8080 port forwarding.

Additionally, all ports are normally blocked to my EC2 except
port 22. In this scenario we open port 80 of my EC2 to the bastion
host (only) as well as port 22. Keep in mind you still want to
restrict port 22 on your bastion host to your local IP address!

To bring up the tunnel I use the command below in Linux running on my
Chromebook.

```
ssh -i ~/.ssh/id_rsa -f -N -L 8080:$REMOTE_IP:$REMOTE_PORT $REMOTE_USER@$REMOTE_BASTION -v 
```

*Explanation:*

* -i identity file
* -f put ssh in the background
* -N do not execute any commands (just forward port)
* -L local port, remote ip and port to forward to
* -v verbose mode
* $REMOTE_IP - IP address of my EC2 10.x.x.x
* $REMOTE_PORT - 80
* $REMOTE_USER - remote user used to access bastion host
* $REMOTE_BASTION - public IP of the bastion host

Here's the helper script that accomplishes the same thing:

```
#!/bin/bash

BASTION=xx.xx.xx.xx
REMOTE_IP=10.1.4.191
USER=ec2-user
REMOTE_PORT=80
LOCAL_PORT=8080

ssh -i ~/.ssh/id_rsa -f -N -L $LOCAL_PORT:$REMOTE_IP:$REMOTE_PORT $USER@$BASTION -v
```

_or use the `web-tunnel` script in this directory._

```
./web-tunnel -u ec2-user -i 10.1.4.191 -b xx.xx.xx.xx -p 80 -l 8080 up
```

..to stop port forwarding

```
./web-tunnel -O cancel -u ec2-user -i 10.1.4.191 -b xx.xx.xx.xx -p 80 -l 8080 up
```

# Installing from RPMs

> Note: Using RPMs for installing Bedrock is currently broken
>primarily due to missing Perl module dependencies. This may be
>corrected in the future by forcing the RPM build process to ignore
>module dependencies and either create an install process that loads
>the requirements from CPAN or requires a separate process for
>satisfying Bedrock module requirements. The comments below will only
>be relevant once the RPM dependency issue has been corrected!

The Bedrock Docker image can be built by installing the *Bedrock rpms*
from the Bedrock repo to an Amazon Linux image.

> Let me repeat that ...__from the Bedrock repo__...did you re-build
> Bedrock and create the rpms? If you've forgotten how to do that 
> try running `./build -h`  in the project root directory. __This is
> only available to maintainers with access to the AWS resources that
> implement the yum repo.__

Add the Bedrock repository configuration shown below to `/etc/yum.repos.d`.

 curl -fO http://repo.openbedrock.net/bedrock.repo
 
or add it manually

```
[bedrock]
name=bedrock
enabled=1
gpgcheck=1
gpgkey=http://repo.openbedrock.net/RPM-GPG-KEY-openbedrock.org
baseurl=http://repo.openbedrock.net
```

## Bedrock RPM Listing

>> Note that some modules are dependent on other modules and will be
>> installed automatically by `yum` or `dnf`.

| RPM | Description |
| openbedrock | virtual package that will multiple RPMs |
| bedrock.noarch | all of Bedrock |
| bedrock-cloud.noarch | Bedrock modules for use with AWS S3 |
| bedrock-core.noarch | Core Bedrock |
| bedrock-docs.noarch | Bedrock documentation |
| bedrock-mysql-session.noarch | MySQL session manager |
| bedrock-objects.noarch | Berock::Hash, Bedrock::Array, etc. |
| bedrock-orm.noarch | Bedrock::Model for MySQL |
| bedrock-plugins.noarch | Bedrock plugins |
| bedrock-plugins-oauth2.noarch | OAuth2 applictation plugin |
| bedrock-postgres-session.noarch | Postgres session manager |
| bedrock-redis-session.noarch | Redis session manager |
| bedrock-server.noarch | Web server components for enabling Bedrock as a request handler |
| bedrock-session.noarch | Base classes for implementing persistent sessions |
| bedrock-shell.noarch | Command line access to Bedrock |
| bedrock-template.noarch | Bedrock classes for templating in scripts |
| bedrock-test.noarch | Bedrock testing |
| bedrock-utils.noarch | Miscellaneous utilities |
| bedrock-website.noarch | Configuration files for Apache, etc. |
