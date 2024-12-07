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
import 'package:flutter/material.dart';
import 'package:easy_autocomplete/easy_autocomplete.dart';

class AutoCompleteWithFutureBuilder extends StatefulWidget {
  @override
  _AutoCompleteWithFutureBuilderState createState() =>
      _AutoCompleteWithFutureBuilderState();
}

class _AutoCompleteWithFutureBuilderState
    extends State<AutoCompleteWithFutureBuilder> {
  final TextEditingController _subtitleController = TextEditingController();
  late Future<List<String>> _suggestionsFuture;

  @override
  void initState() {
    super.initState();
    _suggestionsFuture = fetchInitialSuggestions(); // Load initial data
  }

  Future<List<String>> fetchInitialSuggestions() async {
    // Simulate a delay for initial fetch
    await Future.delayed(Duration(seconds: 2));
    return ["Initial", "Suggestions", "For", "AutoComplete"];
  }

  Future<List<String>> fetchSuggestions(String query) async {
    // Simulate a search suggestion fetch
    await Future.delayed(Duration(seconds: 1));
    return [
      "$query Suggestion 1",
      "$query Suggestion 2",
      "$query Suggestion 3"
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Autocomplete with FutureBuilder"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<String>>(
          future: _suggestionsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (snapshot.hasData) {
              final _suggestions = snapshot.data ?? [];

              return EasyAutocomplete(
                progressIndicatorBuilder: Center(
                  child: CircularProgressIndicator(),
                ),
                controller: _subtitleController,
                suggestions: _suggestions,
                onChanged: (value) {
                  setState(() {
                    _suggestionsFuture = fetchSuggestions(value);
                  });
                },
                onSubmitted: (value) {
                  print('Selected value: $value');
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Start typing...",
                ),
              );
            } else {
              return Center(child: Text("No suggestions available."));
            }
          },
        ),
      ),
    );
  }
}
//  Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
                        
//                          Container(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
                  
//                   Text("make",style: getFonts(16, Colors.black),),
//                   Text("*",style: TextStyle(fontSize: 16,color: Color(0xFFE22E37)),)
//                 ],),
//                 Container(
//                         height: 45,
//                         width: 171,
//                         decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(5),
//                 color: Colors.white, 
//                 border: Border.all(color: Appcolors().searchTextcolor)
//                         ),
//                         child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8.0), 
//                 child:  EasyAutocomplete(
//             suggestions: _makeSuggestions,
//             onChanged: (value) {
//               print('VehicleName onChanged: $value');
//             },
//             onSubmitted: (value) {
//               _makeController.text = value;
//             },
//           ),
//                         ),
//                       ),
//               ],
//             ),
//           ),
//             Container(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
                  
//                   Text("model",style: getFonts(16, Colors.black),),
//                   Text("*",style: TextStyle(fontSize: 16,color: Color(0xFFE22E37)),)
//                 ],),
//                 Container(
//                         height: 45,
//                         width: 171,
//                         decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(5),
//                 color: Colors.white, 
//                 border: Border.all(color: Appcolors().searchTextcolor)
//                         ),
//                         child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8.0), 
//                 child: EasyAutocomplete(
//             suggestions: _modelSuggestions,
//             onChanged: (value) {
//               print('VehicleName onChanged: $value');
//             },
//             onSubmitted: (value) {
//               _modalController.text = value;
//             },
//           ),
//                         ),
//                       ),
//               ],
//             ),
//           )

                        
//                        ],) ,



//  Future<Map<String, List<String>>> getMultipleColumnsData(String searchValue) async {
//   String query = 'SELECT registerno, model,make FROM Newjobcard WHERE registerno LIKE ? OR model LIKE ? OR make LIKE ?';
//   Map<String, List<String>> suggestionsMap = {'registerno': [], 'model': [],'make': []};

//   try {
//     bool isConnected = await connect();
//     if (isConnected) {
//       String result = await sqlConnection.getData(query,);
//       if (result.isNotEmpty) {
//         List<dynamic> data = json.decode(result);
//         for (var item in data) {
//           suggestionsMap['registerno']?.add(item['registerno']);
//           suggestionsMap['model']?.add(item['model']);
//           suggestionsMap['make']?.add(item['make']);
//         }
//       }
//     } else {
//       Fluttertoast.showToast(msg: 'Database connection failed');
//     }
//   } catch (e) {
//     Fluttertoast.showToast(msg: 'Error: $e');
//   }

