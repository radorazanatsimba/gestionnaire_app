import 'package:bcrypt/bcrypt.dart';
import 'db_seam_service.dart';

class AuthService {
  final DbSeamService _dbService = DbSeamService();

  /// 🔹 Vérifie les identifiants
  Future<bool> login(String username, String password) async {
    // SQL pour récupérer l'utilisateur
    final sql = "SELECT nom_utilisateur, mot_de_passe FROM utilisateur WHERE nom_utilisateur='$username'";

    try {
      final data = await _dbService.getDataToLoad(sql);

      if (data.isNotEmpty) {
        final user = data.first;
        print(user);
        final storedHash = user['mot_de_passe'] ?? '';
        // Vérification du mot de passe hashé
        final isValid = BCrypt.checkpw(password, storedHash);

        return isValid;
      } else {
        return false; // Utilisateur non trouvé
      }
    } catch (e) {
      print("❌ Erreur login : $e");
      return false;
    }
  }
}
