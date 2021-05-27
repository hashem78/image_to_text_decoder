import 'package:image_to_text_decoder/type_writing_cubit/type_writing_cubit.dart';
import 'package:image_to_text_decoder/typewriter_service.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TypeWriteClipboardButton extends StatelessWidget {
  const TypeWriteClipboardButton({
    Key? key,
    required this.removePairs,
    required this.typeWriteSpeed,
    required this.typeWriteDelay,
  }) : super(key: key);

  final ValueNotifier<bool> removePairs;
  final ValueNotifier<int> typeWriteSpeed;
  final ValueNotifier<int> typeWriteDelay;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () async {
        final clipBoardText = await FlutterClipboard.paste();
        final typeWritingCubit = context.read<TypeWritingCubit>();
        typeWritingCubit.start();
        KeyboardService(cubit: typeWritingCubit).send(
          clipBoardText,
          removePairs.value,
          typeWriteSpeed.value,
          typeWriteDelay.value,
        );
      },
      icon: const Icon(
        Icons.keyboard,
        color: Colors.green,
      ),
      label: const Text(
        'Type Write From Clipboard',
        style: TextStyle(color: Colors.red),
      ),
    );
  }
}
