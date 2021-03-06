const app = require('express')();

require('./routes').init(app);

const http = require('http').Server(app);
const io = require('socket.io')(http);

const redisAdapter = require('socket.io-redis');
io.adapter(redisAdapter(process.env.REDIS_URL || 'redis://localhost:6379'));
io.of('/').adapter.on('error', err => console.log("Socket.Io Error: " + err));

io.on('connection', socket => {
    console.log('a user connected');
    socket.broadcast.emit('hi');
    socket.on('disconnect', () => console.log('user disconnected'));
    socket.on('chat message', msg => {
        console.log('message: ' + msg);
        io.emit('chat message', msg);
    });
});

http.listen(3000, () => console.log('listening on *:3000'));