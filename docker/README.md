# README

This the README file for describing how to create Docker images
and run a Bedrock enabled Apache server inside a Docker container.

# Overview

This directory contains Docker build and supporting files for building
Docker images based on several distributions described below.

| Distribution | Dockerfile | Description |
| ------------ | ---------- | ----------- |
| Debian | Dockerfile.bedrock-debian-base | Debian distribution (`bookworm`) - base image |
| Debian | Dockerfile.debian | Debian distribution (`bookworm`) |
| Fedora | Dockerfile.bedrock-fedora-base | Fedora distribution (40) - base image |
| Fedora | Dockerfile.fedora | Fedora distribution (40) |
| Amazon Linux | Dockerfile.bedrock-al20230base | Amazon Linux 2023 - base image |
| Amazon Linux | Dockerfile.al2023 | Amazon Linux 2023 |

Each of these Dockerfiles will create a Docker image that includes the
latest verison of Bedrock built specifically for that distribution. To
speed development of Bedrock itself, base images are created for
Debian, Fedora and Amazon Linxu that contain the Apache server
(mod_perl enabled) and the current list of Perl module dependencies.
It can take a relatively long time to build all of the
dependencies. By creating a base image that contains all of the
dependencies minus Bedrock itself it becomes easier to make changes to
Bedrock and test the results.

# CI for Bedrock

See [README-github.md](docker/README-github.md) for details regarding
how to create the Docker image used for continuous integration when
new branches are pushed to GitHub.

# Building the Bedrock Images

A `Makefile` is included in the `docker` directory that will create
Docker images based on various distros described above.  The
Dockerfiles for each of these flavors attempts to build the
dependencies for that environment, each of which have their own way of
building some of them.  Installing the dependencies for the image can
be a lengthy process. You can shortcut building the image and just
install Bedrock or website updates manually inside your container. See
[Bedrock Enabled Apache Website](#bedrock-enabled-apache-website).

The build process will first run `make` from the root of the
repository creating the distribution tarball and a CPAN distribution
that is then used to install Bedrock. Once all of the dependencies are
installed, the make process installs Bedrock. Finally, the
`bedrock-site-install` script is run which installs the Bedrock
enabled Apache website. You can this use this site for developing
Bedrock applications or for exploring Bedrock.

To build an image based on one of these distributions:

```
make {target}
```

Where `{target}` is one of:

* `bedrock-debian`
* `bedrock-fedora`
* `bedrock-al2023`

| Image | Description |
| ----- | ----------- |
| `bedrock-debian` | image based on `debian:bookworm`  |
| `bedrock-fedora` | image based on `fedora:40`        |
| `bedrock-al2023` | image based on `amazonlinux:2023` |

After building and running a Docker container from one of the
images you created, verify that Bedrock is installed working properly.

```
docker run --rm -it bedrock-debian /bin/bash
curl http:://localhost
```

There is a `.env` file for each distribution for use with
`docker-compose`.  To bring up the Bedrock server using
`docker-compose`:

```
docker-compose --env debian.env up
```
or 

```
DOCKERFILE=Dockerfile.fedora DOCKERIMAGE=bedrock-fedora docker-compose up
```

Visit the Bedrock documentation at http://localhost/bedrock to
learn more about Bedrock.

See [Bedrock Documenation](#bedrock-documentation) for more details
regarding how to enable the documentation server. 

# Bedrock Enabled Apache Website

After all of the dependencies have been installed during the `make`
process, the last step to create the complete the image that will be
used by our `docker-compose.yml` configuration is to install Bedrock and
the Apache web site. This is done by building the image by using
either the `Dockerfile.debian`, `Dockerfile.fedora`, or `Dockerfile.al2023`
Dockerfiles. Essentially these Dockerfiles will just add Bedrock to the
image and then run `bedrock-site-install` which creates a Bedrock
enabled Apache environment.

```
cpanm -n -v Bedrock.tar.gz
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

> Hint: If a change is made to Bedrock or the files to be installed
> to enable the Apache website, you can shortcut the image creation
> process. Copy the new Bedrock distribution to the contain Bedrock
> using `cpanm`.

```
docker cp Bedrock-3.2.0.tar.gz docker_web_1:/tmp
cpanm -n -v Bedrock-3.2.0.tar.gz
```

>If necessary run the site installation script
> (`bedrock-site-install`). If new dependencies are added you'll need
> to add those before restarting the web server (`kill -USR1 1`).

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
httpd -t -f /etc/httpd/conf/http.conf && kill -USR1 1
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

The Bedrock documentation page (`/bedrock`) is protected by a Basic
Auth challenge (username: `fred`, password: `bedrock`). The page is
protected by default because it might expose configuration information
if you enabled that in your `tagx.xml` file.

> The reference container is designed to be used in a _local
> development environment_. For production sites, make sure you do not
> include the directives in your Apache configuration which enable
> this URI. One way to achieve that is to edit the environment files
> described below that control the configuration of each image flavor.

# Running the Server Using `docker-compose`

A `docker-compose.yml` file is included that will launch the container
and bring up an Apache webserver listening on port 80. It will also
bring up a MySQL server running on port 3306.

```
cd docker
docker-compose --env bedrock-debian up
```

## Localstack & Redis

The `docker-compose.yml` file also contains the configurations to
bring up a Redis server and the Localstack (AWS emulator)
environments.

These can be enabled using the `--profile` option when you invoke
`docker-compose`.

```
BEDROCK=~/git/openbedrock docker-compose --profile redis --profile localstack up
```

## Bedrock Documentation

By default Bedrock documentation is enabled (See `ALLOW_BEDROCK_INFO`
in `tagx.xml`) however your webserver document directory must have an empty
`/bedrock` directory created. You can then access documentation at
http://localhost:8080/bedrock

# Connecting to the MySQL Server

## Connecting to localhost

To connect to the MySQL server running in the container without using
TCP you need to expose the socket to your host.  The
`docker-compose.yml` file will export mount
`/tmp/mysqld` locally to `/var/run/mysqld` on the container. This will
allow you to connect to the container's MySQL instance on `localhost`.
You must however provide the path to the socket file when connecting.

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

Find the IP address of the MySQL server running in the container:

```
export DBI_HOST=$(docker inspect docker_db_1 | \
 jq -r '.[]|.NetworkSettings.Networks.docker_default.IPAddress')
 
mysql -u root --password=bedrock -h $DBI_HOST
```

# Local Bedrock Development with Docker

## Using a Remote Host

### Creating an SSH Tunnel

If you're doing your development on a remote server that you access
via a bastion host (for example an EC2) and access that server through
a local terminal, you can create an ssh tunnel through the bastion to
your development server.

Typically I connect to my development server (EC2) via a bastion host
using my Chromebook. Running Linux on my Chromebook allows me to use
GNOME terminal to access remote servers.

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
>Chromebook. Access the "Advanced>Developers" settings.  There you can
>configure port forwarding for port 8080.

Additionally, all ports are normally blocked to my EC2 except 22. In this scenario
we open port 80 of my EC2 to the bastion host (only) as well as port 22. Keep
in mind you still want to restrict port 22 on your bastion host to
your local IP address!

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
