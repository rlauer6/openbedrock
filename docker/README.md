# README

Makefile for creating a Docker image for Bedrock.

# Building the Image

The Bedrock Docker image is built by installing the *Bedrock rpms* from the
Bedrock repo to an Amazon Linux 2 image.

> Let me repeat that ...__from the Bedrock repo__...did you re-build
> Bedrock and create the rpms? If you've forgotten how to do that 
> try running `./build -h`  in the project root directory.

The image implements an Apache based web server environment you can
use for development.

Before you build the image take a look at these files as they have
been customized for the Docker environment:

* `perl_bedrock.conf.in`
   * basic Bedrock Apache configuration
   * to stream logs to STDOUT (console) set the environment variable
     STREAM_LOGS to any value - example `STREAM_LOGS=1 make docker-image`
* `mysql-session.xml.in`
  * configuration for `BLM::User::Session`
  * to specify a database other than `bedrock` set the environment
    variable DBI_DB
  * to specify a user other than `fred` set the environment variable
    DB_USER 
  * to specify a password other than `flintstone` set the environment variable
    DB_PASS 
  * to specify a host other than `docker_db_1` set the environment variable
    DB_DB
* `data-sources.xml.in`
  * data source configuration used by `<sqlconnect>`
  * set environment variables as describe above to
    `mysql-session.xml.in`
* `httpd.conf.in`
  * basic Apache configuration
* `tagx.xml.in`
  * Bedrock configuration

To build the image:

```
make realclean
make docker-image
```

# Running the Server

A `docker-compose.yml` file will bring up the web server listening on
port 80. It will also bring up a MySQL server running on
port 3306. Disable the service and update `mysql-session.xml` and
`data-sources.xml` to use a different database server.

```
BEDROCK=~/git/openbedrock docker-compose up
```

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

>>Note: Chrome on your Chromebook is unable to access ports opened in
your Linux container.  You must configure your Chromebook for port
forwarding. Do this by going to the settings menu on your
Chromebook. Access the "Advanced>Developers" settings.  There you can
configure port forwarding for port 8080.

Additionally, all ports are normally blocked to my EC2 except 22. In this scenario
we open port 80 of my EC2 to the bastion host as well as port 22. Keep
in mind you still want to restrict port 22 on your bastion host to
your local IP address __only__.
To accomplish this I use the command below in Linux running on my Chromebook.

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

```
#!/bin/bash

BASTION=50.17.129.75
REMOTE_IP=10.1.4.191
USER=ec2-user
REMOTE_PORT=80
LOCAL_PORT=8080

ssh -i ~/.ssh/id_rsa -f -N -L $LOCAL_PORT:$REMOTE_IP:$REMOTE_PORT $USER@$BASTION -v
```

_or use the `web-tunnel` script in this directory._

```
./web-tunnel -u ec2-user -i 10.1.4.191 -b 50.17.129.75 -p 80 -l 8080 up
```

..to stop port forwarding

```
./web-tunnel -O cancel -u ec2-user -i 10.1.4.191 -b 50.17.129.75 -p 80 -l 8080 up
```

