teamcity-docker
===============

Team City server with the MySql jdbc driver installed

Howto upgrade to a new version? You can just migrate the volumes using the `--volumes-from` option:

1. docker stop teamcity
2. docker pull tomatensuppe/teamcity
3. docker run -d --volumes-from=OLD_INSTANCE --name=teamcity_new -p 8111:8111 tomatensuppe/teamcity
