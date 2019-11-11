import 'dart:async';

import 'package:flutter/services.dart';

class AlyOss {
  static const MethodChannel _channel =
      const MethodChannel('aly_oss');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
