import 'package:flutter/material.dart';
import 'package:d2_touch/d2_touch.dart';

class D2Provider with ChangeNotifier {
  D2Touch? _d2;
  bool _initialized = false;

  bool get isInitialized => _initialized;

  D2Touch get d2 {
    init();
    if (_d2 == null) {
      throw Exception("D2Touch non initialisé. Appelle init() avant.");
    }
    return _d2!;
  }

  Future<void> init() async {
    _d2 = await D2Touch.init(
      databaseName: 'dhis2_app.db',
      instanceVersion: 1,
    );

    _initialized = true;
    notifyListeners();
  }
}
