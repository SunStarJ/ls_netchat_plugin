import 'dart:async';

import 'package:flutter/services.dart';

class Lsnetchatplugin {
  static const MethodChannel _channel =
      const MethodChannel('lsnetchatplugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
