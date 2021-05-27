import 'dart:io';

import 'package:image_to_text_decoder/type_writing_cubit/type_writing_cubit.dart';
import 'package:image_to_text_decoder/widgets/cheating_toolbox.dart';
import 'package:image_to_text_decoder/widgets/current_file_path.dart';
import 'package:image_to_text_decoder/widgets/screenshot_path_status.dart';
import 'package:image_to_text_decoder/widgets/screenshot_preview.dart';
import 'package:image_to_text_decoder/widgets/transcription_response_view.dart';
import 'package:image_to_text_decoder/widgets/waiting_for_transcription_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:path_provider/path_provider.dart';
import 'package:window_size/window_size.dart' as window_size;

import 'package:image_to_text_decoder/repositories/aws_transcription_repository.dart';
import 'package:image_to_text_decoder/transcribe_bloc/transcribe_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  window_size.setWindowMaxSize(const Size(500, 600));
  window_size.setWindowMinSize(const Size(500, 600));
  var filePath = await AWSTranscriptionRepository.getFilePath();
  if (filePath == null) {
    final tempFile = await File('main.cpp').create();
    filePath = tempFile.path;
  }
  final screenShotPath = await AWSTranscriptionRepository.getSreenshotPath() ??
      (await getApplicationDocumentsDirectory()).path;

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TranscribeBloc()
            ..setDirectoryWatcher(screenShotPath)
            ..setFilePath(filePath!),
        ),
        BlocProvider(
          create: (_) => TypeWritingCubit(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainPage(),
    );
  }
}

class MainPage extends HookWidget {
  const MainPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final removePairs = useValueNotifier(false);
    final useFiles = useValueNotifier(true);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (useValueListenable(useFiles)) const CurrentFilePathStatus(),
          const ScreenshotPathStatus(),
          const Expanded(child: ScreenshotPreview()),
          const WaitingForTranscriptionWidget(),
          CheatingToolBox(useFiles: useFiles, removePairs: removePairs),
          const Expanded(child: TranscriptionResponseView())
        ],
      ),
    );
  }
}
