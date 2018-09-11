import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:math';

import 'package:dartis/dartis.dart' show Client;

Future main() async {
  // TODO: expose on 0.0.0.0 via Docker
  var server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);
  server.forEach((HttpRequest request) async {
    try {
      var paths = request.uri.pathSegments;
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

Future lookup(ip) async {
  final parsedIP = Uri.parseIPv4Address(ip).reversed.toList();
  final score = [0, 1, 2, 3]
      .fold(0, (acc, elem) => acc + pow(256, elem) * parsedIP[elem]);
  // TODO: make redis configurable (env:REDIS_URL || default)
  final client = await Client.connect('redis://localhost:6379');
  final commands = client.asCommands<String, String>();
  final Map<String, double> ids = await commands.zrangebyscore(
      'geoip:index', score.toString(), '+inf',
      offset: 0, count: 1);
  String key = "geoip:${ids.keys.first.substring(0, 2)}";
  final value = await commands.hgetall(key);
  return value;
}
