import 'package:flutter/foundation.dart';

class AppLogger {
  static void log(String msg) {
    assert(() {
      debugPrint('[Nexus] $msg');
      return true;
    }());
  }
}
