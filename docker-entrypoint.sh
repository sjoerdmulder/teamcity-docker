#!/bin/bash
set -e

mkdir -p $TEAMCITY_DATA_PATH/lib/jdbc $TEAMCITY_DATA_PATH/config

if [ "$DATABASE" == "mysql" ];
then
    if [ ! -f "$TEAMCITY_DATA_PATH"/lib/jdbc/mysql-connector-java.jar ];
    then
        ln -s /usr/share/java/mysql-connector-java.jar "$TEAMCITY_DATA_PATH"/lib/jdbc
    fi
elif [ ! -f "$TEAMCITY_DATA_PATH/lib/jdbc/postgresql-9.3-1103.jdbc41.jar" ];
then
    echo "Downloading postgress JDBC driver..."
    wget -P $TEAMCITY_DATA_PATH/lib/jdbc https://jdbc.postgresql.org/download/postgresql-9.3-1103.jdbc41.jar
fi

echo "Starting teamcity..."
exec /opt/TeamCity/bin/teamcity-server.sh run
