# README

Makefile for creating a Docker image for Bedrock.

# Building the Image

The Bedrock Docker image is built by installing the Bedrock rpms from the
Bedrock repo to an Amazon Linux 2 image.

The image implements an Apache based web sever enviroment you can use
for development.

To build the image:

```
make realclean
make docker-image
```

# Running the Server

A `docker-compose.yml` file will bring up the web server listening on
port 80.

```
BEDROCK=~/git/openbedrock docker-compose-up
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

The goal is run a docker container on my development EC2 instance
exposing port 80 to my bastion host while using an ssh tunnel through
the bastion host wheneve my local browser on my Chromebook accesses
port 8080.  Looks something like this...

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

To accomplish this I use the command below in Linux runnining on my Chromebook.

```
ssh -i ~/.ssh/isa_rsa -f -N -L 8080:$REMOTE_IP:$REMOTE_PORT $REMOTE_USER@$REMOTE_BASTION -v 
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

Typically all ports are blocked to my EC2 except 22. In this scenario
we open port 80 of my EC2 to the bastion host as well as port 22. Keep
in mind you still want to restrict port 22 on your bastion host to
your local IP address __only__.

