import 'package:image_to_text_decoder/transcribe_bloc/transcribe_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:file_selector/file_selector.dart' as file_selector;

import 'package:flutter_bloc/flutter_bloc.dart';

class ToolBoxButtons extends HookWidget {
  const ToolBoxButtons({
    Key? key,
    required this.useFiles,
  }) : super(key: key);

  final ValueNotifier<bool> useFiles;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.camera_alt),
          onPressed: () async {
            final dirPath = await file_selector.getDirectoryPath();

            if (dirPath != null) {
              context.read<TranscribeBloc>().add(
                    TranscribeChangeScreenShotDirectoryEvent(path: dirPath),
                  );
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.file_copy),
          onPressed: useValueListenable(useFiles)
              ? () async {
                  final filePath = await file_selector.openFile();

                  if (filePath != null) {
                    context.read<TranscribeBloc>().add(
                          TranscribeChangeFilePath(
                            path: filePath.path,
                          ),
                        );
                  }
                }
              : null,
        ),
      ],
    );
  }
}
