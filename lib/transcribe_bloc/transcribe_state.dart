part of 'transcribe_bloc.dart';

@immutable
abstract class TranscribeState {
  final TranscribeBlocData blocData;
  const TranscribeState({
    required this.blocData,
  });
}

class TranscribeInitial extends TranscribeState {
  TranscribeInitial({
    required String filePath,
    required String screenShotPath,
    required bool writeToFile,
  }) : super(
          blocData: TranscribeBlocData(
            filePath: filePath,
            screenShotPath: screenShotPath,
            writeToFile: writeToFile,
          ),
        );
}

class TranscribeWaitingForResponse extends TranscribeState {
  const TranscribeWaitingForResponse({
    required TranscribeBlocData blocData,
  }) : super(
          blocData: blocData,
        );
}

class TranscribeWaitingErrorResponse extends TranscribeState {
  final String error;
  const TranscribeWaitingErrorResponse({
    required this.error,
    required TranscribeBlocData blocData,
  }) : super(blocData: blocData);
}

class TranscribeSuccessResponse extends TranscribeState {
  final String data;

  const TranscribeSuccessResponse({
    required this.data,
    required TranscribeBlocData blocData,
  }) : super(blocData: blocData);
}

class TranscribeScreenshotTaken extends TranscribeState {
  final Uint8List data;

  const TranscribeScreenshotTaken({
    required this.data,
    required TranscribeBlocData blocData,
  }) : super(blocData: blocData);
}

class TranscribeScreenshotPathChanged extends TranscribeState {
  const TranscribeScreenshotPathChanged({
    required TranscribeBlocData blocData,
  }) : super(blocData: blocData);
}

class TranscribeFilePathChanged extends TranscribeState {
  const TranscribeFilePathChanged({
    required TranscribeBlocData blocData,
  }) : super(blocData: blocData);
}

class TranscribeWriteToFileChanged extends TranscribeState {
  const TranscribeWriteToFileChanged({
    required TranscribeBlocData blocData,
  }) : super(blocData: blocData);
}
