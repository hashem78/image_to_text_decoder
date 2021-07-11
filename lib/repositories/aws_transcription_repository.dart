import 'dart:convert';
import 'dart:io';
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

  static Future<String> request(Uint8List data) async {
    final response = await http.post(
      Uri.parse(
        'https://4ds5bcbcp8.execute-api.us-east-1.amazonaws.com/release/useTextractForCheating',
      ),
      body: jsonEncode(
        {
          'data': base64Encode(data),
        },
      ),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return decoded;
    } else {
      return Future.error("An error occured while transcribing...");
    }
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
