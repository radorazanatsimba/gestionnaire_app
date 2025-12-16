import 'package:d2_touch/shared/models/request_progress.model.dart';
import 'package:flutter/material.dart';
class SyncProgressProvider with ChangeNotifier {
  double _progress = 0.0;
  String _message = 'Initialisation...';

  double get progress => _progress;
  String get message => _message;

  void update(RequestProgress progress, Object status) {
    _progress = progress.percentage / 100;
    _message = progress.message ?? 'Synchronisation...';
    notifyListeners();
  }

  void reset() {
    _progress = 0.0;
    _message = 'Initialisation...';
    notifyListeners();
  }
}
