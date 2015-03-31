FROM sjoerdmulder/java8

# Install teamcity
RUN curl http://download-ln.jetbrains.com/teamcity/TeamCity-9.0.3.tar.gz | tar -xz -C /opt

# Enable the correct Valve when running behind a proxy
RUN sed -i -e "s/\.*<\/Host>.*$/<Valve className=\"org.apache.catalina.valves.RemoteIpValve\" protocolHeader=\"x-forwarded-proto\" \/><\/Host>/" /opt/TeamCity/conf/server.xml

ENV TEAMCITY_DATA_PATH=/var/lib/teamcity\
    VERSION_POSTGRES=9.4\
    DEBIAN_FRONTEND=noninteractive

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8;\
    echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list

RUN apt-get update -qq && apt-get -qqy install\
    postgresql-$VERSION_POSTGRES\
    postgresql-client-$VERSION_POSTGRES\
    postgresql-contrib-$VERSION_POSTGRES\
    pwgen\
    libtcnative-1

# work around for AUFS bug as per https://github.com/docker/docker/issues/783#issuecomment-56013588
RUN mkdir /etc/ssl/private-copy;\
    mv /etc/ssl/private/* /etc/ssl/private-copy/;\
    rm -r /etc/ssl/private;\
    mv /etc/ssl/private-copy /etc/ssl/private;\
    chmod -R 0700 /etc/ssl/private;\
    chown -R postgres /etc/ssl/private

# Correct the Error: could not open temporary statistics file "..main.pg_stat_tmp/global.tmp": No such file or directory
RUN mkdir -p /var/run/postgresql/$VERSION_POSTGRES-main.pg_stat_tmp;\
    chown postgres.postgres /var/run/postgresql/$VERSION_POSTGRES-main.pg_stat_tmp -R

VOLUME  [\
    "/etc/postgresql", \
    "/var/log/postgresql",\
    "/var/lib/postgresql",\
    "/var/lib/teamcity"\
]

# Expose the PostgreSQL and Teamcity port
EXPOSE 5432 8111

ADD service /etc/service