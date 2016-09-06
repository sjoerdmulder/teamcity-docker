#!/bin/bash
set -e
POSTGRES_CURRENT_VERSION=9.4.1209
POSTGRES_OLD_VERSION=9.3-1103.jdbc41

: ${TEAMCITY_PORT:=8111}

mkdir -p $TEAMCITY_DATA_PATH/lib/jdbc $TEAMCITY_DATA_PATH/config
if [ ! -f "$TEAMCITY_DATA_PATH/lib/jdbc/postgresql-${POSTGRES_CURRENT_VERSION}.jar" ];
then
    echo "Downloading postgress JDBC driver..."
    wget -P $TEAMCITY_DATA_PATH/lib/jdbc https://jdbc.postgresql.org/download/postgresql-${POSTGRES_CURRENT_VERSION}.jar
    # Remove possible old one when upgrading...
    rm -f $TEAMCITY_DATA_PATH/lib/jdbc/postgresql-${POSTGRES_OLD_VERSION}.jar
fi

if [[ ! -z $POSTGRES_HOST && ! -f "$TEAMCITY_DATA_PATH/config/database.properties" ]];
then
    echo "Configuring connection to Postgres server..."
    echo "connectionUrl=jdbc\:postgresql\://$POSTGRES_PORT_5432_TCP_ADDR\:$POSTGRES_PORT_5432_TCP_PORT/$POSTGRES_POSTGRES_DB" > $TEAMCITY_DATA_PATH/config/database.properties
    echo "connectionProperties.user=$POSTGRES_POSTGRES_USER" >> $TEAMCITY_DATA_PATH/config/database.properties
    echo "connectionProperties.password=$POSTGRES_POSTGRES_PASSWORD" >> $TEAMCITY_DATA_PATH/config/database.properties
    echo "maxConnections=50" >> $TEAMCITY_DATA_PATH/config/database.properties    
fi

sed -i 's|Connector port=\"[0-9a-z.]\{1,\}\"|Connector port=\"${TEAMCITY_PORT}\"|g' /opt/TeamCity/conf/server.xml

echo "Starting teamcity..."
exec /opt/TeamCity/bin/teamcity-server.sh run
