
import 'package:flutter/material.dart';

enum ResetStates { loading, success, error, idle }

class ResetPasswordManger {
  String _errorMessage;
  String get error => _errorMessage;
  ValueNotifier<ResetStates> _notifier = ValueNotifier<ResetStates>(
      ResetStates.idle);

  ValueNotifier<ResetStates> get currentStates => _notifier;

  requestResetCode() async {
    var result;
    _notifier.value = ResetStates.loading;
    await Future.delayed(Duration(seconds: 3), () {
      result = true;
    });
    if (result == null) {
      _setError();
    }
    else if (result is String) {
      _errorMessage = result;
      _setError();
    }
    else {
      _notifier.value = ResetStates.success;
    }
  }

  _setError() {
    _notifier.value = ResetStates.error;
    Future.delayed(Duration(seconds: 3), () {
      _notifier.value = ResetStates.idle;
    });
  }
}