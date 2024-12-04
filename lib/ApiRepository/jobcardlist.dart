import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiJobcardRepository{

 Future<List<dynamic>> getjobcard()async{
  
    try {
      final response = await http.get(Uri.parse("http://192.168.0.128:3000/companies"));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load companies');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  
 }

 Future<bool> postNewJobCard(Map<String, dynamic> jobCardData) async {
    try {
      
      final response = await http.post(
        Uri.parse("http://192.168.0.128:3000/newjobcard"),
        headers: {
          'Content-Type': 'application/json', 
        },
        body: json.encode(jobCardData), 
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