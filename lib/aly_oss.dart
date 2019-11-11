import 'dart:async';

import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

class AlyOss {
  static final _channel = MethodChannel('jitao.tech/aly_oss')
    ..setMethodCallHandler(_handler);
  static final _instances = new Map<String, AlyOss>();
  static final _uuid = new Uuid();
  String _id;

  AlyOss() {
    _id = _uuid.v4();
    _instances[_id] = this;

    print('AlyOss: ' + _id);
  }

  static Future<dynamic> _handler(MethodCall methodCall) {
    print(
        'Call from platform: method=${methodCall.method}, arguments=${methodCall.arguments}');

    return Future.value(true);
  }

  Future<Map<String, dynamic>> init() async {
    return await _invokeMethod(
        'init', {'endpoint': 'oss-cn-beijing.aliyuncs.com'});
  }

  Future<Map<String, dynamic>> upload(
      String bucket, String key, String file) async {
    return await _invokeMethod(
        'upload', {'bucket': bucket, "key": key, "file": file});
  }

  Future<Map<String, dynamic>> _invokeMethod(String method,
      [Map<String, dynamic> arguments = const {}]) {
    Map<String, dynamic> withId = Map.of(arguments);
    withId['id'] = _id;

    return _channel.invokeMapMethod(method, withId);
  }
}
