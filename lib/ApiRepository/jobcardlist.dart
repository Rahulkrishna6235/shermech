import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class ApiJobcardRepository{
   String baseUrl = "http://192.168.0.128:3000"; 

 Future<List<dynamic>> getjobcard()async{
  
    try {
      final response = await http.get(Uri.parse("$baseUrl/companies"));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load jobcards');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  
 }
 Future<Map<String, dynamic>> getJobCardById(String jobCardId) async {
  try {
    final response = await http.get(Uri.parse("$baseUrl/jobcards/$jobCardId"));

    if (response.statusCode == 200) {
      return json.decode(response.body);  // Return job card data as a Map
    } else {
      throw Exception('Failed to load job card');
    }
  } catch (e) {
    throw Exception('Error fetching job card: $e');
  }
}


 Future<bool> postNewJobCard(Map<String, dynamic> jobCardData) async {
    try {
      
      final response = await http.post(
        Uri.parse("$baseUrl/newjobcard"),
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

  Future<void> deleteJobcard(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/newjobcard/delete/$id'),
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

 Future<bool> updateJobCard(String jobcardno, Map<String, dynamic> updatedData) async {
  final Uri url = Uri.parse("$baseUrl/newjobcard/updatebyjobcardno/$jobcardno");

  try {
    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(updatedData),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      print("Update Successful: ${responseBody['message']}");
      return true; // Update successful
    } else if (response.statusCode == 404) {
      print("Job card not found: ${response.body}");
      return false; // Job card not found
    } else {
      print("Failed to update job card: ${response.body}");
      return false; // Other failure
    }
  } catch (e) {
    print("Error making API call: $e");
    return false; // Error during API call
  }
}

}