require 'redis'
require 'ipaddr'

# The GeoIp class
class GeoIp
  attr_reader :redis

  def initialize(redis_url)
    @redis = Redis.new(url: redis_url)
  end

  def lookup(ip)
    score = IPAddr.new(ip).to_i
    ids = redis.zrangebyscore('geoip:index', score, '+inf', limit: [0, 1])
    raise IndexError, "'#{ip}' not found" if ids.empty?
    redis.hgetall("geoip:#{ids[0][0..1]}")
  end
end
