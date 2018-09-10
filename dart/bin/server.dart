import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:math';

Future main() async {
  var server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);
  server.forEach((HttpRequest request) async {
    var path = request.uri.pathSegments.first;
    print('Called ${request.uri}');
    if (path == 'redis') {
      return _handleRedis(request);
    }
    return _handleNotFound(request);
  });
  print('Listening on localhost:${server.port}');
}

Future _handleRedis(HttpRequest request) async {
  String content = await request.transform(Utf8Decoder()).join();
  Map json = jsonDecode(content);
  String ip = json['ip'];
  try {
    final parsedIP = Uri.parseIPv4Address(ip).reversed.toList();
    final score = [0, 1, 2, 3]
        .fold(0, (acc, elem) => acc + pow(256, elem) * parsedIP[elem]);
    // TODO: lookup score and possible IP in Redis
    request.response
      ..write(jsonEncode(score))
      ..close();
  } on FormatException {
    request.response
      ..statusCode = HttpStatus.badRequest
      ..write(jsonEncode({'error': 'Could not parse $ip as IPv4'}))
      ..close();
  }
}

void _handleNotFound(HttpRequest request) => request.response
  ..statusCode = HttpStatus.notFound
  ..close();
