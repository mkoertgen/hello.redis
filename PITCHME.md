@title[Introduction]

### Fast GeoIp Lookup using Redis

---

### @fa[lightbulb] Why Redis?

Some references:

@ul

- [Why Redis](https://redislabs.com/why-redis/) (redislabs.com)
- [Introduction to Redis](https://redis.io/topics/introduction) (redis.io)
- [Redis: What and Why?](https://codeburst.io/redis-what-and-why-d52b6829813) (codeburst.io)

@ulend

---

### Fundamental Theorem of Software Engineering (FTSE)

We can solve any problem by adding another level of indirection (David Wheeler)

...except for the problem of too many layers (Kevlin Henney)

---

### GeoIp Lookup

Indirect lookup using a sorted zet of ip ranges

@ul

- Find closest ip range: [zrange by score](https://redis.io/commands/zrangebyscore)
- Retreive bucket: [hgetall](https://redis.io/commands/hgetall)

@ulend

Question: What about overlapping ip ranges?

---

### Implementations

Examples given in

- .NET
- Node
- Ruby
- Python
- Go
- Dart
- Java

---

### Redis Modules

List of Redis modules, see [Redis Modules Hub](https://redislabs.com/community/redis-modules-hub/) (redislabs.com) [Redis Modules](https://redis.io/modules) (redis.io)

Some modules we find interesting

@ul

- [RedisLabsModules/redis-ml](https://github.com/RedisLabsModules/redis-ml) Machine Learning Model Server
- [RedisLabsModules/redis-graph](https://github.com/RedisLabsModules/redis-graph) [openCypher](http://www.opencypher.org/) compatible graph database in Redis
- [RedisLabsModules/RediSearch](https://github.com/RedisLabsModules/RediSearch) Fulltext search for Redis
- [earns/redissnowflake](https://github.com/erans/redissnowflake) [Twitter's Snowflake](https://github.com/twitter/snowflake/tree/snowflake-2010) scalable unique ID generation

@ulend

---

### Some References

@ul

- [Redis Pub/Sub: Howto Guide](https://redisgreen.net/blog/pubsub-howto/) (RedisGreen)
- [socketio/socket.io-redis](https://github.com/socketio/socket.io-redis)

@ulend

---

### Questions?

Reach out <br/>

@fa[twitter gp-contact](@mkoertg)

@fa[github gp-contact](mkoertgen)

@fa[medium gp-contact](@marcel.koertgen)
