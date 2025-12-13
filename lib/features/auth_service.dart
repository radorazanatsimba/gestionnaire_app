import 'package:d2_touch/d2_touch.dart';

class AuthService {

  /// Connexion à DHIS2
  static Future<bool> login({
    required String url,
    required String username,
    required String password,
  }) async {
    try {
      print("eto 1.");
      await D2Touch.logIn(
        username: username,
        password: password,
        url: url,
      );
      print("ici");
      return true; // succès
    } catch (e) {
      print("Erreur de connexion : $e");
      return false; // échec
    }
  }

  /// Déconnexion
  static Future<void> logout() async {
    await  D2Touch.logOut();
  }
}