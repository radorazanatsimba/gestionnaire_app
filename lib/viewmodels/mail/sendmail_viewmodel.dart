import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SendmailViewModel extends ChangeNotifier {
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

  /// Fonction pour envoyer un mail
  Future<void> sendMail({
    required String destinataire,
    required String sujet,
    required String message,
  }) async {
    _setLoading(true);
    _setMessage(""); // reset message

    final apiUrl = Uri.parse(
        "https://seam.meah.gov.mg/v2-formation/send_mail.php");

    try {
      final response = await http.post(
        apiUrl,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "to_list": destinataire,
          "subject": sujet,
          "message": message,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["status"] == "success") {
          _setMessage(
              "Demande d'inscription envoyée à l’administrateur. Vous serez notifié après validation.");
        } else {
          _setMessage("Erreur : ${data["message"]}");
        }
      } else {
        _setMessage("Erreur HTTP ${response.statusCode}");
      }
    } catch (e) {
      _setMessage("Erreur lors de l’envoi du mail : $e");
    } finally {
      _setLoading(false);
    }
  }
}






