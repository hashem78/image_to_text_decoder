import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:image_to_text_decoder/repositories/aws_transcription_repository.dart';
import 'package:image_to_text_decoder/transcribe_bloc/transcribe_bloc_data.dart';

import 'package:meta/meta.dart';
import 'package:watcher/watcher.dart';
import 'package:clipboard/clipboard.dart';

part 'transcribe_event.dart';
part 'transcribe_state.dart';

class TranscribeBloc extends HydratedBloc<TranscribeEvent, TranscribeState> {
  TranscribeBloc({
    bool writeToFile = true,
  })  : assert(
          AWSTranscriptionRepository.isReady,
          "Call init on AWSTranscriptionRepository",
        ),
        super(
          TranscribeInitial(
            filePath: HydratedBloc.storage.read('filePath'),
            screenShotPath: HydratedBloc.storage.read('screenshotPath'),
            writeToFile: HydratedBloc.storage.read('writeToFile'),
          ),
        ) {
    _setDirectoryWatcher(HydratedBloc.storage.read('screenshotPath'));
  }

  StreamSubscription? _directoryWatcherSubscription;
  static Stream<WatchEvent> _getDirectoryWatchStream(String path) {
    return DirectoryWatcher(path)
        .events
        .where((event) => event.type == ChangeType.ADD);
  }

  void _setDirectoryWatcher(String path) {
    _directoryWatcherSubscription?.cancel();

    _directoryWatcherSubscription =
        TranscribeBloc._getDirectoryWatchStream(path).listen(
      (_) {
        File(_.path).readAsBytes().then(
          (value) {
            add(TranscribeScreenshotEvent(data: value));
          },
        );
      },
    );
  }

  @override
  Stream<TranscribeState> mapEventToState(
    TranscribeEvent event,
  ) async* {
    if (event is TranscribeChangeScreenShotDirectoryEvent) {
      if (event.path != state.blocData.screenShotPath) {
        AWSTranscriptionRepository.changeScreenshotPath(event.path);

        yield TranscribeScreenshotPathChanged(
          blocData: state.blocData.copyWith(screenShotPath: event.path),
        );

        _setDirectoryWatcher(event.path);
      }
    } else if (event is TranscribeErrorEvent) {
      yield TranscribeWaitingErrorResponse(
        blocData: state.blocData,
        error: event.error,
      );
    } else if (event is TranscribeSuccessEvent) {
      yield TranscribeSuccessResponse(
        blocData: state.blocData,
        data: event.data,
      );
      if (state.blocData.writeToFile) {
        AWSTranscriptionRepository.writeToFile(
            state.blocData.filePath, event.data);
      }
      FlutterClipboard.copy(event.data);
    } else if (event is TranscribeChangeFilePath) {
      AWSTranscriptionRepository.changeFilePath(event.path);
      yield TranscribeFilePathChanged(
        blocData: state.blocData.copyWith(filePath: event.path),
      );
    } else if (event is TranscribeScreenshotEvent) {
      yield TranscribeScreenshotTaken(
        blocData: state.blocData,
        data: event.data,
      );
      yield TranscribeWaitingForResponse(blocData: state.blocData);
      await Future.delayed(const Duration(seconds: 2));
      AWSTranscriptionRepository.request(event.data).then(
        (value) => add(TranscribeSuccessEvent(data: value)),
        onError: (error) => add(TranscribeErrorEvent(error: error)),
      );
    } else if (event is TranscribeChangeWriteToFile) {
      yield TranscribeWriteToFileChanged(
        blocData: state.blocData.copyWith(writeToFile: event.writeToFile),
      );
    }
  }

  @override
  Future<void> close() async {
    _directoryWatcherSubscription?.cancel();
    super.close();
  }

  @override
  TranscribeState? fromJson(Map<String, dynamic> json) {
    return TranscribeInitial(
      filePath: json['filePath'],
      screenShotPath: json['screenShotPath'],
      writeToFile: json['writeToFile'],
    );
  }

  @override
  Map<String, dynamic>? toJson(TranscribeState state) {
    return state.blocData.toMap();
  }
}
