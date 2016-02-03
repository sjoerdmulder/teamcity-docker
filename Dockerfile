FROM java:8

MAINTAINER Sjoerd Mulder <sjoerd@sagent.io>

ENV TEAMCITY_VERSION 9.1.6
ENV TEAMCITY_DATA_PATH /var/lib/teamcity

# Get and install teamcity
RUN wget -qO- https://download.jetbrains.com/teamcity/TeamCity-$TEAMCITY_VERSION.tar.gz | tar xz -C /opt

# Enable the correct Valve when running behind a proxy
RUN sed -i -e "s/\.*<\/Host>.*$/<Valve className=\"org.apache.catalina.valves.RemoteIpValve\" protocolHeader=\"x-forwarded-proto\" \/><\/Host>/" /opt/TeamCity/conf/server.xml

COPY docker-entrypoint.sh /docker-entrypoint.sh

EXPOSE  8111

VOLUME /var/lib/teamcity

ENTRYPOINT ["/docker-entrypoint.sh"]
