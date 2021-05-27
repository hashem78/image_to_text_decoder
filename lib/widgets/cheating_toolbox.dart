import 'package:image_to_text_decoder/widgets/cheating_buttons.dart';
import 'package:image_to_text_decoder/widgets/remove_pair_checkbox.dart';
import 'package:image_to_text_decoder/widgets/stop_type_writing_button.dart';
import 'package:image_to_text_decoder/widgets/type_write_button.dart';
import 'package:image_to_text_decoder/widgets/type_write_clipboard_button.dart';
import 'package:image_to_text_decoder/widgets/type_writing_delay_delay_slider.dart';
import 'package:image_to_text_decoder/widgets/typewrite_speed_slider.dart';
import 'package:image_to_text_decoder/widgets/write_to_file_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CheatingToolBox extends HookWidget {
  const CheatingToolBox({
    Key? key,
    required this.useFiles,
    required this.removePairs,
  }) : super(key: key);

  final ValueNotifier<bool> useFiles;
  final ValueNotifier<bool> removePairs;

  @override
  Widget build(BuildContext context) {
    final typeWriteSpeed = useValueNotifier<int>(5);
    final typeWriteDelay = useValueNotifier<int>(3);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CheatingButtons(useFiles: useFiles),
            WriteToFileCheckBox(useFiles: useFiles),
            RemovePairsCheckBox(removePairs: removePairs),
          ],
        ),
        Container(
          margin: const EdgeInsets.all(5.0),
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            border: Border.all(width: 3, color: Colors.green),
            borderRadius: BorderRadius.all(Radius.circular(5)),
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
        Row(
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
