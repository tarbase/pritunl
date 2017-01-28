# docker pritunl

Run Pritunl in a docker container.

Pritunl is a distributed enterprise VPN server built using the OpenVPN protocol.

## Features

* VPN out of the box using `docker-compose`.
* Support for external MongoDB allowing [multi host](https://docs.pritunl.com/docs/mutli-host-servers) setup.


## Usage

### Single node VPN using local MongoDB container:

1. Clone this repo: `https://github.com/tarbase/docker-pritunl`
2. Create the local MongoDB data directory (data volume): `mkdir -p /opt/mongo`
3. Run `docker-compose up`

> The admin console is now available at `https://<ip>` with username `pritunl`, password `pritunl`.

### Single or multi host VPN using remote MongoDB

1. Make sure that you MongoDB is up and running. (Use https://mlab.com to run a sandbox MongoDB instance)
2. You will need to change the **MONGODB_URI** bellow to point the remote MongoDB. ([See standard MongoDB connection string](https://docs.mongodb.com/manual/reference/connection-string/))
2. Run

```
  docker run -it --privileged \
    -p 80:80 \
    -p 443:443/tcp \
    -p 1194:1194/udp \
    -p 1194:1194/tcp \
    -e MONGODB_URI=mongodb://<dbuser>:<dbpassword>@<dbip>:27017/pritunl \
    tarbase/docker-pritunl
```    

> The admin console is now available at `https://<ip>` with username `pritunl`, password `pritunl`.


## Help

If you have a specific feature request or if you found a bug, please use GitHub issues. Fork these docs and send a pull request with improvements.

Feel free to reach out: https://tarbase.com
