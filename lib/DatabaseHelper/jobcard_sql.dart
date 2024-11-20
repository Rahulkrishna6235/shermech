// import 'dart:convert';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:sher_mech/utility/databasedatails.dart';
// import 'package:sher_mech/views/vehiclemake.dart';

// class SQLrepository {

//   // Accept the required parameters to create a new job card
//   Future<bool> post_Newjobcard(
   
//   ) async {
//     if (formKey.currentState != null && formKey.currentState!.validate()) {
//       bool isLoading = true;

//       String customerName = customernameController.text.replaceAll("'", "''");
//       String date = dateController.text.replaceAll("'", "''");
//       String jobcardNo = jobcardnoController.text.replaceAll("'", "''");
//       String model = modelController.text.replaceAll("'", "''");
//       String registration = registrationController.text.replaceAll("'", "''");
//       String remark = remarkController.text.replaceAll("'", "''");

//       try {
//         bool isConnected = await connect();
//         if (!isConnected) {
//           Fluttertoast.showToast(msg: 'Database connection failed');
//           return false;
//         }

//         String query = "INSERT INTO Jobcard (date, jobcardno, customername, modal, registrationno, remark) "
//             "VALUES ('$date', '$jobcardNo', '$customerName', '$model', '$registration', '$remark')";
//         String result = await sqlConnection.writeData(query);
//         Map<String, dynamic> valueMap = json.decode(result);

//         if (valueMap['affectedRows'] == 1) {
//           // Clear the controllers if the insert was successful
//           customernameController.clear();
//           dateController.clear();
//           jobcardnoController.clear();
//           registrationController.clear();
//           modelController.clear();
//           remarkController.clear();

//           Fluttertoast.showToast(msg: "Job Card Created Successfully");
//           return true;
//         } else {
//           Fluttertoast.showToast(msg: "Failed to Add Job Card");
//         }
//       } catch (e) {
//         Fluttertoast.showToast(msg: "Error: $e");
//       }
//       return false;
//     }
//     return false;
//   }
// }
