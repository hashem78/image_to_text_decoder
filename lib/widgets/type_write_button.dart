import 'package:image_to_text_decoder/transcribe_bloc/transcribe_bloc.dart';
import 'package:image_to_text_decoder/type_writing_cubit/type_writing_cubit.dart';
import 'package:image_to_text_decoder/typewriter_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TypeWriteButton extends HookWidget {
  const TypeWriteButton({
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
    return BlocBuilder<TranscribeBloc, TranscribeState>(
      builder: (context, state) {
        return OutlinedButton.icon(
          icon: const Icon(Icons.keyboard),
          onPressed: state is TranscribeSuccessResponse
              ? () async {
                  final typeWritingCubit = context.read<TypeWritingCubit>();
                  typeWritingCubit.start();
                  KeyboardService(cubit: context.read<TypeWritingCubit>()).send(
                    state.data,
                    removePairs.value,
                    typeWriteSpeed.value,
                    typeWriteDelay.value,
                  );
                }
              : null,
          label: const Text('Type Write Decoded Text'),
        );
      },
    );
  }
}
