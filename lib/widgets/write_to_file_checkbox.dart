import 'package:image_to_text_decoder/transcribe_bloc/transcribe_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WriteToFileCheckBox extends HookWidget {
  const WriteToFileCheckBox({
    Key? key,
    required this.useFiles,
  }) : super(key: key);

  final ValueNotifier<bool> useFiles;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: useValueListenable(useFiles),
          onChanged: (value) {
            useFiles.value = value!;
            context.read<TranscribeBloc>().add(
                  TranscribeChangeWriteToFile(writeToFile: value),
                );
          },
        ),
        const Text("Write to file"),
      ],
    );
  }
}
