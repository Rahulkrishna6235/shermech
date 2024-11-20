// // import 'package:flutter/material.dart';
// // import 'package:intl/intl.dart'; // For date formatting

// // class Jobcardreport extends StatefulWidget {
// //   const Jobcardreport({super.key});

// //   @override
// //   State<Jobcardreport> createState() => _JobcardreportState();
// // }

// // class _JobcardreportState extends State<Jobcardreport> {
// //   // Initial selected dates
// //   DateTime? _fromDate;
// //   DateTime? _toDate;

// //   // Format for displaying the date
// //   final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

// //   // Method to pick a date
// //   Future<void> _selectDate(BuildContext context, bool isFromDate) async {
// //     final DateTime? selectedDate = await showDatePicker(
// //       context: context,
// //       initialDate: DateTime.now(),
// //       firstDate: DateTime(2000),
// //       lastDate: DateTime(2101),
// //     );

// //     if (selectedDate != null) {
// //       setState(() {
// //         if (isFromDate) {
// //           _fromDate = selectedDate;
// //         } else {
// //           _toDate = selectedDate;
// //         }
// //       });
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.grey[200],
// //       appBar: AppBar(
// //         toolbarHeight: 80,
// //         backgroundColor: const Color(0xFF0008B4),
// //         title: const Center(
// //           child: Text(
// //             "JOB CARD REPORT",
// //             style: TextStyle(
// //               fontSize: 18,
// //               fontWeight: FontWeight.w700,
// //               color: Colors.white,
// //             ),
// //           ),
// //         ),
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
// //         child: Column(
// //           children: [
// //             // Container for From and To Date Pickers
// //             Container(
// //               width: double.infinity,
// //               padding: const EdgeInsets.all(16),
// //               decoration: BoxDecoration(
// //                 color: Colors.white,
// //                 borderRadius: BorderRadius.circular(8),
// //                 boxShadow: const [
// //                   BoxShadow(
// //                     color: Colors.grey,
// //                     blurRadius: 4,
// //                     offset: Offset(0, 2),
// //                   ),
// //                 ],
// //               ),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   const Text(
// //                     "Select Date Range",
// //                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
// //                   ),
// //                   SizedBox(height: 10),
// //                   Row(
// //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                     children: [
// //                       // From Date Picker
// //                       GestureDetector(
// //                         onTap: () => _selectDate(context, true),
// //                         child: Container(
// //                           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
// //                           decoration: BoxDecoration(
// //                             border: Border.all(color: Colors.grey),
// //                             borderRadius: BorderRadius.circular(8),
// //                           ),
// //                           child: Text(
// //                             _fromDate != null ? _dateFormat.format(_fromDate!) : "From Date",
// //                             style: TextStyle(fontSize: 16, color: _fromDate != null ? Colors.black : Colors.grey),
// //                           ),
// //                         ),
// //                       ),
// //                       // To Date Picker
// //                       GestureDetector(
// //                         onTap: () => _selectDate(context, false),
// //                         child: Container(
// //                           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
// //                           decoration: BoxDecoration(
// //                             border: Border.all(color: Colors.grey),
// //                             borderRadius: BorderRadius.circular(8),
// //                           ),
// //                           child: Text(
// //                             _toDate != null ? _dateFormat.format(_toDate!) : "To Date",
// //                             style: TextStyle(fontSize: 16, color: _toDate != null ? Colors.black : Colors.grey),
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             // Add other widgets or content here
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }




// // Future<List<Transaction>> getTransaction() async{

// //   List<Transaction> tansactionInfoList = [];

// //   try{

// //     sqlConnection.getRowsOfQueryResult("select * from [dbo].[transaction]").
// //     then((result){
// //       if(result.runtimeType == String)   {
// //         print("Error retrieving data: $result");
// //         return tansactionInfoList;
// //       }

// //       else{
// //         List<Map<String, dynamic>> transactionResult =
// //         result.cast<Map<String, dynamic>>();
// //         for(var elements in transactionResult){

// //           tansactionInfoList.add(
// //               Transaction(
// //                   id:elements['id'],
// //                   cashin: (elements['cashin'] !=null)
// //                   ? elements['cashin'].toDouble()
// //                   :0,
// //                   cashout: (elements['cashout'] !=null)
// //                   ? elements['cashout'].toDouble()
// //                   :0,
// //                   notes: elements['notes'],
// //                   date: elements['date'],
// //                   time: elements['time'],
// //                   companyid: elements['companyid'],
// //               ),
// //           );
// //         }
// //       }
// //     }

