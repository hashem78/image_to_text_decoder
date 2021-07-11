import 'package:image_to_text_decoder/transcribe_bloc/transcribe_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WaitingForTranscriptionWidget extends StatelessWidget {
  const WaitingForTranscriptionWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TranscribeBloc, TranscribeState>(
      builder: (context, state) {
        if (state is TranscribeWaitingForResponse) {
          return const LinearProgressIndicator();
        }
        return const SizedBox();
      },
    );
  }
}
