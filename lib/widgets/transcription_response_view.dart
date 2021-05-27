import 'package:image_to_text_decoder/transcribe_bloc/transcribe_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TranscriptionResponseView extends StatelessWidget {
  const TranscriptionResponseView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<TranscribeBloc, TranscribeState>(
        buildWhen: (previous, current) {
          return current is TranscribeSuccessResponse ||
              current is TranscribeInitial;
        },
        builder: (context, state) {
          if (state is TranscribeSuccessResponse) {
            return SelectableText(state.data);
          } else if (state is TranscribeInitial) {
            return const Text('Haven\'t recivied anything yet');
          }
          return Container();
        },
      ),
    );
  }
}
