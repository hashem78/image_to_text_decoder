import 'package:image_to_text_decoder/transcribe_bloc/transcribe_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurrentFilePathStatus extends StatelessWidget {
  const CurrentFilePathStatus({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TranscribeBloc, TranscribeState>(
      buildWhen: (previous, current) {
        return current is TranscribeInitial ||
            current is TranscribeFilePathChanged ||
            current is TranscribeWriteToFileChanged;
      },
      builder: (context, state) {
        if (state is TranscribeWriteToFileChanged) {
          if (state.blocData.writeToFile) {
            return Text(state.blocData.filePath);
          }
        }
        return Text(state.blocData.filePath);
      },
    );
  }
}
