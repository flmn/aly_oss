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

    print(_id);
  }

  static Future<dynamic> _handler(MethodCall methodCall) {
    print(
        'Call from platform: method=${methodCall.method}, arguments=${methodCall.arguments}');

    return Future.value(true);
  }

  Future<Map<String, dynamic>> init() async {
    return await _channel.invokeMapMethod<String, dynamic>('init');
  }

  Future<Map<String, dynamic>> upload() async {
    return await _channel.invokeMapMethod<String, dynamic>('upload');
  }
}
