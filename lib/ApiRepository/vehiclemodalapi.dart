import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class ApiVehicleModelRepository{
  Future<List<dynamic>> get_vehiclemodel()async{
  try {
    final response = await http.get(Uri.parse("http://192.168.0.128:3000/vehiclemodel/get"));

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

 Future<bool> post_vehiclemodel(Map<String, dynamic> Data) async {
  try {
    final response = await http.post(
      Uri.parse("http://192.168.0.128:3000/vehiclemodel/post"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(Data), 
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 201) {
      return true; 
    } else {
      throw Exception('Failed to add vehicle model');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Error: $e');
  }
}


  Future<void> deleteModel(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('http://192.168.0.128:3000/vehiclemodel/delete/$id'),
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: 'Job card deleted successfully');
       
      } else if (response.statusCode == 404) {
        Fluttertoast.showToast(msg: 'Job card not found');
      } else {
        Fluttertoast.showToast(msg: 'Error: ${response.body}');
      }
    } catch (error) {
      Fluttertoast.showToast(msg: 'Error: $error');
    }
  }
  

Future<bool> updateVehicleModel(String id, String modaltitle, String modalsubtitle) async {
  const String apiUrl = "http://192.168.0.128:3000/vehiclemodel/update";  // Base URL for the update API

  try {
    final response = await http.put(
      Uri.parse('$apiUrl/$id'),  // Append the ID to the URL
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'modaltitle': modaltitle,
        'modalsubtitle': modalsubtitle,
      }),
    );

    if (response.statusCode == 200) {
      print(response.body);
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