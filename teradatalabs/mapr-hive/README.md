# mapr-hive [![][layers-badge]][layers-link] [![][version-badge]][dockerhub-link] 

[layers-badge]: https://images.microbadger.com/badges/image/teradatalabs/mapr-hive.svg
[layers-link]: https://microbadger.com/images/teradatalabs/mapr-hive
[version-badge]: https://images.microbadger.com/badges/version/teradatalabs/mapr-hive.svg
[dockerhub-link]: https://hub.docker.com/r/teradatalabs/mapr-hive

Docker image with MapR FS, YARN and HIVE installed. Please note that running services have lower memory heap size set.
For more details please check hadoop-env.sh(configuration) file.
If you want to work on larger datasets please tune those settings accordingly, the current settings should be optimal
for general correctness testing.

## Run

```
$ docker run --privileged -d --name hadoop-master -h hadoop-master teradatalabs/mapr-hive
```

## Oracle license

By using this image, you accept the Oracle Binary Code License Agreement for Java SE available here:
[http://www.oracle.com/technetwork/java/javase/terms/license/index.html](http://www.oracle.com/technetwork/java/javase/terms/license/index.html)
