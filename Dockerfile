FROM sjoerdmulder/java8

VOLUME  [ "/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql", "/var/lib/teamcity" ]

# Install teamcity
RUN curl http://download-ln.jetbrains.com/teamcity/TeamCity-9.0.3.tar.gz | tar -xz -C /opt

# Enable the correct Valve when running behind a proxy
RUN sed -i -e "s/\.*<\/Host>.*$/<Valve className=\"org.apache.catalina.valves.RemoteIpValve\" protocolHeader=\"x-forwarded-proto\" \/><\/Host>/" /opt/TeamCity/conf/server.xml

ENV TEAMCITY_DATA_PATH /var/lib/teamcity

# Install Postgress
ENV VERSION_POSTGRES 9.4
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8;\
    echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" > /etc/apt/sources.list.d/pgdg.list

RUN apt-get update && apt-get -y install\
    postgresql-$VERSION_POSTGRES\
    postgresql-client-$VERSION_POSTGRES\
    postgresql-contrib-$VERSION_POSTGRES\
    pwgen\
    libtcnative-1

# Adjust PostgreSQL configuration so that remote connections to the database are possible.
RUN  echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/$VERSION_POSTGRES/main/pg_hba.conf;\
     # And add ``listen_addresses`` to ``/etc/postgresql/$VERSION_POSTGRES/main/postgresql.conf``
     echo "listen_addresses='*'" >> /etc/postgresql/$VERSION_POSTGRES/main/postgresql.conf

# work around for AUFS bug as per https://github.com/docker/docker/issues/783#issuecomment-56013588
RUN mkdir /etc/ssl/private-copy;\
    mv /etc/ssl/private/* /etc/ssl/private-copy/;\
    rm -r /etc/ssl/private;\
    mv /etc/ssl/private-copy /etc/ssl/private;\
    chmod -R 0700 /etc/ssl/private;\
    chown -R postgres /etc/ssl/private

# Correct the Error: could not open temporary statistics file "..main.pg_stat_tmp/global.tmp": No such file or directory
RUN mkdir -p /var/run/postgresql/$VERSION_POSTGRES-main.pg_stat_tmp;
    chown postgres.postgres /var/run/postgresql/$VERSION_POSTGRES-main.pg_stat_tmp -R


# Expose the PostgreSQL and Teamcity port
EXPOSE 5432 8111

ADD service /etc/service