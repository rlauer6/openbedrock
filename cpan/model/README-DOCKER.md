# README-DOCKER

This is the README file for the `cpan/model` directory which contains
a Makefile that will help you build a docker image to test the
`Bedrock::Model` package.

# Building the Image

The `Dockerfile` in this directory will create an docker image named
`bedrock-model`. This image can be used to test and experiment with
`Bedrock::Model`. It include a MySQL client so you can connect to
a MySQL host.

To access you your MySQL host running in your local host:

```
docker run --network=host  -it bedrock-model /bin/bash^C
```
...then

```
export DBI_HOST=127.0.0.1
export DBI_USER=fred
export DBI_PASS=flintstone
export DBI_DB=bedrock

mysql -u $DBI_USER --password=$DBI_PASS -h $DBI_HOST $DBI_DB
```

There's a script `connect-db` copied into the container. Source the
script to set the environment variables.
