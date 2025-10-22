import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GestionnaireViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Map<String, dynamic>> _gestionnaires = [];
  List<Map<String, dynamic>> get gestionnaires => _gestionnaires;

  String? _selectedGestionnaire;
  String? get selectedGestionnaire => _selectedGestionnaire;

  String? _error;
  String? get error => _error;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setSelectedGestionnaire(String? value) {
    _selectedGestionnaire = value;
    notifyListeners();
  }

  Future<void> getListGestionnaire() async {
    _setLoading(true);
    _error = null;

    final apiParam =
        "api/29/trackedEntityInstances.json?program=L1LoxYFumdQ&ou=BkjcPj8Zv7E&paging=false";
    final baseUrl = dotenv.env['URL_SEAM_TEST_MODEL_DHIS']!;

    final uri = Uri.parse(baseUrl + 'getApiDhis2Json')
        .replace(queryParameters: {'urlApi': apiParam});

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        // ⚠️ adapte ici selon la structure exacte du JSON retourné par ton API
        // Exemple typique DHIS2 : trackedEntityInstances → attributes
        final instances = decoded['trackedEntityInstances'] as List<dynamic>;
        _gestionnaires = instances.map((item) {
          final attributes = item['attributes'] as List<dynamic>;
          final nom = attributes
              .firstWhere(
                  (a) => a['attribute'] == 'Nom gestionnaire', orElse: () => {'value': ''})['value'] ??
              '';
          return {
            'code': item['trackedEntityInstance'],
            'nom': nom,
          };
        }).toList();
      } else {
        _error = "Erreur HTTP ${response.statusCode}";
      }
    } catch (e) {
      _error = "Erreur : $e";
    } finally {
      _setLoading(false);
    }
  }
}
