# Pritunl for Docker

A Pritunl image that can be used to start a Pritunl server.

## What is Pritunl?

> Pritunl is the most secure VPN server available and the only VPN server to offer up to five layers of authentication.

*from* [pritunl.com](https://pritunl.com/)

## Usage

### Creating Volumes

To be able to make all of the Pritunl configurations persistent, a Docker
volume is required to store the MongoDB data.

Creating volumes can be done using the `docker` tool. To create a volume use
the following command:

```
docker volume create --name <VOLUME_NAME>
```

Two create a volume for the MongoDB data use the following command:

```
docker volume create --name pritunl_mongodb
```

**Note:** A local folder can also be used instead of a volume. Use the path of
the folder in place of the volume name.

### Start the Pritunl Server

Starting the Pritunl server can be done with the folowing command.

```
docker container run --volume PRITUNL_VOL:/data/mongodb:rw --detach --publish 1194:1194/udp --publish 1194:1194 --publish 443:443 --privileged --device=/dev/net/tun tarbase/pritunl
```

The Docker options `--privileged` and`--device=/dev/net/tun` are required for
the container to be able to start.

#### Use a dedicated MongoDB server

To use an external MongoDB server, instead of the internal one, the MongoDB
address will have to be specified using the environment variable `MONGODB_URI`.

```
docker container run --env MONGODB_URI=mongodb://address:port/db_name --detach --publish 1194:1194/udp --publish 1194:1194 --publish 443:443 --privileged --device=/dev/net/tun tarbase/pritunl
```

#### Default credentials

To access the Pritunl administration console open a web browser on your
computer, and navigate to `https://PRITUNL_ADDRESS`

Login with the following information:
 * Username: `pritunl`
 * Password: `pritunl`

### Pritunl Status

The Pritunl server status can be check by looking at the server output using
the following docker command:

```
docker container logs CONTAINER_ID
```

## Authors

See the list of [contributors](https://github.com/tarbase/docker-pritunl/contributors)
who participated in this project.
