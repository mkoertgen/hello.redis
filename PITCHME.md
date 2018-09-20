@title[Introduction]

### Fast GeoIp Lookup using Redis

---

### NoSQL database categories

![NoSQL database categories](http://blog.appdynamics.com/wp-content/uploads/2015/09/screen_shot_2015-09-14_at_1.30.08_pm.png)

+++

### The V's of Big Data

Originally,

- Volume (amount or size of data)
- Velocity (speed of data processing)
- Variety (number of types of data)

More recently,

- Veracity (trustworthiness of the data)
- Value (generates the data value)

+++

### Volume

[Java Says, Your Data's Not That Big](https://dzone.com/articles/how-big-is-your-data-really)

|                        A majority of data scientists (56%) work in Gigabyte dataset range.                        |                                              Managing Gigabytes (1994 ;-)                                               |                      Jure Leskovic’s take on the best way to mine large datasets.                      |
| :---------------------------------------------------------------------------------------------------------------: | :---------------------------------------------------------------------------------------------------------------------: | :----------------------------------------------------------------------------------------------------: |
| ![KDnuggets 2015 Poll](https://jtablesaw.files.wordpress.com/2016/01/poll-largest-dataset-analyzed-2013-2015.jpg) | ![Managing Gigabytes (Cover)](https://images-na.ssl-images-amazon.com/images/I/414SCU9MxqL._SX371_BO1,204,203,200_.jpg) | ![Get your own 1TB Ram Server](https://i1.wp.com/fastml.com/images/distributed/bottom_line.jpg?zoom=2) |

+++

### Garbage In...

![Garbage In...](https://media.gettyimages.com/videos/landfill-with-garbage-trucks-unloading-junk-video-id639450178?s=640x640)

+++

Data Science is mostly about how to make sense of and interpret (filter) your data...

![Be picky...](https://s-i.huffpost.com/gadgets/slideshows/407182/slide_407182_5096748_free.jpg)

- [Using GitHub as a Data Lake](https://dzone.com/articles/using-github-as-a-data-lake)

+++

### Velocity

- Importing 100,000,000/day ~ 1,200/sec
- HTTP/REST: ~50/sec => 25 container (scale out)
- Redis: ~500,000/sec (on a laptop, pipelined)

+++

### Redis is fast!

![Quicksilver](https://media.giphy.com/media/3oriNYQX2lC6dfW2Ji/giphy.gif)

---

### @fa[lightbulb] Why Redis?

Some references:

@ul

- [Why Redis](https://redislabs.com/why-redis/) (redislabs.com)
- [Introduction to Redis](https://redis.io/topics/introduction) (redis.io)
- [Redis: What and Why?](https://codeburst.io/redis-what-and-why-d52b6829813) (codeburst.io)
- [Redis and its data types](https://www.slideshare.net/aniruddha.chakrabarti/redis-and-its-data-types)

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

Question: What about missing or overlapping ip ranges?

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
