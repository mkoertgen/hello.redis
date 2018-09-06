#!/usr/local/bin/ruby
require 'optparse'
require_relative 'geo_ip'

# The main application
class App
  attr_reader :opts, :geo_ip

  def initialize(argv)
    @opts = {
      redis: ENV.fetch('REDIS_URL') { 'redis://localhost:6379/0' },
      ip: '217.174.224.3' # Turkmenistan
    }
    parse argv
    @geo_ip = GeoIp.new(options[:redis])
  end

  def run
    result = geo_ip.lookup(options[:ip])
    puts result
  end

  private

  def parse(argv)
    parser = OptionParser.new do |o|
      o.banner = 'Usage: app.rb [options]'
      o.on('-h', '--help', 'Displays Help') do |opts|
        puts opts
        exit
      end
      o.on('-r', '--redis URL', "default: '#{opts[:redis]}')") { |url| opts[:redis] = url }
      o.on('-i', '--ip IP', "default: '#{opts[:ip]}')") { |ip| opts[:ip] = ip }
    end
    parser.parse! argv
  end
end

App.new(ARGV).run
