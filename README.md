[![GitPitch](https://gitpitch.com/assets/badge.svg)](https://gitpitch.com/mkoertgen/hello.redis/master)

# hello.redis

Using redis for fast GeoIp lookup with implementations in multiple languages.

## Usage

We are using the free MaxMind Legacy [GeoLite IP Country](https://dev.maxmind.com/geoip/legacy/geolite/) Database, cf.:

- https://dev.maxmind.com/geoip/legacy/geolite/#Downloads
- http://geolite.maxmind.com/download/geoip/database/GeoIPCountryCSV.zip

First, download the CSV file to `./dotnet`. As of now, only the .NET-implementation parses and uploads
the GeoIp database into redis.

Next, build all implementations (or just `dotnet`)

```console
$docker-compose build
Building dotnet...
Building ruby...
Building dart...
Building python...
Building node...
```

To prepare the redis database

```console
$docker-compose run --rm dotnet upload
Importing 'GeoIPCountryWhois.csv...
Imported 170433 GeoIP Records.
```

View the imported keys with Redis Commander, i.e

- `docker-compose up -d redis_commander`
- and hit [http://localhost:8081](http://localhost:8081)

```console
$docker-compose run --rm dotnet upload
Importing 'GeoIPCountryWhois.csv...
```

Try out the various implementations using `docker-compose up/run --rm [lang] [options]...`, e.g.

```console
$docker-compose up -d node
Creating network "helloredis_default" with the default driver
Creating helloredis_redis_1 ... done
Creating helloredis_node_1  ... done

$curl http://localhost:3000/lookup/1.2.3.4
{"code":"US","country":"United States","min":"220.232.59.132","max":"220.232.59.132"}`
```
