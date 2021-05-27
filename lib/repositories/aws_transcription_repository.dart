import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AWSTranscriptionRepository {
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
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('filePath', path);
  }

  static Future<void> changeScreenshotPath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('screenshotPath', path);
  }

  static Future<String?> getFilePath() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('filePath');
  }

  static Future<String?> getSreenshotPath() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('screenshotPath');
  }
}
