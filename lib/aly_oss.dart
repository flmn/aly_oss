import 'dart:async';

import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

class AlyOss {
  static final _channel = MethodChannel('jitao.tech/aly_oss')
    ..setMethodCallHandler(_handler);
  static final _instances = Map<String, AlyOss>();
  static final _uuid = Uuid();
  String _instanceId;

  AlyOss() {
    _instanceId = _uuid.v4();
    _instances[_instanceId] = this;

    print('AlyOss: ' + _instanceId);
  }

  static Future<dynamic> _handler(MethodCall methodCall) async {
    switch (methodCall.method) {
      case 'onProgress':
        break;
      case 'onUpload':
        break;
      default:
        print(
            'Call ${methodCall.method} from platform, arguments=${methodCall.arguments}');
    }

    return Future.value(true);
  }

  Future<Map<String, dynamic>> init(InitRequest request) async {
    return await _invokeMethod('init', request.toMap());
  }

  Future<Map<String, dynamic>> upload(UploadRequest request) async {
    return await _invokeMethod('upload', request.toMap());
  }

  Future<Map<String, dynamic>> _invokeMethod(String method,
      [Map<String, dynamic> arguments = const {}]) {
    Map<String, dynamic> withId = Map.of(arguments);
    withId['instanceId'] = _instanceId;

    return _channel.invokeMapMethod(method, withId);
  }
}

abstract class Request {
  final String requestId;

  Request(this.requestId);

  Map<String, dynamic> toMap() {
    return {'requestId': requestId};
  }
}

class InitRequest extends Request {
  final String stsServer;
  final String endpoint;
  final String aesKey;
  final String iv;

  InitRequest(requestId, this.stsServer, this.endpoint, this.aesKey, this.iv)
      : super(requestId);

  Map<String, dynamic> toMap() {
    var m = Map.of(super.toMap());
    m['stsServer'] = stsServer;
    m['endpoint'] = endpoint;
    m['aesKey'] = aesKey;
    m['iv'] = iv;

    return m;
  }
}

class UploadRequest extends Request {
  final String bucket;
  final String key;
  final String file;

  UploadRequest(requestId, this.bucket, this.key, this.file) : super(requestId);

  Map<String, dynamic> toMap() {
    var m = Map.of(super.toMap());
    m['bucket'] = bucket;
    m['key'] = key;
    m['file'] = file;

    return m;
  }
}
