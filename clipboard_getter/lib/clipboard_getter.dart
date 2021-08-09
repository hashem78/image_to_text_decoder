import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';

class ClipboardGetter {
  // ignore: prefer_final_fields
  static MethodChannel _channel = const MethodChannel('clipboard_getter');

  static Future<Uint8List?> getClipboardData() async {
    final data = await _channel.invokeMethod('getClipboardData');

    return data;
  }
}
