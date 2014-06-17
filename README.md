teamcity-docker
===============

Howto upgrade to a new version? You can just migrate the volumes using the `--volumes-from` option:

1. docker stop teamcity
2. docker pull sjoerdmulder/teamcity
3. docker run -d --volumes-from=OLD_INSTANCE --name=teamcity_new -p 8111:8111 sjoerdmulder/teamcity
