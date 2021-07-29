import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

class AWSTranscriptionRepository {
  static bool isReady = false;
  static Future<void> init() async {
    await _initFilePath();
    await _initSreenshotPath();
    _initWriteToFile();

    isReady = true;
  }

  static Future<void> _request(Map<String, Object> message) async {
    final port = message['port'] as SendPort;
    final data = message['data'] as List<Uint8List>;
    final decodedData = <String>[];
    for (final pieceOfData in data) {
      final response = await http.post(
        Uri.parse(
          'https://4ds5bcbcp8.execute-api.us-east-1.amazonaws.com/release/useTextractForCheating',
        ),
        body: jsonEncode(
          {
            'data': base64Encode(pieceOfData),
          },
        ),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        decodedData.add(decoded as String);
      } else {
        return Future.error("An error occured while transcribing...");
      }
    }
    port.send(decodedData.join('\n'));
  }

  static Future<String> request(
    Uint8List data, {
    List<Uint8List>? listOfData,
  }) async {
    final receivePort = ReceivePort();
    final dataList = listOfData ?? [data];
    final completer = Completer<String>();
    Isolate.spawn(
      _request,
      {
        "port": receivePort.sendPort,
        "data": dataList,
      },
    );
    receivePort.listen((message) => completer.complete(message));
    return completer.future;
  }

  static void writeToFile(String filePath, String data) {
    File(filePath).writeAsString(
      data,
      mode: FileMode.append,
    );
  }

  static Future<void> changeFilePath(String path) async {
    await HydratedBloc.storage.write('filePath', path);
  }

  static Future<void> changeScreenshotPath(String path) async {
    await HydratedBloc.storage.write('screenshotPath', path);
  }

  static Future<void> changeWriteToFile(bool val) async {
    await HydratedBloc.storage.write('writeToFile', val);
  }

  static Future<String> _initFilePath() async {
    var filePath = HydratedBloc.storage.read('filePath') as String?;
    if (filePath == null) {
      final tempFile = await File('main.cpp').create();
      filePath = tempFile.path;
    }
    await changeFilePath(filePath);
    return filePath;
  }

  static Future<String?> _initSreenshotPath() async {
    var screenshotPath = HydratedBloc.storage.read('screenshotPath') as String?;
    screenshotPath ??= (await getApplicationSupportDirectory()).path;
    await changeScreenshotPath(screenshotPath);
    return screenshotPath;
  }

  static Future<bool> _initWriteToFile() async {
    final bool writeToFile = HydratedBloc.storage.read('writeToFile') ?? false;

    await changeWriteToFile(writeToFile);
    return writeToFile;
  }
}