// //     );
// //   } catch (e){
// //     print("An error occured: $e");
// //   }

// //   return tansactionInfoList;
// // }

// // Future<bool> saveTransaction(Transaction data) async {
// //    String q =
// //   "INSERT INTO [dbo].[transaction](cashin, cashout, notes, date, time, companyid) "
// //       "VALUES ('${data.cashin}', '${data.cashout}', '${data.notes}', '${data.date}','${data.time}', '${data.companyid}')";
// //   bool isSuccess = false;
// //   print(q);
// //   try {
// //     var result = await sqlConnection.getStatusOfQueryResult(
// //       q
// //     );

// //     if (result.runtimeType == String) {
// //       print("Error saving Transaction: $result");

// //     } else {
// //       isSuccess = true;  // Assuming successful execution returns something other than String
// //       print("Transaction saved successfully.");
// //     }
// //   } catch (e) {
// //     print("An error occurred: $e");
// //   }
// //   return isSuccess;
// // }

// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:sher_mech/utility/colorss.dart';
// import 'package:sher_mech/utility/databasedatails.dart';
// import 'package:sher_mech/utility/drawer.dart';
// import 'package:sher_mech/utility/font.dart';
// import 'package:sher_mech/views/vehiclemake.dart';

// class Vehiclemodal extends StatefulWidget {
//   const Vehiclemodal({super.key});

//   @override
//   State<Vehiclemodal> createState() => _VehiclemodalState();
// }

// class _VehiclemodalState extends State<Vehiclemodal> {

//   bool isLoading = false;
//   List<Map<String, dynamic>> vehiclemodalList = [];
//   final TextEditingController _titleController = TextEditingController();
//     final TextEditingController _subtitleController = TextEditingController();

//   final _formKey = GlobalKey<FormState>();

//   @override
//   void initState() {
//     super.initState();
//     connectAndGetData();
//   }

//  Future<void> connectAndGetData() async {
//   bool isConnected = await connect();
//   if (isConnected) {
//     await Getdata(); 
//   } else {
//     Fluttertoast.showToast(msg: 'Database connection failed');
//   }
// }

// Future<bool> post() async {
//   if (_formKey.currentState != null && _formKey.currentState!.validate()) {
//     setState(() {
//       isLoading = true;
//     });

//     String title = _titleController.text.replaceAll("'", "''");
//     String subtitle = _subtitleController.text.replaceAll("'", "''");

//     String queryMaxSiNo = 'SELECT MAX(ID) as MaxID FROM VehicleModel';
//     int nextID = 1;

//     try {
//       bool isConnected = await connect();
//       if (isConnected) {

//         Fluttertoast.showToast(msg: 'Database connection failed');
//         setState(() {
//           isLoading = false;
//         });
//         return false;
//       }

//       String maxSiNoResult = await sqlConnection.getData(queryMaxSiNo);
//       if (maxSiNoResult.isNotEmpty) {
//         List<dynamic> resultList = json.decode(maxSiNoResult);
//         if (resultList.isNotEmpty && resultList[0]['MaxID'] != null) {
//           nextID = resultList[0]['MaxID'] + 1;
//         }
//       }

//       String query = "INSERT INTO VehicleModel (modeltitle, modalsubtitle) VALUES ('$title', '$subtitle')";
//       String result = await sqlConnection.writeData(query);
//       Map<String, dynamic> valueMap = json.decode(result);
//       if (valueMap['affectedRows'] == 1) {
//         _titleController.clear();
//         _subtitleController.clear();
//         await Getdata();
//         setState(() {
//           isLoading = false;
//         });
//                 Fluttertoast.showToast(msg: "Vehicle added successfully");

//         return true;
//       } else {
//         Fluttertoast.showToast(msg: "Failed to add vehicle");
//         setState(() {
//           isLoading=false;
//         });
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: "Error: $e");
//     } 
//   }
//   return false;
// }

// Future<void> Getdata() async {
//   String query = 'SELECT * FROM VehicleModel ORDER BY ID';
//   setState(() {
//     isLoading = true;
//   });

//   try {
//     bool isConnected = await connect();
//     if (!isConnected) {
//       Fluttertoast.showToast(msg: 'Database connection failed');
//       setState(() {
//         isLoading = false;
//       });
//       return;
//     }

