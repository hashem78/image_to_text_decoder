import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:clipboard/clipboard.dart';
import 'package:meta/meta.dart';

import '../typewriter_service.dart';

part 'type_writing_state.dart';

class TypeWritingCubit extends Cubit<TypeWritingState> {
  TypeWritingCubit() : super(TypeWritingInitial());
  void reset() {
    emit(TypeWritingInitial());
  }

  Future<void> start({
    String? payload,
    required bool removePairs,
    required int typeWriteSpeed,
    required int typeWriteDelay,
  }) async {
    if (state is TypeWritingInitial) {
      final payLoad = payload ?? await FlutterClipboard.paste();
      if (Platform.isWindows) {
        KeyboardService(cubit: this).sendWindows(
          payLoad,
          removePairs,
          typeWriteSpeed,
          typeWriteDelay,
        );
      } else if (Platform.isLinux) {
        KeyboardService(cubit: this).sendLinux(
          payLoad,
          removePairs,
          typeWriteSpeed,
          typeWriteDelay,
        );
      }
      emit(TypeWritingWorking());
    }
  }

  void stop() {
    if (state is TypeWritingWorking) {
      emit(TypeWritingStopped());
    }
  }
}
