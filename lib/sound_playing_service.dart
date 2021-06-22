import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

class SoundPlayingService {
  static void play() {
    if (Platform.isWindows) {
      Pointer<Utf16> sound = "SystemExclamation".toNativeUtf16();
      PlaySound(sound, 0, SND_ASYNC | SND_ALIAS);
      free(sound);
    }
  }
}
