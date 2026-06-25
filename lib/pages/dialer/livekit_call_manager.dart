import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class LiveKitCallManager {
  static final LiveKitCallManager _instance = LiveKitCallManager._internal();
  factory LiveKitCallManager() => _instance;
  LiveKitCallManager._internal();

  String? _currentRoomId;
  final ValueNotifier<String?> currentCallRoomId = ValueNotifier<String?>(null);
  Route? _currentCallRoute;
  bool _disposed = false;

  String? get currentRoomId => _currentRoomId;
  Route? get currentCallRoute => _currentCallRoute;

  void startCall(String roomId, Route route) {
    _disposed = false;
    _currentRoomId = roomId;
    _currentCallRoute = route;
    currentCallRoomId.value = roomId;
  }

  void endCall() {
    _currentRoomId = null;
    _currentCallRoute = null;
    if (!_disposed) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (!_disposed) {
          currentCallRoomId.value = null;
        }
      });
    }
  }

  void markDisposed() {
    _disposed = true;
  }

  bool get isInCall => _currentRoomId != null;
}
