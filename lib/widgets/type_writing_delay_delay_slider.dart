import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TypeWriteDelaySlider extends HookWidget {
  const TypeWriteDelaySlider({
    Key? key,
    required this.typeWriteDelay,
  }) : super(key: key);

  final ValueNotifier<int> typeWriteDelay;

  @override
  Widget build(BuildContext context) {
    final val = useValueListenable(typeWriteDelay);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Type writing delay"),
        Slider(
          value: val.toDouble(),
          onChanged: (value) => typeWriteDelay.value = value.toInt(),
          min: 1,
          max: 10,
          divisions: 10,
          label: val.toInt().toString(),
        ),
      ],
    );
  }
}
