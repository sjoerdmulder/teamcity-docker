teamcity-docker
===============

How to use this image (first-time)
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



Howto upgrade to a new version? You can just migrate the volumes using the `--volumes-from` option:

1. docker stop teamcity
2. docker pull sjoerdmulder/teamcity
3. docker run -d --volumes-from=OLD_INSTANCE --name=teamcity_new -p 8111:8111 sjoerdmulder/teamcity
