part of 'clipboard_monitor_bloc.dart';

@immutable
abstract class ClipboardMonitorEvent {}

class ClipboardMonitorEventEnable extends ClipboardMonitorEvent {}

class ClipboardMonitorEventDisable extends ClipboardMonitorEvent {}

class ClipboardMonitorEventData extends ClipboardMonitorEvent {
  final Uint8List? data;

  ClipboardMonitorEventData(this.data);
}
