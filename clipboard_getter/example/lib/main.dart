import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:clipboard_getter/clipboard_getter.dart';
import 'package:transparent_image/transparent_image.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Uint8List? imageData = Uint8List.fromList([]);
  @override
  void didChangeDependencies() {
    Timer.periodic(
      const Duration(seconds: 1),
      (timer) async {
        final clipboardImage = await ClipboardGetter.getClipboardData();
        final compare = const DeepCollectionEquality().equals;
        if (!compare(clipboardImage?.toList(), imageData?.toList())) {
          setState(() {
            imageData = clipboardImage;
          });
        }
      },
    );
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Image.memory(imageData ?? kTransparentImage),
        ),
      ),
    );
  }
}