//   return suggestionsMap;
// }

// void fetchSuggestions(String query) async {
//   if (query.isNotEmpty) {
//     Map<String, List<String>> fetchedSuggestions = await getMultipleColumnsData(query);

//     setState(() {
//       _vehicleNameSuggestions = fetchedSuggestions['registerno'] ?? [];
//       _modelSuggestions = fetchedSuggestions['model'] ?? [];
//       _makeSuggestions = fetchedSuggestions['make']??[];
//     });
//   } else {
//     setState(() {
//       _vehicleNameSuggestions = [];
//       _modelSuggestions = [];
//       _makeSuggestions=[];
//     });
//   }
// }

//  fetchSuggestions(String query) async {
   
//     if (query.isNotEmpty) {
//       setState(() {
//         isLoading = true;
//       });
//     // if (query.isNotEmpty) {
//     await Future.delayed(Duration(seconds: 1));
//       List<String> fetchedSuggestions = await  gggetData(query);
//       setState(() {
//        _suggestions = fetchedSuggestions.map((e) => e).toList();
//        fetchedSuggestions=_suggestions;
//        isLoading=false;
//       //   fetchedSuggestions.firstWhere((element) {
//       // return element.toLowerCase().contains(query.toLowerCase());
//       //   },);
//       });
//     // } else {
//     //   setState(() {
//     //     _suggestions = [];
//     //   });
//     // }
//     // return _suggestions;
//   }else {
//       setState(() {
//         _suggestions = [];
//       });
//     }
//    }

// child: Container(
//                   width: 100,height: 40,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20),
//                     color: Appcolors().maincolor
//                   ),
//                   child: Text("Apply"),
//                 ),
//  import 'dart:io';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:path_provider/path_provider.dart';

// Future<File> generateInvoice(List<Map<String, dynamic>> reportList) async {
//   final pdf = pw.Document();

//   // Add the first page with table and invoice data
//   pdf.addPage(
//     pw.Page(
//       build: (pw.Context context) {
//         return pw.Column(
//           crossAxisAlignment: pw.CrossAxisAlignment.start,
//           children: [
//             // Title of the Report (Invoice)
//             pw.Text("JobCard Report", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, font: pw.Font.courier())),
//             pw.SizedBox(height: 20),

//             // Table with the report data (list of jobs)
      

//             pw.SizedBox(height: 30), // Space between table and invoice details

//             // Invoice details, placed to the right side of the table
//             pw.Row(
//               crossAxisAlignment: pw.CrossAxisAlignment.start,
//               children: [
//                 // Left side: Job Card Table
//                 pw.Expanded(
//                   flex: 3,
//                   child: pw.Column(
//                     crossAxisAlignment: pw.CrossAxisAlignment.start,
//                     children: [
//                       // Invoice Title
//                       pw.Text("Invoice", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
//                       pw.SizedBox(height: 10),

//                       // Dynamically fetch customer and job card data from the first entry in reportList
//                       pw.Text("Customer Name: ${reportList.isNotEmpty ? reportList[0]['customername'] ?? '' : ''}", style: pw.TextStyle(fontSize: 16)),
//                       pw.Text("Job Card No: ${reportList.isNotEmpty ? reportList[0]['jobcardno'] ?? '' : ''}", style: pw.TextStyle(fontSize: 16)),
//                       pw.Text("Model: ${reportList.isNotEmpty ? reportList[0]['model'] ?? '' : ''}", style: pw.TextStyle(fontSize: 16)),
//                       pw.Text("Register No: ${reportList.isNotEmpty ? reportList[0]['registerno'] ?? '' : ''}", style: pw.TextStyle(fontSize: 16)),
//                       pw.SizedBox(height: 20),
//                       pw.Text("Thank you for your business!", style: pw.TextStyle(fontSize: 16)),
//                     ],
//                   ),
//                 ),

