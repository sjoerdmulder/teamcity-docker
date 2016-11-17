Docker image
===============
[![Docker automated build](https://img.shields.io/badge/docker-automated--build-blue.svg?style=flat-square)](https://hub.docker.com/r/sjoerdmulder/teamcity/)
[![Docker Stars](https://img.shields.io/docker/stars/sjoerdmulder/teamcity.svg?style=flat-square)](https://hub.docker.com/r/sjoerdmulder/teamcity/)
[![Docker Pulls](https://img.shields.io/docker/pulls/sjoerdmulder/teamcity.svg?style=flat-square)](https://hub.docker.com/r/sjoerdmulder/teamcity/)

JetBrains TeamCity docker image
===============

Distributed Build Management and Continuous Integration Server

By default, each TeamCity installation runs under a Professional Server license including 3 build agents. This license is provided for free with any downloaded TeamCity binary and gives you full access to all product features with no time limit. The only restriction is a maximum of 20 build configurations.

By pulling this image you accept the [JetBrains license agreement for TeamCity (Commercial License)] (https://www.jetbrains.com/teamcity/buy/license.html)

This docker image can use (optionally) an external postgress database instead of the internal database of teamcity. (recommended for production usage)

How to use this image with postgres?
---------------

```
POSTGRES_PASSWORD=mysecretpassword
SETUP_TEAMCITY_SQL="create role teamcity with login password 'teamcity';create database teamcity owner teamcity;"

# Start an official docker postgres instance
docker run --name some-postgres -e POSTGRES_PASSWORD=$POSTGRES_PASSWORD -d postgres
# Create the database using psql
docker run -it --link some-postgres:postgres --rm -e "SETUP_TEAMCITY_SQL=$SETUP_TEAMCITY_SQL" -e "PGPASSWORD=$POSTGRES_PASSWORD" postgres bash -c 'exec echo $SETUP_TEAMCITY_SQL |psql -h "$POSTGRES_PORT_5432_TCP_ADDR" -p "$POSTGRES_PORT_5432_TCP_PORT" -U postgres'
```
After this you can start the teamcity image linking it to the postgres image
```
docker run --link some-postgres:postgres -v <teamcitydir>:/var/lib/teamcity -d sjoerdmulder/teamcity:latest
```
In the installation screen of teamcity as host for postgress you can specify `postgres`

Howto upgrade to a new version?
----------------
1. `docker pull sjoerdmulder/teamcity:latest`
2. stop the old image
3. `docker run --link some-postgres:postgres -v <teamcitydir>:/var/lib/teamcity -p 8111:8111 sjoerdmulder/teamcity:latest`
