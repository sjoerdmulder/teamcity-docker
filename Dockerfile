FROM java:8

ENV TEAMCITY_DATA_PATH=/var/lib/teamcity\
    VERSION_TEAMCITY=9.0.3\
    VERSION_POSTGRES=9.4\
    DEBIAN_FRONTEND=noninteractive\
    JDBC_DRIVER=postgresql-9.4-1201.jdbc41.jar

RUN apt-get update -qq && apt-get -qqy install\
    pwgen\
    postgresql-client-$VERSION_POSTGRES\
    runit\
    libtcnative-1

# Install teamcity and Postgres driver
RUN curl --silent http://download-ln.jetbrains.com/teamcity/TeamCity-9.0.3.tar.gz | tar -xz -C /opt;
RUN mkdir -p $TEAMCITY_DATA_PATH/lib/jdbc $TEAMCITY_DATA_PATH/config;\
    wget --quiet -P $TEAMCITY_DATA_PATH/lib/jdbc http://jdbc.postgresql.org/download/$JDBC_DRIVER;
RUN sed -i -e "s/\.*<\/Host>.*$/<Valve className=\"org.apache.catalina.valves.RemoteIpValve\" protocolHeader=\"x-forwarded-proto\" \/><\/Host>/" /opt/TeamCity/conf/server.xml

VOLUME  ["/var/lib/teamcity" ]

EXPOSE 8111

CMD /opt/TeamCity/bin/teamcity-server.sh run >> /var/log/teamcity.log