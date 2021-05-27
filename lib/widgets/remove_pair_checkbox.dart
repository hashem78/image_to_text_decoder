import 'package:image_to_text_decoder/transcribe_bloc/transcribe_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class RemovePairsCheckBox extends HookWidget {
  const RemovePairsCheckBox({
    Key? key,
    required this.removePairs,
  }) : super(key: key);

  final ValueNotifier<bool> removePairs;

  @override
  Widget build(BuildContext context) {
    final val = useValueListenable(removePairs);
    return BlocBuilder<TranscribeBloc, TranscribeState>(
      builder: (context, state) {
        return Row(
          children: [
            Checkbox(
              value: val,
              onChanged: state is TranscribeSuccessResponse
                  ? (value) {
                      removePairs.value = value!;
                    }
                  : null,
            ),
            const Text("Remove bracket pairs"),
          ],
        );
      },
    );
  }
}
