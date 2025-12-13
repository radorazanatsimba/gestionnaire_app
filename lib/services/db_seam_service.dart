import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DbSeamService {
  final String baseUrl = dotenv.env['URL_SEAM_TEST']!;

  /// 🔹 Récupère les données depuis l’API avec le paramètre sqlText
  Future<List<dynamic>> getDataToLoad(String sqlText) async {
    final uri = Uri.parse('${baseUrl}modele.php/getDataToLoadJson')
        .replace(queryParameters: {'sqlText': sqlText});

    try {
      final response = await http.get(uri, headers: {
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          return data;
        } else if (data is Map && data.containsKey('data')) {
          return data['data'];
        } else {
          return [data];
        }
      } else {
        throw Exception('Erreur serveur : ${response.statusCode}');
      }
    } catch (e) {
      print("❌ Erreur lors de l'appel API : $e");
      rethrow;
    }
  }
}
