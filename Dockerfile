FROM java:8

ENV JDBC_DRIVER=mysql-connector-java-5.1.35\
    TEAMCITY_DATA_PATH=/var/lib/teamcity

RUN DEBIAN_FRONTEND=noninteractive\
    apt-get update -qq && apt-get -qqy install\
    pwgen\
    runit\
    libtcnative-1

# Install teamcity
RUN curl -s http://download-ln.jetbrains.com/teamcity/TeamCity-9.0.4.tar.gz | tar -xzC /opt;

# Install jdbc driver
RUN mkdir -p $TEAMCITY_DATA_PATH/lib/jdbc $TEAMCITY_DATA_PATH/config;\
    cd /tmp;\
    wget -q http://dev.mysql.com/get/Downloads/Connector-J/$JDBC_DRIVER.tar.gz;\
    tar --strip=1 -xz $JDBC_DRIVER/$JDBC_DRIVER-bin.jar -f $JDBC_DRIVER.tar.gz;\
    mv ./$JDBC_DRIVER-bin.jar $TEAMCITY_DATA_PATH/lib/jdbc/;\
    rm $JDBC_DRIVER.tar.gz

VOLUME /var/lib/teamcity

EXPOSE 8111

CMD /opt/TeamCity/bin/teamcity-server.sh run >> /var/log/teamcity.log
