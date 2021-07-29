import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

import 'package:image_to_text_decoder/type_writing_cubit/type_writing_cubit.dart';

class KeyboardService {
  final TypeWritingCubit cubit;
  KeyboardService({
    required this.cubit,
  });
  void sendEnter() {
    final kb = calloc<INPUT>()..ref.type = INPUT_KEYBOARD;
    kb.ref.type = INPUT_KEYBOARD;
    kb.ki.wVk = VK_RETURN;

    SendInput(1, kb, sizeOf<INPUT>());
    kb.ki.dwFlags = KEYEVENTF_KEYUP;
    SendInput(1, kb, sizeOf<INPUT>());
    free(kb);
  }

  Future<void> sendWindows(
    String payload,
    bool removePairs,
    int speed,
    int delay,
  ) async {
    await Future.delayed(Duration(seconds: delay));
    final kb = calloc<INPUT>()..ref.type = INPUT_KEYBOARD;
    final completer = Completer();
    final subscription = cubit.stream.listen(
      (state) {
        if (state is TypeWritingStopped) {
          completer.complete();
        }
      },
    );
    for (final rune in payload.runes) {
      if (rune != 10) {
        kb.ki.wScan = rune;
        kb.ki.dwFlags = KEYEVENTF_UNICODE;
        SendInput(1, kb, sizeOf<INPUT>());
        kb.ki.dwFlags = KEYEVENTF_KEYUP;
        SendInput(1, kb, sizeOf<INPUT>());
        if (removePairs && (rune == 41 || rune == 62 || rune == 125)) {
          kb.ki.wVk = VK_BACK;
          SendInput(1, kb, sizeOf<INPUT>());
          kb.ki.wVk = 0;
          kb.ki.dwFlags = KEYEVENTF_KEYUP;
          SendInput(1, kb, sizeOf<INPUT>());
        }
      } else {
        sendEnter();
      }
      await Future.delayed(Duration(milliseconds: speed.toInt() * 100));
      if (completer.isCompleted) {
        free(kb);
        cubit.reset();
        subscription.cancel();
        return;
      }
    }
    cubit.reset();
    free(kb);
    subscription.cancel();
  }

  Future<void> sendLinux(
    String payload,
    bool removePairs,
    int speed,
    int delay,
  ) async {
    await Future.delayed(Duration(seconds: delay));
    final completer = Completer();
    final subscription = cubit.stream
        .map(
          (event) => event is TypeWritingStopped,
        )
        .listen(
          (_) => completer.complete(),
        );
    completer.future.whenComplete(
      () async {
        await Process.run(
          'killall',
          ['-9', 'xdotool'],
        );
        cubit.reset();
        subscription.cancel();
      },
    );
    if (removePairs) {
      await Process.run(
        'xdotool',
        [
          'type',
          '--delay',
          (speed * 100).toString(),
          payload.replaceAll(RegExp(r'[\)\}]'), '')
        ],
      );
    } else {
      await Process.run(
        'xdotool',
        ['type', '--delay', (speed * 100).toString(), payload],
      );
    }
    cubit.reset();
  }
}
