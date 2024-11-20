// import 'package:flutter/material.dart';

// class MyWidget extends StatefulWidget {
//   const MyWidget({super.key});

//   @override
//   State<MyWidget> createState() => _MyWidgetState();
// }

// class _MyWidgetState extends State<MyWidget> {

   

// Future<void> connectAndGetData() async {
//     bool isConnected = await connect();
//     if (isConnected) {
//       await getData(); 
//     } else {
//       Fluttertoast.showToast(msg: 'Database connection failed');
//     }
//   }

//   Future<bool> connect() async {
//     return await sqlConnection.connect(
//       ip: ipAdress,
//       port: port,
//       databaseName: databasename,
//       username: username,
//       password: password,
//     );
//   }

//   Future<void> getData() async {
//     String query = 'SELECT * FROM vehicleMake ORDER BY SiNo';
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       bool isConnected = await connect();
//       if (isConnected) {
//         String result = await sqlConnection.getData(query);
//         if (result.isNotEmpty) {
//           List<dynamic> data = json.decode(result);
//           setState(() {
//             vehicleList = List<Map<String, dynamic>>.from(data);
//           });
//         } else {
//           Fluttertoast.showToast(msg: 'No data found');
//           setState(() {
//             vehicleList = [];
//           });
//         }
//       } else {
//         Fluttertoast.showToast(msg: 'Database connection failed');
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: 'Error: $e');
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//  Future<bool> post() async {
//   if (_formKey.currentState != null && _formKey.currentState!.validate()) {
//     setState(() {
//       isLoading = true;
//     });

//     String vehicleName = _vehiclenameController.text.replaceAll("'", "''");

//     String queryMaxSiNo = 'SELECT MAX(SiNo) as MaxSiNo FROM vehicleMake';
//     int nextSiNo = 1;  

//     try {
//       bool isConnected = await connect();
//       if (isConnected) {
//         String maxSiNoResult = await sqlConnection.getData(queryMaxSiNo);
//         if (maxSiNoResult.isNotEmpty) {
//           List<dynamic> resultList = json.decode(maxSiNoResult);
//           if (resultList.isNotEmpty) {
//             Map<String, dynamic> resultMap = resultList[0];
//             if (resultMap['MaxSiNo'] != null) {
//               nextSiNo = resultMap['MaxSiNo'] + 1;
//             }
//           }
//         }

//         String insertQuery = "INSERT INTO vehicleMake (SiNo, VehicleName) VALUES ($nextSiNo, '$vehicleName')";

//         String result = await sqlConnection.writeData(insertQuery);
//         Map<dynamic, dynamic> valueMap = json.decode(result);
//         if (valueMap['affectedRows'] == 1) {
//           _vehiclenameController.clear();
//           await getData();  
//           setState(() {
//             isLoading = false;
//           });
//           Fluttertoast.showToast(msg: "Vehicle added successfully");
//           return true;
//         } else {
//           Fluttertoast.showToast(msg: "Failed to add vehicle");
//           setState(() {
//             isLoading = false;
//           });
//         }
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: "Error: $e");
//     }
//   }
//   return false;
// } 

//  Future<bool> deleteVehicle(int siNo) async {
//   setState(() {
//     isLoading = true;
//   });

//   String query = "DELETE FROM vehicleMake WHERE SiNo = $siNo";

//   try {
//     bool isConnected = await connect();
//     if (isConnected) {
//       String result = await sqlConnection.writeData(query);
//       Map<dynamic, dynamic> valueMap = json.decode(result);
//       if (valueMap['affectedRows'] == 1) {
//         Fluttertoast.showToast(msg: " Deleted");
//         await getData(); 
//         return true;
//       } else {
//         Fluttertoast.showToast(msg: "Failed to delete vehicle");
//       }
//     }
//   } catch (e) {
//     Fluttertoast.showToast(msg: "Error: $e");
//   } finally {
//     setState(() {
//       isLoading = false;
//     });
//   }

//   return false;
// }

// Future<bool> updateVehicle(int siNo, String newVehicleName) async {
//   setState(() {
//     isLoading = true;
//   });

//   String query = "UPDATE vehicleMake SET VehicleName = '$newVehicleName' WHERE SiNo = $siNo";

//   try {
//     bool isConnected = await connect();
//     if (isConnected) {
//       String result = await sqlConnection.writeData(query);
//       Map<dynamic, dynamic> valueMap = json.decode(result);
//       if (valueMap['affectedRows'] == 1) {
//         Fluttertoast.showToast(msg: "Vehicle updated successfully");
//         await getData(); 
//         return true;
//       } else {
//         Fluttertoast.showToast(msg: "Failed to update vehicle");
//       }
//     }
//   } catch (e) {
//     Fluttertoast.showToast(msg: "Error: $e");
//   } finally {
//     setState(() {
//       isLoading = false;
//     });
//   }

//   return false;
// }

//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }

