import 'dart:convert';
import 'package:http/http.dart' as http;


class ApiVehicleMakeRepository{
   Future<List<dynamic>> get_vehiclemake()async{
  try {
    final response = await http.get(Uri.parse("http://192.168.0.128:3000/vehiclemake/get"));

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

 Future<bool> post_vehiclemake(Map<String, dynamic> Data) async {
    try {
      
      final response = await http.post(
        Uri.parse("http://192.168.0.128:3000/vehiclemake/post"),
        headers: {
          'Content-Type': 'application/json', 
        },
        body: json.encode(Data), 
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