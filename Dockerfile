FROM java:8

RUN DEBIAN_FRONTEND=noninteractive\
    apt-get update -qq && apt-get -qqy install\
    pwgen\
    runit\
    libtcnative-1

ENV JDBC_DRIVER=mysql-connector-java-5.1.35\
    TEAMCITY_DATA_PATH=/var/lib/teamcity

# Install jdbc driver
RUN mkdir -p $TEAMCITY_DATA_PATH/lib/jdbc $TEAMCITY_DATA_PATH/config;\
    curl -sL http://dev.mysql.com/get/Downloads/Connector-J/$JDBC_DRIVER.tar.gz |  tar --strip=1 -xz  $JDBC_DRIVER/$JDBC_DRIVER-bin.jar -C $TEAMCITY_DATA_PATH/lib/jdbc

# Install teamcity
RUN curl -s http://download-ln.jetbrains.com/teamcity/TeamCity-9.0.3.tar.gz | tar -xzC /opt;

RUN sed -i -e\
    "s/\.*<\/Host>.*$/<Valve className=\"org.apache.catalina.valves.RemoteIpValve\" protocolHeader=\"x-forwarded-proto\" \/><\/Host>/"\
    /opt/TeamCity/conf/server.xml

VOLUME /var/lib/teamcity

EXPOSE 8111

CMD /opt/TeamCity/bin/teamcity-server.sh run >> /var/log/teamcity.log
