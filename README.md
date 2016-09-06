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

##Deployment to the Cloud

###[Jelastic](https://jelastic.com)

This [JPS](../../raw/master/manifest.jps) manifest  deploys TeamCity that initially contains TeamCity server, [official Postgres image](https://hub.docker.com/_/postgres/) and scalable TeamCity agents.

In order to get this solution instantly deployed, click the "Deploy" button, specify your email address within the widget, choose one of the [Jelastic Public Cloud providers](https://jelastic.cloud) and press Install.

[![Deploy](https://github.com/jelastic-jps/git-push-deploy/raw/master/images/deploy-to-jelastic.png)](https://jelastic.com/install-application/?manifest=https://raw.githubusercontent.com/sych74/teamcity-docker/master/manifest.jps) 

To deploy this package to Jelastic Private Cloud, import [this JPS manifest](../../raw/master/manifest.jps) within your dashboard ([detailed instruction](https://docs.jelastic.com/environment-export-import#import)).

More information about Jelastic JPS package and about installation widget for your website can be found in the [Jelastic JPS Application Package](https://github.com/jelastic-jps/jpswiki/wiki/Jelastic-JPS-Application-Package) reference.
