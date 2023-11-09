# GPDB 7 Docker Compose with systemd

This is a docker compose repository to build and orchestrate a GPDB 7X
multinode cluster with systemd for dev testing. This can be useful when there is a
need to have multiple hosts and the single-node gpdemo cluster is
insufficient. The docker compose GPDB 7 cluster is ephemeral so the
cluster can be discarded and rebuilt for quick and clean testing. The
OS of choice here is Rocky Linux 8.

## Build the image

We need to build a local docker image that will be used for each
container in the multinode cluster. The image here is specifically
designed to work for GPDB 7 compilation and running the cluster.

```
pushd ./build/
docker build -t gpdb7-multinode-cluster/gpdb-systemd-image .
popd
```

Note: You only have to build the image once (unless there is an update
to the build directory). The image is stored locally.

## Set environment variables

The `docker-compose.yaml` uses three environment variables:
1. `$GPDB7_SRC` (the path to your GPDB 7X source code)
```
Example:
export GPDB7_SRC=/Users/jyih/workspace/gpdb7
```
Note: The `$GPDB7_SRC` path will be mounted and used for compilation
so it would be good to run `git clean -xfd` in the directory to rid of
anything (e.g. MacOS compiled binaries).

2. `$PWD` (the path to the top-level dir of this repository)
Note: You have to run `docker-compose` in the top-level dir anyways so
`$PWD` should always be correct.

3. `$GPDB_RPM` (the path to the GPDB RPM directory)
Note: This is optional and required only if you want to install GPDB using
an RPM instead of compiling it from source

## Run docker compose

This step will create the GPDB hosts (3 containers), build a network
bridge between the 3 containers, and mount a shared volume (the GPDB 7
source code and some orchestration scripts from this repository).

```
# In this repository's top-level dir
docker-compose up -d
```

## Run coordinate-everything.sh script

This step will install the compiled GPDB 7 and the new `gp` binary
across all hosts and also configure the required certificates and systemd
service files to run the gRPC services.

```
pushd ./scripts/
bash coordinate-everything.sh
popd
```

Alternatively, you can also use GPDB RPM to install GPDB. You would need
to set the `$GPDB_RPM` environment variable to the directory
where the RPM is located.

```
pushd ./scripts/
bash coordinate-everything.sh rpm
popd
```

Afterwards, you'll be able to connect to the coordinator node and
start your testing.

```
docker exec -it gpdb7-docker-compose-systemd-cdw-1 /bin/bash
su - gpadmin
source env.sh
```

## Running gp services (hub/agent)

Next, we need to start the hub/agent services. Make sure you have sourced the env.sh file.

```
gp start services
```

To check the status of the services.

```
gp status services
```

To stop the services.

```
gp stop services
```

To create a sample cluster using the new utility.

```
gp init cluster /gpdb-scripts/configs/init_config.json
```

You can edit the `init_config.json` file to modify the cluster configuration.

## Stop and delete everything

This step will destroy everything we've created. Run this when you no
longer need the cluster.

```
# In this repository's top-level dir
docker-compose down -v
```
