import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiPendingdelivaryrepo{
  Future<List<dynamic>> get_pendingdelivary()async{
  try {
    final response = await http.get(Uri.parse("http://192.168.0.128:3000/pendingdelivery/get"));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseMap = json.decode(response.body);
      if (responseMap.containsKey('data')) {
        return List<dynamic>.from(responseMap['data']);
      } else {
        throw Exception('Data key not found in response');
      }
    } else {
      throw Exception('Failed to load pending job cards');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
 }

 Future<bool> post_pendingdelivary(Map<String, dynamic> PendingjData) async {
    try {
      
      final response = await http.post(
        Uri.parse("http://192.168.0.128:3000/pendingdelivery/post"),
        headers: {
          'Content-Type': 'application/json', 
        },
        body: json.encode(PendingjData), 
      );
      
      if (response.statusCode == 201) {
        return true;
      } else {
        throw Exception('Failed to add job card');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}