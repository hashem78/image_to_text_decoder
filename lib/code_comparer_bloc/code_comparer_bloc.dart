import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:image_to_text_decoder/code_comparer_langs.dart';
import 'package:meta/meta.dart';

part 'code_comparer_event.dart';
part 'code_comparer_state.dart';

class CodeComparerBloc extends Bloc<CodeComparerEvent, CodeComparerState> {
  CodeComparerBloc() : super(CodeComparerInitial());

  @override
  Stream<CodeComparerState> mapEventToState(
    CodeComparerEvent event,
  ) async* {
    if (event is CodeComparerCompareEvent) {
      yield CodeComparerWaitingResponse();
      final p = await Process.run(
        'perl',
        [
          'moss',
          '-l',
          EnumToString.convertToString(event.language),
          event.baseFilePath,
          event.filePath,
        ],
      );
      final response = (p.stdout as String).split('\n');

      var link =
          response[response.length - 2].replaceAll(',', '').replaceAll(' ', '');
      link = link.substring(0, link.length - 1);

      stdout.write(p.stdout);

      yield CodeComparerResponded(responseLink: link);
    }
  }
}
