import 'package:image_to_text_decoder/transcribe_bloc/transcribe_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScreenshotPreview extends StatelessWidget {
  const ScreenshotPreview({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<TranscribeBloc, TranscribeState>(
        buildWhen: (previous, current) {
          return current is TranscribeInitial ||
              current is TranscribeScreenshotTaken;
        },
        builder: (context, state) {
          if (state is TranscribeInitial) {
            return const Text("Take a screenshot");
          } else if (state is TranscribeScreenshotTaken) {
            return Image.memory(state.data);
          }
          return const SizedBox();
        },
      ),
    );
  }
}
