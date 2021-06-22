part of 'code_comparer_bloc.dart';

@immutable
abstract class CodeComparerEvent {}

class CodeComparerCompareEvent extends CodeComparerEvent {
  final String baseFilePath;
  final String filePath;
  final CodeComparerLanguage language;
  CodeComparerCompareEvent({
    required this.baseFilePath,
    required this.filePath,
    required this.language,
  });
}
