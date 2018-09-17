import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:math';

import 'package:dartis/dartis.dart' show Client;

Client redisClient;

Future main() async {
  final String url = Platform.environment.containsKey('REDIS_URL')
      ? Platform.environment['REDIS_URL']
      : 'redis://localhost:6379';
  redisClient = await Client.connect(url);

  final server = await HttpServer.bind(InternetAddress.anyIPv4, 8080);
  server.forEach((HttpRequest request) async {
    try {
      final paths = request.uri.pathSegments;
      if (paths.isEmpty || paths.first != 'lookup')
        return _handleNotFound(request);
      return _handleLookup(request);
    } catch (e) {
      print(e.toString());
      request.response
        ..statusCode = HttpStatus.internalServerError
        ..write(e.toString())
        ..close();
    }
  });
  print('Listening on localhost:${server.port}');
}

void _handleNotFound(HttpRequest request) => request.response
  ..statusCode = HttpStatus.notFound
  ..close();

Future _handleLookup(HttpRequest request) async {
  final String ip = request.uri.pathSegments[1];
  final value = await lookup(ip);
  request.response
    ..write(jsonEncode(value))
    ..close();
}

Future lookup(String ip) async {
  final parsedIP = Uri.parseIPv4Address(ip).reversed.toList();
  final score = [0, 1, 2, 3]
      .fold(0, (acc, elem) => acc + pow(256, elem) * parsedIP[elem]);
  final redis = redisClient.asCommands<String, String>();
  final Map<String, double> ids = await redis.zrangebyscore(
      'geoip:index', score.toString(), '+inf',
      offset: 0, count: 1);
  String key = "geoip:${ids.keys.first.substring(0, 2)}";
  final value = await redis.hgetall(key);
  return value;
}
