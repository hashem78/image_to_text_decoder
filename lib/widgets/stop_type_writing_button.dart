import 'package:image_to_text_decoder/type_writing_cubit/type_writing_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StopTypeWritingButton extends StatelessWidget {
  const StopTypeWritingButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TypeWritingCubit, TypeWritingState>(
      builder: (context, state) {
        if (state is TypeWritingWorking) {
          return Row(
            children: [
              IconButton(
                onPressed: context.read<TypeWritingCubit>().stop,
                icon: const Icon(Icons.close, color: Colors.red),
              ),
              const Text("Stop Type writing"),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }
}