//                 // Right side: Invoice Information or Additional Info (such as Invoice No and Date)
//                 pw.Expanded(
//                   flex: 2,
//                   child: pw.Column(
//                     crossAxisAlignment: pw.CrossAxisAlignment.start,
//                     children: [
//                       // Invoice Info Section
//                       pw.Text("Invoice No: INV-123456", style: pw.TextStyle(fontSize: 16)),
//                       pw.Text("Date: ${DateTime.now().toLocal().toString().split(' ')[0]}", style: pw.TextStyle(fontSize: 16)),
//                       pw.Text("Due Date: ${DateTime.now().toLocal().add(Duration(days: 7)).toString().split(' ')[0]}", style: pw.TextStyle(fontSize: 16)),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         );
//       },
//     ),
//   );

//   // Save the generated PDF to the app's document directory
//   final outputDirectory = await getApplicationDocumentsDirectory();
//   final file = File("${outputDirectory.path}/jobcard_report.pdf");
//   await file.writeAsBytes(await pdf.save());
//   return file;
// }
// Future<File> generateInvoiceUsingControllerData() async {
//   final pdf = pw.Document();

//   // Check if any field is empty (basic validation)
//   if (_jobcardnoController.text.isEmpty || _customernameController.text.isEmpty) {
//     return Future.error("Please enter the necessary data before generating the invoice.");
//   }

//   // Create a new page for the invoice
//   pdf.addPage(
//     pw.Page(
//       build: (pw.Context context) {
//         return pw.Column(
//           crossAxisAlignment: pw.CrossAxisAlignment.start,
//           children: [
//             // Title of the Invoice
//             pw.Text("JobCard Invoice", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
//             pw.SizedBox(height: 20),

//             // Customer Information Section
//             pw.Text("Customer Information", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
//             pw.SizedBox(height: 5),
//             pw.Row(
//               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//               children: [
//                 pw.Text("Customer Name: ", style: pw.TextStyle(fontSize: 16)),
//                 pw.Text(_customernameController.text, style: pw.TextStyle(fontSize: 16)),
//               ],
//             ),
//             pw.Row(
//               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//               children: [
//                 pw.Text("Location: ", style: pw.TextStyle(fontSize: 16)),
//                 pw.Text(_locationController.text, style: pw.TextStyle(fontSize: 16)),
//               ],
//             ),
//             pw.Row(
//               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//               children: [
//                 pw.Text("Mobile: ", style: pw.TextStyle(fontSize: 16)),
//                 pw.Text(_mobileController.text, style: pw.TextStyle(fontSize: 16)),
//               ],
//             ),
//             pw.SizedBox(height: 15),

//             // Vehicle Information Section
//             pw.Text("Vehicle Information", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
//             pw.SizedBox(height: 5),
//             pw.Row(
//               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//               children: [
//                 pw.Text("Job Card No: ", style: pw.TextStyle(fontSize: 16)),
//                 pw.Text(_jobcardnoController.text, style: pw.TextStyle(fontSize: 16)),
//               ],
//             ),
//             pw.Row(
//               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//               children: [
//                 pw.Text("Model: ", style: pw.TextStyle(fontSize: 16)),
//                 pw.Text(_modelController.text, style: pw.TextStyle(fontSize: 16)),
//               ],
//             ),
//             pw.Row(
//               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//               children: [
//                 pw.Text("Register No: ", style: pw.TextStyle(fontSize: 16)),
//                 pw.Text(_registernoController.text, style: pw.TextStyle(fontSize: 16)),
//               ],
//             ),
//             pw.Row(
//               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//               children: [
//                 pw.Text("Chassis No: ", style: pw.TextStyle(fontSize: 16)),
//                 pw.Text(_chassisnoController.text, style: pw.TextStyle(fontSize: 16)),
//               ],
//             ),
//             pw.SizedBox(height: 15),

//             // Technician Information Section
//             pw.Text("Technician Information", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
//             pw.SizedBox(height: 5),
//             pw.Row(
//               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//               children: [
//                 pw.Text("Technician: ", style: pw.TextStyle(fontSize: 16)),
//                 pw.Text(_technicionController.text, style: pw.TextStyle(fontSize: 16)),
//               ],
//             ),
//             pw.Row(
//               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//               children: [
//                 pw.Text("Technician Voice: ", style: pw.TextStyle(fontSize: 16)),
//                 pw.Text(_technicianvoiceController.text, style: pw.TextStyle(fontSize: 16)),
//               ],
//             ),
//             pw.SizedBox(height: 15),

