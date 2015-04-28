teamcity-docker
===============
This docker image can use (optionally) an external postgress database instead of the internal database of teamcity.

How to use this image with postgres?
---------------

Start an official docker postgres instance
```
docker run --name some-postgres -e POSTGRES_PASSWORD=mysecretpassword -d postgres
```
Create the database using psql:
```
docker run -it --link some-postgres:postgres --rm postgres sh -c 'exec psql -h "$POSTGRES_PORT_5432_TCP_ADDR" -p "$POSTGRES_PORT_5432_TCP_PORT" -U postgres'
```
And execute:
```
create role teamcity with login password 'teamcity';
create database teamcity owner teamcity;
```
After this you can start the teamcity image linking it to the postgres image
```
docker run --link some-postgres:postgres -v <teamcitydir>:/var/lib/teamcity -d sjoerdmulder/teamcity:latest
```
In the installation screen of teamcity as host for postgress you can specify `postgres`

Howto upgrade to a new version?
----------------
1. Stop the old image
2. `docker pull sjoerdmulder/teamcity`
3. `docker run --link some-postgres:postgres -v <teamcitydir>:/var/lib/teamcity -p 8111:8111 sjoerdmulder/teamcity`
