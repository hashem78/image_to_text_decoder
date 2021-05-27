import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:image_to_text_decoder/repositories/aws_transcription_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:meta/meta.dart';
import 'package:watcher/watcher.dart';
import 'package:clipboard/clipboard.dart';

part 'transcribe_event.dart';
part 'transcribe_state.dart';

class TranscribeBloc extends Bloc<TranscribeEvent, TranscribeState> {
  TranscribeBloc({
    this.writeToFile = true,
  }) : super(TranscribeInitial());

  late String screenShotPath;
  late String filePath;
  bool writeToFile;

  StreamSubscription? directoryWatcherSubscription;
  static Stream<WatchEvent> getDirectoryWatchStream(String path) {
    return DirectoryWatcher(path)
        .events
        .where((event) => event.type == ChangeType.ADD);
  }

  void setDirectoryWatcher(String path) {
    directoryWatcherSubscription?.cancel();
    screenShotPath = path;
    directoryWatcherSubscription =
        TranscribeBloc.getDirectoryWatchStream(path).listen(
      (_) {
        File(_.path).readAsBytes().then(
          (value) {
            add(TranscribeScreenshotEvent(data: value));
          },
        );
      },
    );
  }

  void setWriteToFile(bool value) {
    writeToFile = value;
  }

  void setFilePath(String path) {
    filePath = path;
    AWSTranscriptionRepository.changeFilePath(path);
  }

  @override
  Stream<TranscribeState> mapEventToState(
    TranscribeEvent event,
  ) async* {
    if (event is TranscribeChangeScreenShotDirectoryEvent) {
      if (event.path != screenShotPath) {
        AWSTranscriptionRepository.changeScreenshotPath(event.path);
        screenShotPath = event.path;
        yield TranscribeScreenshotPathChanged(screenShotPath: screenShotPath);

        setDirectoryWatcher(event.path);
      }
    } else if (event is TranscribeErrorEvent) {
      yield TranscribeWaitingErrorResponse(error: event.error);
    } else if (event is TranscribeSuccessEvent) {
      yield TranscribeSuccessResponse(data: event.data);
      if (writeToFile) {
        AWSTranscriptionRepository.writeToFile(filePath, event.data);
      }
      FlutterClipboard.copy(event.data);
    } else if (event is TranscribeChangeFilePath) {
      setFilePath(event.path);
      yield TranscribeFilePathChanged(filePath: filePath);
    } else if (event is TranscribeScreenshotEvent) {
      yield TranscribeScreenshotTaken(event.data);
      yield TranscribeWaitingForResponse();
      await Future.delayed(const Duration(seconds: 2));
      AWSTranscriptionRepository.request(event.data).then(
        (value) => add(TranscribeSuccessEvent(data: value)),
        onError: (error) => add(TranscribeErrorEvent(error: error)),
      );
    } else if (event is TranscribeChangeWriteToFile) {
      setWriteToFile(event.writeToFile);
      yield TranscribeWriteToFileSet(
        writeToFile: writeToFile,
        path: filePath,
      );
    }
  }

  @override
  Future<void> close() async {
    directoryWatcherSubscription?.cancel();
    super.close();
  }
}
