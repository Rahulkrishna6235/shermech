import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
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
       print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
      if (response.statusCode == 201) {
        return true;
      } else {
        throw Exception('Failed to add job card');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<bool> deleteMake(int id) async {
    const String apiUrl = "http://192.168.0.128:3000/vehiclemake/delete/";

    try {
      final response = await http.delete(
        Uri.parse('$apiUrl$id'),
      );
      print(response.body);
      if (response.statusCode == 200) {
        return true; 
      } else {
        return false; 
      }
    } catch (e) {
      print("Error deleting vehicle make: $e");
      return false; 
    }
  }
Future<bool> updateVehicleMake(int siNo, String newVehicleName) async {
    const String apiUrl = "http://192.168.0.128:3000/vehiclemake/update";

    try {
      final response = await http.put(
        Uri.parse('$apiUrl/$siNo'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'newVehicleName': newVehicleName,
        }),
      );

      if (response.statusCode == 200) {
        print("Record updated successfully: ${response.body}");
        return true;
      } else {
        print("Failed to update record: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error updating record: $e");
      return false;
    }
  }
}