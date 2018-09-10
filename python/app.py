#!/usr/bin/python3
# -*- coding: utf-8 -*-
import argparse
import os
import redis
import ipaddress


def lookup(redis_client, ip):
    score = int(ipaddress.IPv4Address(ip))
    ids = redis_client.zrangebyscore('geoip:index', score, '+inf', start=0, num=1)
    key = f"geoip:{ids[0][0:2]}"
    print(key)
    value = redis_client.hgetall(key)
    return value


def main():
    parser = argparse.ArgumentParser(
        description='GeoIp lookup from Redis in Python')
    parser.add_argument("ip", help="The ip to lookup")
    parser.add_argument("--redis", help="Redis url", default=os.getenv('REDIS_URL', 'redis://localhost:6379/0'))
    args = parser.parse_args()
    ip = args.ip
    redis_client = redis.StrictRedis.from_url(args.redis, decode_responses=True)
    value = lookup(redis_client, ip)
    print(f"Looked up ip '{ip}': {value}")


if __name__ == '__main__':
    main()
