import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:clipboard_getter/clipboard_getter.dart';
import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

part 'clipboard_monitor_event.dart';
part 'clipboard_monitor_state.dart';

class ClipboardMonitorBloc
    extends Bloc<ClipboardMonitorEvent, ClipboardMonitorState> {
  ClipboardMonitorBloc() : super(ClipboardMonitorInitial());
  Uint8List? clipboard;
  Timer? timer;

  Future<void> init() async {
    final eq = const DeepCollectionEquality().equals;
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) async {
        try {
          final currentClipboard = await ClipboardGetter.getClipboardData();

          if (currentClipboard != null) {
            if (clipboard == null) {
              clipboard = currentClipboard;
              add(ClipboardMonitorEventData(clipboard));
            } else {
              if (!eq(clipboard!.toList(), currentClipboard.toList())) {
                clipboard = currentClipboard;
                add(ClipboardMonitorEventData(clipboard));
              }
            }
          }
          // ignore: empty_catches
        } on PlatformException {}
      },
    );
  }

  @override
  Stream<ClipboardMonitorState> mapEventToState(
    ClipboardMonitorEvent event,
  ) async* {
    if (event is ClipboardMonitorEventEnable) {
      init();
    } else if (event is ClipboardMonitorEventDisable) {
      cleanUp();
      yield (ClipboardMonitorInitial());
    } else if (event is ClipboardMonitorEventData) {
      yield ClipboardMonitorDataChanged(event.data);
    }
  }

  Future<void> cleanUp() async {
    timer?.cancel();
  }

  @override
  Future<void> close() {
    cleanUp();
    return super.close();
  }
}
