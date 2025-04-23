# README

This is the README that will help you create a Docker image for
building and testing Bedrock using GitHub's Actions.

> Note: Bedrock is an open source project, however it is not
> completely open to the public. Below is a description of how
> GitHub's Actions are used to build a new Bedrock distribution. Part
> of the process requires a personal token for accessing the GitHub
> container registry. If you clone this project, you'll need to follow
> the instructions to create your own token if you want the GitHub
> Action functionality to work correctly.

# Overview

When a branch is pushed to GitHub, a GitHub action is triggered that
verifies the latest build. The verification process includes
attempting to build the project as a tar ball, running `make
distcheck` and then building CPAN distribution.  Both the `make
distcheck` and building of a CPAN distribution will run unit tests
against that branch.

The Github Action involves these components:

* a Docker [image capable](docker/Dockerfile.github) of hosting a
  Bedrock build
* an action specification
  [.github/.github/workflows/build.yml](.github/workflows/build.yml)
  that specifies the action environment and steps for performing the
  action
* a GitHub [token](#github-token) with permissions to pull (and write) the image
* `docker` - for building the image used to build and test the distribution
* the branch - this is cloned for you when the action is triggered so
  that inside your container, the current working directory contains
  the branch
  
# GitHub Token

To access the GitHub container registry you need a GitHub token.  You
can create a token by visiting this [page]().

Install your token in your `~/.ssh` directory as `github.token`.  The
`Makefile.am` recipe will use that token to login to GitHub's
container registry.

# Building the Test Image

The Docker image that executes the build is created using
`Dockerfile.github`. You can create a new image by running `make`:

```
make bedrock-test
```

This will create a new `bedrock-test` image and push it to the GitHub
registry.

# Building a Docker Image from Docker

The `bedrock-test` image is a self-container Docker image with all of
the prerequisites to build a Bedrock Image.  It does not include
Bedrock, just the artifacts required to build Bedrock. It is used to
test the build but can also be used to create Bedrock images.

To build a Bedrock image you need to run in privilged mode and then
startup `docker` inside the container.

```
docker run --rm -it --privileged -v /var/lib/docker bedrock-test /bin/bash
```

...then `service docker start`

