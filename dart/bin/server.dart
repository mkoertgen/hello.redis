import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:math';

Future main() async {
  var server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);
  server.forEach((HttpRequest request) async {
    try {
      var paths = request.uri.pathSegments;
      if (paths.isEmpty || paths.first != 'lookup') return _handleNotFound(request);
      return _handleLookup(request);
    } on Exception catch(e) {
      print(e.toString());
      request.response
        ..statusCode = HttpStatus.internalServerError
        ..write(e.toString())
        ..close();
    }
  });
  print('Listening on localhost:${server.port}');
}

Future _handleLookup(HttpRequest request) async {
  String ip = request.uri.pathSegments[1];
  var redis = null; // TODO
  var value = lookup(null, ip);
  request.response
    ..write(jsonEncode(value))
    ..close();
}

void _handleNotFound(HttpRequest request) => request.response
  ..statusCode = HttpStatus.notFound
  ..close();

void lookup(redis, ip) {
  final parsedIP = Uri.parseIPv4Address(ip).reversed.toList();
  final score = [0, 1, 2, 3]
      .fold(0, (acc, elem) => acc + pow(256, elem) * parsedIP[elem]);
  // TODO: lookup score and possible IP in Redis
  return score;
  // redis.ZRangeByScore ...
  // redis.HGetAll ...
}