//             // Arrival and Delivery Date Section
//             pw.Text("Dates", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
//             pw.SizedBox(height: 5),
//             pw.Row(
//               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//               children: [
//                 pw.Text("Arrival Date: ", style: pw.TextStyle(fontSize: 16)),
//                 pw.Text(_ariveDateController.text, style: pw.TextStyle(fontSize: 16)),
//               ],
//             ),
//             pw.Row(
//               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//               children: [
//                 pw.Text("Delivery Date: ", style: pw.TextStyle(fontSize: 16)),
//                 pw.Text(_deliverDateController.text, style: pw.TextStyle(fontSize: 16)),
//               ],
//             ),
//             pw.SizedBox(height: 20),

//             // Invoice Details Section
//             pw.Text("Invoice Details", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
//             pw.SizedBox(height: 5),
//             pw.Row(
//               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//               children: [
//                 pw.Text("Invoice No: ", style: pw.TextStyle(fontSize: 16)),
//                 pw.Text("INV-123456", style: pw.TextStyle(fontSize: 16)), // Static Invoice No, you can make it dynamic
//               ],
//             ),
//             pw.Row(
//               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//               children: [
//                 pw.Text("Date: ", style: pw.TextStyle(fontSize: 16)),
//                 pw.Text("${DateTime.now().toLocal().toString().split(' ')[0]}", style: pw.TextStyle(fontSize: 16)), // Current Date
//               ],
//             ),
//             pw.Row(
//               mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//               children: [
//                 pw.Text("Due Date: ", style: pw.TextStyle(fontSize: 16)),
//                 pw.Text("${DateTime.now().toLocal().add(Duration(days: 7)).toString().split(' ')[0]}", style: pw.TextStyle(fontSize: 16)), // 7 Days from the current date
//               ],
//             ),
//             pw.SizedBox(height: 20),

//             // Thank You Note
//             pw.Text("Thank you for your business!", style: pw.TextStyle(fontSize: 16)),
//           ],
//         );
//       },
//     ),
//   );

//   // Save the generated PDF to the app's document directory
//   final outputDirectory = await getApplicationDocumentsDirectory();
//   final file = File("${outputDirectory.path}/jobcard_invoice.pdf");
//   await file.writeAsBytes(await pdf.save());
//   return file;
// }
// Future<void> GenerateAndSharePDF() async {
//   final pdf = pw.Document();
// List<Ledgermodall> filteredData = [];
//   pdf.addPage(
//     pw.Page(
//       build: (pw.Context context) {
//         return pw.Column(
//           crossAxisAlignment: pw.CrossAxisAlignment.start,
//           children: [
//             pw.Text(
//               'Financial Report',
//               style: pw.TextStyle(
//                 fontSize: 24,
//                 fontWeight: pw.FontWeight.bold,
//               ),
//             ),
//             pw.SizedBox(height: 20),
           
//             pw.Text(
//               'Filter Data',
//               style: pw.TextStyle(
//                 fontSize: 18,
//                 fontWeight: pw.FontWeight.bold,
//               ),
//             ),
//              pw.SizedBox(height: 5),
//             pw.Table.fromTextArray(
//               border: pw.TableBorder.all(),
//               headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
//               headerHeight: 30,
//               cellHeight: 30,
//               cellAlignments: {
//                 0: pw.Alignment.centerLeft,
//                 1: pw.Alignment.centerLeft,
//                 2: pw.Alignment.centerLeft,
//                 3: pw.Alignment.centerLeft,
//                 4: pw.Alignment.centerLeft,
//                 5: pw.Alignment.centerLeft,
//                 6: pw.Alignment.centerLeft,
//               },
//               headers: <String>['SI NO', 'DATE', 'NAME', 'LEDGER TYPE', 'DESCRIPTION', 'CREDIT', 'DEBIT'],
//               data: List.generate(filteredData.length, (index) {
//                 final e = filteredData[index];
//                 return [
//                   (index + 1).toString(),  // SiNo
//                   DateFormat('yyyy-MM-dd').format(e.date),
//                   e.names.name.toString(),
//                   e.ledgerType.expenseType.toString(),
//                   e.description,
//                   e.credit.toString(),
//                   e.debit.toString(),
//                 ];
//               }),
//             ),
//           ],
//         );
//       },
//     ),
//   );

//   final tempDir = await getTemporaryDirectory();
//   final tempPath = tempDir.path;
//   final tempFile = File('$tempPath/report.pdf');
//   await tempFile.writeAsBytes(await pdf.save());

