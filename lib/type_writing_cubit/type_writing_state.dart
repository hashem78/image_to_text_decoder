part of 'type_writing_cubit.dart';

@immutable
abstract class TypeWritingState {}

class TypeWritingInitial extends TypeWritingState {}

class TypeWritingWorking extends TypeWritingState {}

class TypeWritingStopped extends TypeWritingState {}
