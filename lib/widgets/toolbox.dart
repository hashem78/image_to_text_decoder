import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_to_text_decoder/transcribe_bloc/transcribe_bloc.dart';
import 'package:image_to_text_decoder/widgets/toolbox_buttons.dart';
import 'package:image_to_text_decoder/widgets/remove_pair_checkbox.dart';
import 'package:image_to_text_decoder/widgets/stop_type_writing_button.dart';
import 'package:image_to_text_decoder/widgets/type_write_button.dart';
import 'package:image_to_text_decoder/widgets/type_write_clipboard_button.dart';
import 'package:image_to_text_decoder/widgets/type_writing_delay_delay_slider.dart';
import 'package:image_to_text_decoder/widgets/typewrite_speed_slider.dart';
import 'package:image_to_text_decoder/widgets/write_to_file_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ToolBox extends HookWidget {
  const ToolBox({
    Key? key,
    required this.useFiles,
    required this.removePairs,
    required this.useClipboard,
  }) : super(key: key);

  final ValueNotifier<bool> useFiles;
  final ValueNotifier<bool> removePairs;
  final ValueNotifier<bool> useClipboard;

  @override
  Widget build(BuildContext context) {
    final typeWriteSpeed = useValueNotifier<int>(5);
    final typeWriteDelay = useValueNotifier<int>(3);
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ToolBoxButtons(useFiles: useFiles),
              WriteToFileCheckBox(useFiles: useFiles),
              RemovePairsCheckBox(removePairs: removePairs),
              UseClipboardCheckBox(useClipboard: useClipboard)
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.all(5.0),
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            border: Border.all(width: 3, color: Colors.green),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          child: Column(
            children: [
              TypeWriteDelaySlider(
                typeWriteDelay: typeWriteDelay,
              ),
              TypeWriteSpeedSlider(
                typeWriteSpeed: typeWriteSpeed,
              ),
            ],
          ),
        ),
        const StopTypeWritingButton(),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TypeWriteClipboardButton(
              removePairs: removePairs,
              typeWriteSpeed: typeWriteSpeed,
              typeWriteDelay: typeWriteDelay,
            ),
            TypeWriteButton(
              removePairs: removePairs,
              typeWriteSpeed: typeWriteSpeed,
              typeWriteDelay: typeWriteDelay,
            ),
          ],
        ),
      ],
    );
  }
}

class UseClipboardCheckBox extends HookWidget {
  const UseClipboardCheckBox({
    Key? key,
    required this.useClipboard,
  }) : super(key: key);

  final ValueNotifier<bool> useClipboard;

  @override
  Widget build(BuildContext context) {
    final val = useValueListenable(useClipboard);
    return BlocBuilder<TranscribeBloc, TranscribeState>(
      builder: (context, state) {
        return Row(
          children: [
            Checkbox(
              value: val,
              onChanged: (value) {
                useClipboard.value = value!;
                if (value) {
                  context.read<TranscribeBloc>().enableClipboardWatching();
                } else {
                  context.read<TranscribeBloc>().disableClipboardWatching();
                }
              },
            ),
            const Text("Clipboard Images"),
          ],
        );
      },
    );
  }
}
