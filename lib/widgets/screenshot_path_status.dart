import 'package:image_to_text_decoder/transcribe_bloc/transcribe_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScreenshotPathStatus extends StatelessWidget {
  const ScreenshotPathStatus({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TranscribeBloc, TranscribeState>(
      buildWhen: (previous, current) {
        return current is TranscribeInitial ||
            current is TranscribeScreenshotPathChanged;
      },
      builder: (context, state) {
        if (state is TranscribeInitial) {
          return Text(context.read<TranscribeBloc>().screenShotPath);
        } else if (state is TranscribeScreenshotPathChanged) {
          return Text(context.read<TranscribeBloc>().screenShotPath);
        }
        return Container();
      },
    );
  }
}
