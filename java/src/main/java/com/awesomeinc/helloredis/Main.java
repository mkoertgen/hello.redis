package com.awesomeinc.helloredis;

import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPubSub;

public class Main {

    public static void main(String[] args) {
        String host = System.getenv("REDIS_HOST");
        if (host == null) host = "localhost";
        Jedis jedis = new Jedis(host);
        MyListener l = new MyListener();
        jedis.subscribe(l, "*");    }

}

class MyListener extends JedisPubSub {
    public void onMessage(String channel, String message) {
        System.out.println(String.format("Channel: %s, Message: %s", channel, message));
    }

    public void onSubscribe(String channel, int subscribedChannels) {
        System.out.println(String.format("Subscribed to channel: %s", channel));
    }

    public void onUnsubscribe(String channel, int subscribedChannels) {
        System.out.println(String.format("Unsubscribed from channel: %s", channel));
    }

    public void onPSubscribe(String pattern, int subscribedChannels) {
        System.out.println(String.format("Subscribed to pattern: %s", pattern));
    }

    public void onPUnsubscribe(String pattern, int subscribedChannels) {
        System.out.println(String.format("Unsubscribed from pattern: %s", pattern));
    }

    public void onPMessage(String pattern, String channel, String message) {
        System.out.println(String.format("Pattern: %s, Message: %s", pattern, message));
    }
}