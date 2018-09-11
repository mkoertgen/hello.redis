package main

import (
	"bytes"
	"encoding/binary"
	"flag"
	"fmt"
	"log"
	"net"
	"os"
	"strconv"

	"github.com/go-redis/redis"
)

var redisdb *redis.Client

func main() {
	redisPtr := flag.String("redis", getEnv("REDIS_URL", "redis://localhost:6379/0"), "Redis url")
	ipPtr := flag.String("ip", "1.2.3.4", "IP to lookup")

	flag.Parse()
	log.Println("redis:", *redisPtr)
	log.Println("ip:", *ipPtr)

	redisdb = getRedis(*redisPtr)
	value := lookup(*ipPtr)
	log.Println("value: ", value)
}

func getEnv(key, fallback string) string {
	if value, ok := os.LookupEnv(key); ok {
		return value
	}
	return fallback
}

func getRedis(url string) *redis.Client {
	opt, err := redis.ParseURL(url)
	if err != nil {
		panic(err)
	}
	return redis.NewClient(opt)
}

func lookup(ip string) map[string]string {
	score := ip2Long(ip)
	ids, err := redisdb.ZRangeByScore("geoip:index", redis.ZRangeBy{
		Min:    strconv.FormatUint(uint64(score), 10),
		Max:    "+inf",
		Offset: 0,
		Count:  1,
	}).Result()
	if err != nil {
		panic(err)
	}
	if len(ids) == 0 {
		panic("No keys found")
	}
	key := fmt.Sprintf("geoip:%s", ids[0][0:2])
	m, err := redisdb.HGetAll(key).Result()
	return m
}

func ip2Long(ip string) uint32 {
	var long uint32
	binary.Read(bytes.NewBuffer(net.ParseIP(ip).To4()), binary.BigEndian, &long)
	return long
}
