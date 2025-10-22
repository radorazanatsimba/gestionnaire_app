import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SendMailInscriptionViewModel extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String _message = "";

  String get message => _message;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setMessage(String msg) {
    _message = msg;
    notifyListeners();
  }

  Future<void> sendMail({
    required String username,
    required String email,
    required String password,
    required String destinataire,
    String? codeGestionnaire,
    required String sujet,
    required String message,
  }) async {
    _setLoading(true);
    _setMessage(""); // reset message

    final apiUrl = Uri.parse(
        "https://seam.meah.gov.mg/v2-formation/send_mail_inscription_user.php");

    try {
      final response = await http.post(
        apiUrl,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": username,
          "email": email,
          "password": password,
          "code_gestionnaire": codeGestionnaire ?? "",
          "to_list": destinataire,
          "subject": sujet,
          "message": message,
        }),
      );
      // DEBUG : afficher la réponse brute
      print("HTTP Status: ${response.statusCode}");
      print("RAW BODY: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        switch (data["status"]) {
          case "success":
            _setMessage(
                "Utilisateur ajouté et demande envoyée à l’administrateur. Vous serez notifié après validation.");
            break;
          case "warning":
          // l’utilisateur est ajouté mais mail non envoyé
            _setMessage(
                "Utilisateur ajouté mais erreur lors de l’envoi du mail : ${data["message"]}");
            break;
          case "error":
          // cas d’email déjà utilisé ou autre erreur
            _setMessage("Erreur : ${data["message"]}");
            break;
          default:
            _setMessage("Réponse inconnue de l'API.");
        }
      } else {
        _setMessage("Erreur HTTP ${response.statusCode}");
      }
    } catch (e) {
      _setMessage("Erreur lors de l’envoi : $e");
    } finally {
      _setLoading(false);
    }
  }
}






