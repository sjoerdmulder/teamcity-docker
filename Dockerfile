FROM java:8

ENV TEAMCITY_DATA_PATH=/var/lib/teamcity\
    VERSION_TEAMCITY=9.0.3\
    DEBIAN_FRONTEND=noninteractive\
    JDBC_DRIVER=http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.35.tar.gz

RUN apt-get update -qq && apt-get -qqy install\
    pwgen\
    runit\
    libtcnative-1

# Install teamcity
RUN curl -s http://download-ln.jetbrains.com/teamcity/TeamCity-9.0.3.tar.gz | tar -xzC /opt;

# Install jdbc driver
RUN mkdir -p $TEAMCITY_DATA_PATH/lib/jdbc $TEAMCITY_DATA_PATH/config;\
    curl -sL $JDBC_DRIVER | tar -xzC $TEAMCITY_DATA_PATH/lib/jdbc

RUN sed -i -e\
    "s/\.*<\/Host>.*$/<Valve className=\"org.apache.catalina.valves.RemoteIpValve\" protocolHeader=\"x-forwarded-proto\" \/><\/Host>/"\
    /opt/TeamCity/conf/server.xml

VOLUME /var/lib/teamcity

EXPOSE 8111

CMD /opt/TeamCity/bin/teamcity-server.sh run >> /var/log/teamcity.log
