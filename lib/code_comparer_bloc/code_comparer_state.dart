part of 'code_comparer_bloc.dart';

@immutable
abstract class CodeComparerState {}

class CodeComparerInitial extends CodeComparerState {}

class CodeComparerResponded extends CodeComparerState {
  final String responseLink;
  CodeComparerResponded({
    required this.responseLink,
  });
}

class CodeComparerWaitingResponse extends CodeComparerState {}
