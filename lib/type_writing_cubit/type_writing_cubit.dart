import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'type_writing_state.dart';

class TypeWritingCubit extends Cubit<TypeWritingState> {
  TypeWritingCubit() : super(TypeWritingInitial());
  void reset() {
    emit(TypeWritingInitial());
  }

  void start() {
    if (state is TypeWritingInitial) {
      emit(TypeWritingWorking());
    }
  }

  void stop() {
    if (state is TypeWritingWorking) {
      emit(TypeWritingStopped());
    }
  }
}
