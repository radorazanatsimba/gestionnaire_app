import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GestionnaireViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Map<String, String>> _gestionnaires = [];
  List<Map<String, String>> get gestionnaires => _gestionnaires;

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


        _gestionnaires = (decoded['trackedEntityInstances'] as List)
            .map<Map<String, String>>((tei) {
          final attributes = tei['attributes'] as List;

          final nom = (attributes.firstWhere(
                (attr) => attr['displayName'] == 'Nom gestionnaire',
            orElse: () => {'value': ''},
          )['value'] ??
              '') as String;

          final id = (attributes.firstWhere(
                (attr) => attr['displayName'] == 'Id gestionnaire',
            orElse: () => {'value': ''},
          )['value'] ??
              '') as String;

          return {'nom': nom, 'id': id};
        }).toList();

      } else {
        _error = "Erreur HTTP ${response.statusCode}";
      }
    } catch (e) {
      _error = "Erreur : $e";
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }
}