//   await Share.shareXFiles([XFile('$tempPath/report.pdf')], text: 'Financial Report');


  
// }
// import 'package:flutter/material.dart';
// import 'api_jobcard_repository.dart'; // Import the API repository class

// class JobCardScreen extends StatefulWidget {
//   @override
//   _JobCardScreenState createState() => _JobCardScreenState();
// }

// class _JobCardScreenState extends State<JobCardScreen> {
//   int _selectedIndex = 0; // To track selected tab (0 for Pending Jobcards, 1 for Pending Delivery)
//   late Future<List<dynamic>> jobcards; // Future variable for storing job card data
//   TextEditingController _searchController = TextEditingController(); // Controller for search field
//   List<dynamic> filteredJobcardList = []; // To store filtered job cards

//   @override
//   void initState() {
//     super.initState();
//     jobcards = ApiJobcardRepository().getjobcard(); // Fetch jobcards when screen is loaded
//   }

//   void _OnTabSelected(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//     // Filter or load different job cards based on tab
//     // You can update the jobcards here based on the selected tab (index)
//   }

//   // Filter function for search functionality
//   void _filterSearchResults() {
//     setState(() {
//       filteredJobcardList = jobcards as List<dynamic>; // Filter jobcards based on search query
//       if (_searchController.text.isNotEmpty) {
//         filteredJobcardList = filteredJobcardList
//             .where((jobcard) => jobcard['customername']
//                 .toLowerCase()
//                 .contains(_searchController.text.toLowerCase()))
//             .toList();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Job Cards")),
//       body: Column(
//         children: [
//           SizedBox(height: 5),

