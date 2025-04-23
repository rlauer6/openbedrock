# README-CI

This is the README file that explains the automated build system for
Bedrock.

A _build_ is done whenever a branch is pushed to the Bedrock GitHub
repository. This is controlled by the GitHub actions configuration
that looks something like this:

```
name: openbedrock
on: 
  push:
    branches: "*"
jobs:
  test-module:
    runs-on: ubuntu-latest
    container:
      image: ghcr.io/rlauer6/bedrock-test:latest
      credentials:
        username: rlauer6
        password: ${{ secrets.DOCKER_TOKEN }}
    steps:
      - uses: actions/checkout@v4

      - name: build
        run: ./build-github
```

The [build](build-github) will run `configure`, `make`, and `make
test` in a [pre-existing container
(`bedrock-test`)](#bedrock-github-ci-container) previously pushed to
the GitHub container registry.

The  [build](build-github) looks something like this:

```
#!/bin/bash
# -*- mode: sh; -*-

set -ex
./bootstrap
./configure
make
cd src/main/perl
make test
cd -
cd src/main/perl/lib
make test
```

# Bedrock GitHub CI Container

The docker image used to build and test Bedrock is based on the
`perl:5.40-threaded-bookworm` docker image (a Debian variant). A
[Dockerfile](docker/Dockerfile.github) is provided as part of this
project which will load all of the dependencies required to build and
test Bedrock.

## Building a New CI Container

From time to time new dependencies introduced by Bedrock may require
that you update the CI container. Below are some basic instructions
for creating a new container.

In order to push an image to the GitHub Container Registry you need a
personal access token with privileges to do so. If you've lost the
token you'll need to re-create one [here.](https://github.com/settings/tokens)

The build and push of the image to the registry is done by running
`make bedrock-test` in the `docker` directory...but as a reminder
after building the image, the `make` recipe will login to the registry
and push the image to GitHub.

```
echo $GITHUB_TOKEN | docker login ghcr.io -u rlauer6 --password-stdin
docker push ghcr.io/rlauer6/bedrock-test:latest
```
