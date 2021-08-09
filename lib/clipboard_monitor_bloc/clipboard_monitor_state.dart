part of 'clipboard_monitor_bloc.dart';

@immutable
abstract class ClipboardMonitorState {}

class ClipboardMonitorInitial extends ClipboardMonitorState {}

class ClipboardMonitorDataChanged extends ClipboardMonitorState {
  final Uint8List? data;

  ClipboardMonitorDataChanged(this.data);
}