//           // Tab Buttons
//           Tab(
//             child: Padding(
//               padding: const EdgeInsets.only(left: 14, right: 14),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   GestureDetector(
//                     onTap: () => _OnTabSelected(0),
//                     child: Container(
//                       width: 175,
//                       height: 33,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(18),
//                         color: _selectedIndex == 0 ? Color(0xFF0008B4) : Colors.white,
//                       ),
//                       child: Center(
//                         child: Text(
//                           "PENDING JOBCARDS",
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: _selectedIndex == 0 ? Colors.white : Colors.black,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   GestureDetector(
//                     onTap: () => _OnTabSelected(1),
//                     child: Container(
//                       width: 175,
//                       height: 33,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(18),
//                         color: _selectedIndex == 1 ? Color(0xFF0008B4) : Colors.white,
//                       ),
//                       child: Center(
//                         child: Text(
//                           "PENDING DELIVERY",
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: _selectedIndex == 1 ? Colors.white : Colors.black,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           SizedBox(height: 10),

//           // Search Field
//           Padding(
//             padding: const EdgeInsets.only(left: 11, right: 10),
//             child: Container(
//               height: 39,
//               width: 358,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8),
//                 color: Colors.white,
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                 child: Row(
//                   children: [
//                     GestureDetector(
//                       onTap: _filterSearchResults,
//                       child: Icon(Icons.search, color: Colors.grey, size: 18),
//                     ),
//                     SizedBox(width: 5),
//                     Expanded(
//                       child: TextField(
//                         controller: _searchController,
//                         decoration: InputDecoration(
//                           hintText: "Search",
//                           hintStyle: TextStyle(color: Colors.grey),
//                           border: InputBorder.none,
//                           contentPadding: EdgeInsets.only(bottom: 12),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),

//           SizedBox(height: 20),

//           // Displaying Jobcards
//           Expanded(
//             child: FutureBuilder<List<dynamic>>(
//               future: jobcards, // Fetch jobcards data asynchronously
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text("Error: ${snapshot.error}"));
//                 } else if (snapshot.hasData) {
//                   // If jobcards data is available
//                   filteredJobcardList = snapshot.data!;

//                   return ListView.separated(
//                     separatorBuilder: (context, index) => SizedBox(height: 20),
//                     itemCount: filteredJobcardList.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       int sn = index + 1;
//                       return Padding(
//                         padding: const EdgeInsets.only(left: 26, right: 26),
//                         child: Container(
//                           width: 358,
//                           height: 260,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.only(
//                               topLeft: Radius.circular(5),
//                               topRight: Radius.circular(5),
//                             ),
//                             color: Color(0xFFFFFFFF),
//                           ),
//                           child: Column(
//                             children: [
//                               Container(
//                                 width: 358,
//                                 height: 35,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.only(
//                                     topLeft: Radius.circular(5),
//                                     topRight: Radius.circular(5),
//                                   ),
//                                   color: Color(0xFF0008B4),
//                                 ),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Padding(
//                                       padding: const EdgeInsets.only(left: 15),
//                                       child: Text("SN :  $sn", style: TextStyle(color: Colors.white)),
//                                     ),
//                                     PopupMenuButton<String>(
//                                       color: Colors.white,
//                                       onSelected: (value) {
//                                         if (value == 'Edit') {
//                                           // Edit action
//                                         } else if (value == 'Delete') {
//                                           // Delete action
//                                         }
//                                       },
//                                       itemBuilder: (BuildContext context) => [
//                                         PopupMenuItem(
//                                           value: 'Edit',
//                                           child: Row(
//                                             children: [
//                                               Icon(Icons.edit, color: Colors.blue),
//                                               Text('Edit'),
//                                             ],
//                                           ),
//                                         ),
//                                         PopupMenuItem(
//                                           value: 'Delete',
//                                           child: Row(
//                                             children: [
//                                               Icon(Icons.delete, color: Colors.red),
//                                               Text('Delete'),
//                                             ],
//                                           ),
//                                         ),
//                                       ],
//                                       icon: Icon(Icons.more_horiz, color: Colors.white),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               SizedBox(height: 5),
//                      Padding(
//                        padding: const EdgeInsets.only(left: 15),
//                        child: Row(
//                         children: [
//                           _listcontents("DATE"),
//                         Expanded(flex: 3, child: Text(" :   ${jobcardList[index]['arivedate']}  ",style: filedFonts())),
//                         ],
//                        ),
//                      ),
//                                           SizedBox(height: 5,),
//                      Padding(
//                        padding: const EdgeInsets.only(left: 15),
//                        child: Row(
//                         children: [
//                           _listcontents("JOBCARD NO"),
//                         Expanded(flex: 3, child: Text(" :   ${jobcardList[index]['jobcardno']} ",style: filedFonts())),
//                         ],
//                        ),
//                      ),
//                                 SizedBox(height: 5,),
//                      Padding(
//                        padding: const EdgeInsets.only(left: 15),
//                        child: Row(
//                         children: [
//                           _listcontents("CUSTOMER NAME"),
//                         Expanded(flex: 3, child: Text(" :   ${jobcardList[index]['customername']} ",style: filedFonts())),
//                         ],
//                        ),
//                      ),
//                                           SizedBox(height: 5,),
//                      Padding(
//                        padding: const EdgeInsets.only(left: 15),
//                        child: Row(
//                         children: [
//                           _listcontents("MODEL"),
//                         Expanded(flex: 3, child: Text(" :   ${jobcardList[index]['model']}",style: filedFonts())),
//                         ],
//                        ),
//                      ),
//                                           SizedBox(height: 5,),
//                      Padding(
//                        padding: const EdgeInsets.only(left: 15),
//                        child: Row(
//                         children: [
//                           _listcontents("REGISTRATION NO"),
//                         Expanded(flex: 3, child: Text(" :   ${jobcardList[index]['registerno']}",style: filedFonts())),
//                         ],
//                        ),
//                      ),
//                                           SizedBox(height: 5,),
//                      Padding(
//                        padding: const EdgeInsets.only(left: 15),
//                        child: Row(
//                         children: [
//                           _listcontents("REMARK"),
//                         Expanded(flex: 3, child: Text(" :   ${jobcardList[index]['remark']} ",style: filedFonts(),)),
//                         ],
//                        ),
//                      )
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 } else {
//                   return Center(child: Text("No data available"));
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
  

  //  void _filterSearchResults(String query) {
//   setState(() {
//     if (query.isEmpty) {
//       reportlist = List.of(originalReportList);  
//     } else {
//       filter_reportlist = reportlist.where((jobreport) {
//         if (filterCriteria == 'Name') {
//           return jobreport['customername']?.toLowerCase().contains(query) ?? false;
//         } else if (filterCriteria == 'Jobcard No') {
//           return jobreport['jobcardno']?.toString().toLowerCase().contains(query) ?? false;
//         }
//         return false;
//       }).toList();
//       reportlist = filter_reportlist;
//     }
//   });
// }


