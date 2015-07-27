FROM sjoerdmulder/java8

# Get and install teamcity
RUN curl -L https://download.jetbrains.com/teamcity/TeamCity-9.1.tar.gz | tar -xz -C /opt

# Enable the correct Valve when running behind a proxy
RUN sed -i -e "s/\.*<\/Host>.*$/<Valve className=\"org.apache.catalina.valves.RemoteIpValve\" protocolHeader=\"x-forwarded-proto\" \/><\/Host>/" /opt/TeamCity/conf/server.xml

ENV TEAMCITY_DATA_PATH /var/lib/teamcity

COPY docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

VOLUME /var/lib/teamcity
# Expose the Teamcity port
EXPOSE  8111