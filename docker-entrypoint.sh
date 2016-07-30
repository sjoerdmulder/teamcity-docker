#!/bin/bash
set -e
POSTGRES_CURRENT_VERSION=9.4.1209
POSTGRES_OLD_VERSION=9.3.1103.jdbc

mkdir -p $TEAMCITY_DATA_PATH/lib/jdbc $TEAMCITY_DATA_PATH/config
if [ ! -f "$TEAMCITY_DATA_PATH/lib/jdbc/postgresql-${POSTGRES_CURRENT_VERSION}.jar" ];
then
    echo "Downloading postgress JDBC driver..."
    wget -P $TEAMCITY_DATA_PATH/lib/jdbc https://jdbc.postgresql.org/download/postgresql-${POSTGRES_CURRENT_VERSION}.jar
    # Remove possible old one when upgrading...
    rm -f $TEAMCITY_DATA_PATH/lib/jdbc/postgresql-${POSTGRES_OLD_VERSION}.jar
fi


echo "Starting teamcity..."
exec /opt/TeamCity/bin/teamcity-server.sh run
