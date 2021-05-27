part of 'transcribe_bloc.dart';

@immutable
abstract class TranscribeEvent {}

class TranscribeChangeScreenShotDirectoryEvent extends TranscribeEvent {
  final String path;
  TranscribeChangeScreenShotDirectoryEvent({
    required this.path,
  });
}

class TranscribeScreenshotEvent extends TranscribeEvent {
  final Uint8List data;
  TranscribeScreenshotEvent({
    required this.data,
  });
}

class TranscribeErrorEvent extends TranscribeEvent {
  final String error;
  TranscribeErrorEvent({
    required this.error,
  });
}

class TranscribeSuccessEvent extends TranscribeEvent {
  final String data;
  TranscribeSuccessEvent({
    required this.data,
  });
}

class TranscribeChangeFilePath extends TranscribeEvent {
  final String path;
  TranscribeChangeFilePath({
    required this.path,
  });
}

class TranscribeChangeWriteToFile extends TranscribeEvent {
  final bool writeToFile;

  TranscribeChangeWriteToFile({
    required this.writeToFile,
  });
}