//     String result = await sqlConnection.getData(query);
//     if (result.isNotEmpty) {
//       List<dynamic> data = json.decode(result);
//       setState(() {
//         vehiclemodalList = List<Map<String, dynamic>>.from(data);
//       });
//     } else {
//       Fluttertoast.showToast(msg: 'No data found');
//       setState(() {
//         vehiclemodalList = [];
//       });
//     }
//   } catch (e) {
//     Fluttertoast.showToast(msg: 'Error: $e');
//   } finally {
//     setState(() {
//       isLoading = false;
//     });
//   }
// }



//   // final List<String> numbers = ["1", "2", "3", "4"];
//   // final List<String> names = [
//   //   "BULLET 350 TRIALS",
//   //   "STANDARD OLD MODEL",
//   //   "HUNTER 350",
//   //   "CLASSIC 350 REBORN"
//   // ];
//   // final List<String> subtitles = [
//   //   "Royal Enfield",
//   //   "Royal Enfield",
//   //   "Royal Enfield",
//   //   "Royal Enfield"
//   // ];
//   // final List<String> images = [
//   //   "assets/images/roralenfield-removebg-preview.png",
//   //   "assets/images/roralenfield-removebg-preview.png",
//   //   "assets/images/roralenfield-removebg-preview.png",
//   //   "assets/images/roralenfield-removebg-preview.png",
//   // ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Appcolors().Scfold,
//       appBar: AppBar(
//         toolbarHeight: 80,
//         backgroundColor: Color(0xFF0008B4),
//         title: Center(
//           child: Padding(
//             padding: const EdgeInsets.only(top: 20),
//             child: Text(
//               "Vehicle Modal",
//               style:appbarFonts(18, Colors.white),
//             ),
//           ),
//         ),
//         leading: Builder(
//           builder: (context) => InkWell(
//             onTap: () {
//               Scaffold.of(context).openDrawer();
//             },
//             child: Padding(
//               padding: const EdgeInsets.only(top: 20),
//               child: Container(
//                 child: Image.asset("assets/images/Menu (2).png",scale: 1.8,),
//               ),
//             ),
//           ),
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(top: 15),
//             child: Row(
//               children: [
//                 GestureDetector(
//                   onTap: (){
//                     adaPopup();
//                   },
//                   child: Container(
//                     width: 20,
//                     height: 22,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(4),
//                       border: Border.all(color: Colors.white, width: 2),
//                     ),
//                     child: Center(
//                       child: Icon(
//                         Icons.add,
//                         color: Colors.white,
//                         size: 17,
//                       ),
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   onPressed: () {},
//                   icon: FaIcon(FontAwesomeIcons.user, color: Colors.white),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       drawer: AppDrawer(),
//       body: Column(
//         children: [
//           Row(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(left: 19, right: 10,top: 13),
//                 child: Container(
//                   height: 39,
//                   width: 317,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(8),
//                     color: Colors.white,
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                     child: Row(
//                       children: [
//                         Icon(Icons.search, color: Colors.grey),
//                         SizedBox(width: 5),
//                         Expanded(
//                           child: TextField(
//                             decoration: InputDecoration(
//                               hintText: "Search..",
//                               hintStyle: TextStyle(fontSize: 13),
//                               border: InputBorder.none,
//                               contentPadding: EdgeInsets.only(bottom: 12),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(width: 8),
//               Padding(
//                 padding: const EdgeInsets.only(top: 12),
//                 child: Container(
//                   width: 39,
//                   height: 39,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     color: Color(0xFF0008B4),
//                   ),
//                   child: IconButton(
//                     onPressed: () {},
//                     icon: Icon(Icons.filter_list_alt, color: Colors.white),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 10), 
//           Expanded( 
//             child: Padding(
//               padding: const EdgeInsets.only(left: 16,right: 18),
//               child: ListView.separated(
//                 itemCount: vehiclemodalList.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return Container(
//   width: 358,
//   height: 59,
//   decoration: BoxDecoration(
//     borderRadius: BorderRadius.circular(5),
//     color: Appcolors().scafoldcolor,
//   ),
//   child: Center(
//     child: Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8.0), 
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               Text("ID: ${vehiclemodalList[index]['ID']}",style: getFonts(16, Colors.black)),
//               SizedBox(width: 10),
//               // CircleAvatar(
//               //   radius: 20,
//               //   backgroundColor: Colors.transparent,
//               //   child: Image.asset(images[index]),
//               // ),
//               SizedBox(width: 10),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center, // Centers text vertically
//                 children: [
//                   Text(vehiclemodalList[index]["modaltitle"], style: getFonts(16, Colors.black)),
//                   Text(vehiclemodalList[index]["modalsubtitle"], style: TextStyle(color: Colors.black,)),
//                 ],
//               ),
//             ],
//           ),
//           PopupMenuButton<String>(
//                         color: Appcolors().scafoldcolor,
//                         onSelected: (value) {
//                           if (value == 'Edit') {
                           
//                           } else if (value == 'Delete') {
//                           }
//                         },
//                         itemBuilder: (BuildContext context) => [
//                           PopupMenuItem(
//                             value: 'Edit',
//                             child: Text('Edit'),
//                           ),
//                           PopupMenuItem(
//                             value: 'Delete',
//                             child: Text('Delete'),
//                           ),
//                         ],
//                         icon: Icon(Icons.more_vert, color: Colors.black),
//                       ),
//         ],
//       ),
//     ),
//   ),
// )
// ;
//                 },
//                 separatorBuilder: (context, index) => SizedBox(height: 15),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//    adaPopup(
//     {
//       DateTime? date
//     }
//   ){
//     TextEditingController _vehiclemodalcntl =TextEditingController();
//     TextEditingController _vehiclebrandcntl =TextEditingController();


//  return showDialog(context: context, builder: (context){
//   return AlertDialog(
//     backgroundColor: Appcolors().Scfold,
//     title: Padding(
    
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "Enter Details"
//                   ),
//                   IconButton(onPressed: () {
//                     Navigator.pop(context);
//                   }, icon: Icon(Icons.close))
//                 ],
//               ),
//             ),
//             content: SingleChildScrollView(
//               child: Column(
//                 children: [
//                  textfield("Enter Vehicle modal", _vehiclemodalcntl),
//                  SizedBox(height: 15,),
//                 textfield("Enter Vehicle Brand", _vehiclebrandcntl),
//       const SizedBox(
//                     height: 15,
//                   ),
//                 GestureDetector(
//                   onTap: ()async{
//                      bool success =await post();
//                      if(success){
//                       Navigator.pop(context);
//                      }
//                   },
//                   child: Center(
//                     child: Container(
//                       width: 155,height: 43,
                       
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                       color:Color(0xFF0008B4),
//                       ),
//                       child: Center(child: 
//                       Text("Save",style: getFonts(14, Colors.white)),),
//                     ),
//                   ),
//                 ),
//                 ],
//               ),
//             ),
//   );
//  });
 
//   }

//   Widget textfield(
//     String hint,
//     TextEditingController controller,
//   ) {
//     return Container(
//       width: 290,
//       height: 58,
//       decoration: BoxDecoration(
//        // color: Appcolors().maincolor,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: TextField(
//         controller: controller,
//         decoration: InputDecoration(
//           isDense: true,
//           filled: true,
//           fillColor: Appcolors().scafoldcolor,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(20),
//             borderSide: BorderSide(color: Appcolors().maincolor),
//           ),
//           focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(20),
//               borderSide: BorderSide(color: Appcolors().maincolor)),
//           enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(20),
//               borderSide: BorderSide(color: Appcolors().maincolor)),
//           hintStyle: const TextStyle(color: Color(0xFF948C93)),
//           hintText: hint,
//         ),
//         autofocus: true,
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_async_autocomplete/flutter_async_autocomplete.dart';

// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   var autoController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Example',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: SafeArea(
//         child: Scaffold(
//           appBar: AppBar(title: Text('Example')),
//           body: Container(
//             padding: EdgeInsets.all(10),
//             alignment: Alignment.center,
//             child: AsyncAutocomplete<Country>(
//               controller: autoController,
//               onTapItem: (Country country) {
//                 autoController.text = country.name;
//                 print("selected Country ${country.name}");
//               },
//               suggestionBuilder: (data) => ListTile(
//                 title: Text(data.name),
//                 subtitle: Text(data.code),
//               ),
//               asyncSuggestions: (searchValue) => getCountry(searchValue),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Future<List<Country>> getCountry(String search) async {
//     List<Country> countryList = [
//       Country(name: 'Afghanistan', code: 'AF'),
//       Country(name: 'Åland Islands', code: 'AX'),
    
//     ];

//     await Future.delayed(const Duration(microseconds: 500));
//     return countryList
//         .where((element) =>
//             element.name.toLowerCase().startsWith(search.toLowerCase()))
//         .toList();
//   }

//   onChange(value) {
//     //  <Country>(value) {
//     setState(() {
//       autoController.text = value.name;
//     });
//     print('onChanged value: ${value.name}');
//   }
// }

// class Country {
//   String name;
//   String code;

//   Country({required this.code, required this.name});
// }
