const express = require('express');
const app = express();

app.get('/lookup/:ip', async (req, res) => {
    const ip = req.params.ip;
    const value = await lookup(ip);
    res.send(value);
});

app.listen(3000, () => console.log('Checkout http://localhost:3000/lookup/1.2.3.4'));

const asyncRedis = require("async-redis");
const client = asyncRedis.createClient(process.env.REDIS_URL || 'redis://localhost:6379/0');
client.on("error", err => console.log("Redis Error: " + err));

async function lookup(ip) {
    const score = ip2int(ip);
    const ids = await client.zrangebyscore('geoip:index', score, '+inf', 'LIMIT', 0, 1);
    const key = `geoip:${ids[0].slice(0,2)}`;
    return await client.hgetall(key);
}

function ip2int(ip) {
    return ip.split('.').reduce((ipInt, octet) => (ipInt << 8) + parseInt(octet, 10), 0) >>> 0;
}