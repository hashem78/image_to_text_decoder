import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TypeWriteSpeedSlider extends HookWidget {
  const TypeWriteSpeedSlider({
    Key? key,
    required this.typeWriteSpeed,
  }) : super(key: key);

  final ValueNotifier<int> typeWriteSpeed;

  @override
  Widget build(BuildContext context) {
    final val = useValueListenable(typeWriteSpeed);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Type writing speed"),
        Slider(
          value: val.toDouble(),
          onChanged: (value) {
            typeWriteSpeed.value = value.toInt();
          },
          min: 1,
          max: 10,
          divisions: 10,
          label: val.toString(),
        ),
      ],
    );
  }
}
