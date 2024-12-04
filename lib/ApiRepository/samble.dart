import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // URL of your API
  static const String apiUrl = 'http://localhost:3000/api/test-connection';

  // Method to fetch data
  Future<Map<String, dynamic>> fetchData() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        return json.decode(response.body);
      } else {
        // If the response code is not 200, throw an error
        throw Exception('Failed to load data');
      }
    } catch (e) {
      // Handle any errors
      throw Exception('Error: $e');
    }
  }
}
