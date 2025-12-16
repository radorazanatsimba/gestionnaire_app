import 'package:flutter/material.dart';
import 'package:d2_touch/d2_touch.dart';


class AuthProvider with ChangeNotifier {

  bool _loading = false;
  String? _error;
  dynamic _me;

  bool get isLoading => _loading;
  bool get isLoggedIn => _me != null;
  String? get error => _error;
  dynamic get me => _me;


   Future<bool> login({
    required D2Touch d2,
    required String url,
    required String username,
    required String password,
  }) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {

      await d2.authModule.logIn(username: username, password: password, url: url);
      _me = username;
      _loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();

      _loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout({required D2Touch d2}) async {
    await d2.authModule.logOut();
    _me = null;
    notifyListeners();
  }
}
