part of 'transcribe_bloc.dart';

@immutable
abstract class TranscribeState {}

class TranscribeInitial extends TranscribeState {}

class TranscribeWaitingForResponse extends TranscribeState {}

class TranscribeWaitingErrorResponse extends TranscribeState {
  final String error;
  TranscribeWaitingErrorResponse({
    required this.error,
  });
}

class TranscribeSuccessResponse extends TranscribeState {
  final String data;
  TranscribeSuccessResponse({
    required this.data,
  });
}

class TranscribeScreenshotTaken extends TranscribeState {
  final Uint8List data;

  TranscribeScreenshotTaken(this.data);
}

class TranscribeScreenshotPathChanged extends TranscribeState {
  final String screenShotPath;

  TranscribeScreenshotPathChanged({
    required this.screenShotPath,
  });
}

class TranscribeFilePathChanged extends TranscribeState {
  final String filePath;

  TranscribeFilePathChanged({
    required this.filePath,
  });
}

class TranscribeWriteToFileSet extends TranscribeState {
  final bool writeToFile;
  final String path;

  TranscribeWriteToFileSet({
    required this.writeToFile,
    required this.path,
  });
}
