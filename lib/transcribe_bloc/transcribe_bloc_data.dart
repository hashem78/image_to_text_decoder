import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class TranscribeBlocData {
  final String filePath;
  final String screenShotPath;
  final bool writeToFile;
  const TranscribeBlocData({
    required this.filePath,
    required this.screenShotPath,
    required this.writeToFile,
  });

  TranscribeBlocData copyWith({
    String? filePath,
    String? screenShotPath,
    bool? writeToFile,
  }) {
    return TranscribeBlocData(
      filePath: filePath ?? this.filePath,
      screenShotPath: screenShotPath ?? this.screenShotPath,
      writeToFile: writeToFile ?? this.writeToFile,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'filePath': filePath,
      'screenShotPath': screenShotPath,
      'writeToFile': writeToFile,
    };
  }

  factory TranscribeBlocData.fromMap(Map<String, dynamic> map) {
    return TranscribeBlocData(
      filePath: map['filePath'],
      screenShotPath: map['screenShotPath'],
      writeToFile: map['writeToFile'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TranscribeBlocData.fromJson(String source) =>
      TranscribeBlocData.fromMap(json.decode(source));

  @override
  String toString() =>
      'TranscribeBlocData(filePath: $filePath, screenShotPath: $screenShotPath, writeToFile: $writeToFile)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TranscribeBlocData &&
        other.filePath == filePath &&
        other.screenShotPath == screenShotPath &&
        other.writeToFile == writeToFile;
  }

  @override
  int get hashCode =>
      filePath.hashCode ^ screenShotPath.hashCode ^ writeToFile.hashCode;
}
