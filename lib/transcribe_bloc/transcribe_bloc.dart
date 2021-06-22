import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:image_to_text_decoder/repositories/aws_transcription_repository.dart';
import 'package:image_to_text_decoder/sound_playing_service.dart';
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

  void _setDirectoryWatcher(String path) {
    _directoryWatcherSubscription?.cancel();

    _directoryWatcherSubscription = DirectoryWatcher(path)
        .events
        .where((event) => event.type == ChangeType.ADD)
        .listen(
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
      SoundPlayingService.play();
      yield TranscribeWaitingErrorResponse(
        blocData: state.blocData,
        error: event.error,
      );
    } else if (event is TranscribeSuccessEvent) {
      SoundPlayingService.play();
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
      AWSTranscriptionRepository.request(event.data).then(
        (value) => add(TranscribeSuccessEvent(data: value)),
        onError: (error) {
          add(TranscribeErrorEvent(error: error.toString()));
        },
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
