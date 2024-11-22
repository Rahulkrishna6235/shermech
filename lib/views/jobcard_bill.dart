import 'dart:convert';

import 'package:easy_autocomplete/easy_autocomplete.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sher_mech/utility/colorss.dart';
import 'package:sher_mech/utility/databasedatails.dart';
import 'package:sher_mech/utility/drawer.dart';
import 'package:sher_mech/utility/font.dart';
import 'package:sher_mech/views/vehiclemake.dart';

class JobcardBill extends StatefulWidget {
  const JobcardBill({super.key});

  @override
  State<JobcardBill> createState() => _JobcardBillState();
}

class _JobcardBillState extends State<JobcardBill> {
 final TextEditingController _jobcardnoController=TextEditingController();
  final TextEditingController _closingdateController=TextEditingController();
 final TextEditingController _jobcard_dateController=TextEditingController();
 final TextEditingController _registernoController=TextEditingController();
 final TextEditingController _modalController=TextEditingController();
 final TextEditingController _makeController=TextEditingController();
 final TextEditingController _machanicController=TextEditingController();
 final TextEditingController _kvmcoverController=TextEditingController();
 final TextEditingController _jc_startnoController=TextEditingController();
 final TextEditingController _jc_finishController=TextEditingController();
  List<String> _vehicleNameSuggestions = [];
  List<String> _modelSuggestions = [];
  List<String> _makeSuggestions = [];
 bool isLoading=false;
 List JobcardbillList = [];

Future<void> getData_jobcard() async {
    String query = 'SELECT * FROM Newjobcard ORDER BY id';
    setState(() {
      isLoading = true;
    });

    try {
      bool isConnected = await connect();
      if (isConnected) {
        String result = await sqlConnection.getData(query);
        if (result.isNotEmpty) {
          List<dynamic> data = json.decode(result);
          setState(() {
            JobcardbillList = List<Map<String, dynamic>>.from(data);
            //filteredJobcardList = List.from(JobcardbillList); 
          });
        } else {
          Fluttertoast.showToast(msg: 'No data found');
          setState(() {
            JobcardbillList = [];
            //filteredJobcardList = [];
          });
        }
      } else {
        Fluttertoast.showToast(msg: 'Database connection failed');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

   Future<Map<String, List<String>>> getMultipleColumnsData(String searchValue) async {
  String query = 'SELECT registerno, model,make FROM Newjobcard WHERE registerno LIKE ? OR model LIKE ? OR make LIKE ?';
  Map<String, List<String>> suggestionsMap = {'registerno': [], 'model': [],'make': []};

  try {
    bool isConnected = await connect();
    if (isConnected) {
      String result = await sqlConnection.getData(query,);
      if (result.isNotEmpty) {
        List<dynamic> data = json.decode(result);
        for (var item in data) {
          suggestionsMap['registerno']?.add(item['registerno']);
          suggestionsMap['model']?.add(item['model']);
          suggestionsMap['make']?.add(item['make']);
        }
      }
    } else {
      Fluttertoast.showToast(msg: 'Database connection failed');
    }
  } catch (e) {
    Fluttertoast.showToast(msg: 'Error: $e');
  }

  return suggestionsMap;
}

void fetchSuggestions(String query) async {
  if (query.isNotEmpty) {
    Map<String, List<String>> fetchedSuggestions = await getMultipleColumnsData(query);

    setState(() {
      _vehicleNameSuggestions = fetchedSuggestions['registerno'] ?? [];
      _modelSuggestions = fetchedSuggestions['model'] ?? [];
      _makeSuggestions = fetchedSuggestions['make']??[];
    });
  } else {
    setState(() {
      _vehicleNameSuggestions = [];
      _modelSuggestions = [];
      _makeSuggestions=[];
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors().scafoldcolor,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Appcolors().maincolor,
      leading: Builder(
          builder: (context) => InkWell(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Container(
                child: Image.asset("assets/images/Menu (2).png",scale: 1.8,),
              ),
            ),
          ),
        ),
        title: Center(child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text("JOBCARD BILL",style: appbarFonts(18, Colors.white),),
        )),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: IconButton(onPressed: (){},  icon: FaIcon(FontAwesomeIcons.user,color: Colors.white,)),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 30,),
            
         Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                        
                        _newBillShortfield("jobcard No", _jobcardnoController),
                         Container(
           
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                  
                  Text("Date",style: getFonts(16, Colors.black),),
                  Text("*",style: TextStyle(fontSize: 16,color: Color(0xFFE22E37)),)
                ],),
               Container(
          height: 45,
                        width: 171,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
          child: TextField(
            onTap: () async {
              DateTime? selectedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900), 
                lastDate: DateTime(2100), 
              );
              if (selectedDate != null) {
                String formattedDate = DateFormat('MM/dd/yyyy').format(selectedDate);
                
                _jobcard_dateController.text = formattedDate;
              }
            },
            controller: _jobcard_dateController,
            readOnly: true, 
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(color: Appcolors().searchTextcolor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(color: Appcolors().searchTextcolor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(color: Appcolors().searchTextcolor),
              ),
              hintStyle: TextStyle(color: Appcolors().searchTextcolor),
              hintText: "Select Date",
            ),
            autofocus: true,
          ),
        ),
              ],
            ),
          )
                       ],) ,
                       SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                        
                         Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                  
                  Text("registerno",style: getFonts(16, Colors.black),),
                  Text("*",style: TextStyle(fontSize: 16,color: Color(0xFFE22E37)),)
                ],),
                Container(
                        height: 45,
                        width: 171,
                        decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white, 
                border: Border.all(color: Appcolors().searchTextcolor)
                        ),
                        child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0), 
                child:  EasyAutocomplete(
            suggestions: _vehicleNameSuggestions,
            onChanged: (value) {
              print('VehicleName onChanged: $value');
            },
            onSubmitted: (value) {
              _registernoController.text = value;
            },
          ),
                        ),
                      ),
              ],
            ),
          ),
                         Container(
           
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                  
                  Text("Jobcard Date",style: getFonts(16, Colors.black),),
                  Text("*",style: TextStyle(fontSize: 16,color: Color(0xFFE22E37)),)
                ],),
               Container(
          height: 45,
                        width: 171,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
          child: TextField(
            onTap: () async {
              DateTime? selectedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900), 
                lastDate: DateTime(2100), 
              );
              if (selectedDate != null) {
                String formattedDate = DateFormat('MM/dd/yyyy').format(selectedDate);
                
                _jobcard_dateController.text = formattedDate;
              }
            },
            controller: _jobcard_dateController,
            readOnly: true, 
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(color: Appcolors().searchTextcolor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(color: Appcolors().searchTextcolor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(color: Appcolors().searchTextcolor),
              ),
              hintStyle: TextStyle(color: Appcolors().searchTextcolor),
              hintText: "Select Date",
            ),
            autofocus: true,
          ),
        ),
              ],
            ),
          )
                       ],) ,
                       SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                        
                         Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                  
                  Text("make",style: getFonts(16, Colors.black),),
                  Text("*",style: TextStyle(fontSize: 16,color: Color(0xFFE22E37)),)
                ],),
                Container(
                        height: 45,
                        width: 171,
                        decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white, 
                border: Border.all(color: Appcolors().searchTextcolor)
                        ),
                        child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0), 
                child:  EasyAutocomplete(
            suggestions: _makeSuggestions,
            onChanged: (value) {
              print('VehicleName onChanged: $value');
            },
            onSubmitted: (value) {
              _makeController.text = value;
            },
          ),
                        ),
                      ),
              ],
            ),
          ),
            Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                  
                  Text("model",style: getFonts(16, Colors.black),),
                  Text("*",style: TextStyle(fontSize: 16,color: Color(0xFFE22E37)),)
                ],),
                Container(
                        height: 45,
                        width: 171,
                        decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white, 
                border: Border.all(color: Appcolors().searchTextcolor)
                        ),
                        child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0), 
                child: EasyAutocomplete(
            suggestions: _modelSuggestions,
            onChanged: (value) {
              print('VehicleName onChanged: $value');
            },
            onSubmitted: (value) {
              _modalController.text = value;
            },
          ),
                        ),
                      ),
              ],
            ),
          )

                        
                       ],) ,
                       SizedBox(height: 10,),
                       Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _newjobtxtShortfield("Mechanic", _jc_finishController),
                         _newjobtxtShortfield("KM Covered", _jc_finishController)

                        ],
                       ),
                       SizedBox(height: 10,),
                       Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _newjobtxtShortfield("JC start", _jc_finishController),
                         _newjobtxtShortfield("JC finish", _jc_finishController)

                        ],
                       ),
                       SizedBox(height: 10,),
                       Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _newjobtxtShortfield("Enigine No", _jc_finishController),
                         _newjobtxtShortfield("Chassis No", _jc_finishController)

                        ],
                       ),
                       SizedBox(height: 16,),
               Padding(
                 padding: const EdgeInsets.only(right: 247),
                 child: Text("Customer Details", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 14,decoration: TextDecoration.underline, )),
               ),
           SizedBox(height: 16,),
               Padding(
                 padding: const EdgeInsets.only(left: 25),
                 child: _Nnewjobtxtfield("Name", _registernoController),
               ),
               SizedBox(height: 10,),
               Padding(
                 padding: const EdgeInsets.only(left: 25),
                 child: Container(
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                  Row(children: [
                    Text("Adress",style: getFonts(16, Colors.black),),
                    Text("*",style: TextStyle(fontSize: 16,color: Color(0xFFE22E37)),)
                  ],),
                  Container(
                          height: 85,
                          width: 358,
                          decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white, 
                  border: Border.all(color: Appcolors().searchTextcolor)
                          ),
                          child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0), 
                  child: Row(
                    children: [
                      SizedBox(width: 5), 
                      Expanded( 
                        child: TextFormField(
                          controller: _closingdateController,
                           validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Adress';
                          }
                          return null;
                        },
                          obscureText: false,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(bottom: 12), 
                          ),
                        ),
                      ),
                    ],
                  ),
                          ),
                        ),
                               ],
                             ),
                           ),
               ),
               SizedBox(height: 16,),
               Padding(
                 padding: const EdgeInsets.only(left: 25),
                 child: _Nnewjobtxtfield("Mobile", _registernoController),
               ),
               SizedBox(height: 40,),
           Padding(
             padding: const EdgeInsets.only(left: 20),
             child: Column(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                 Padding(
                  padding: const EdgeInsets.only(right: 22),
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(5),topRight: Radius.circular(5)),
                          
                      border: Border(
                        top: BorderSide(color: Color(0xFF0008B4), width: 2),
                        bottom: BorderSide(color: Color(0xFF0008B4), width: 1),
                      ),
                      color: Color(0xFF0008B4),
                    ),
                    padding:  EdgeInsets.symmetric(vertical: 10),
                    child:Center(child: Text("Customer Request",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                  ),
                ),
                 Padding(
                   padding: const EdgeInsets.only(top: 6),
                   child: Container(
                               child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                               children:  [
                                                 Expanded(child: Padding(
                                                   padding: const EdgeInsets.only(left: 3),
                                                   child: Text("SL No", style: TextStyle(color: Color(0xFF838383), fontWeight: FontWeight.bold,fontSize: 12,decoration: TextDecoration.underline, )),
                                                 )),
                                                 Padding(
                                                   padding: const EdgeInsets.only(right: 43),
                                                   child: Text("Demand/Request", style: TextStyle(color: Color(0xFF838383), fontWeight: FontWeight.bold,fontSize: 12,decoration: TextDecoration.underline, )),
                                                 ),
                                              
                                               ],
                                             ),
                             ),
                 ),
             SizedBox(height: 140,),
             
                 Padding(
                  padding: const EdgeInsets.only(right: 22),
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(5),topRight: Radius.circular(5)),
                          
                      border: Border(
                        top: BorderSide(color: Color(0xFF0008B4), width: 2),
                        bottom: BorderSide(color: Color(0xFF0008B4), width: 1),
                      ),
                      color: Color(0xFF0008B4),
                    ),
                    padding:  EdgeInsets.symmetric(vertical: 10),
                    child:Center(child: Text("Spareparts Consumption Details",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                  ),
                ),
                 Padding(
                   padding: const EdgeInsets.only(top: 6),
                   child: Container(
                               child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                               children:  [
                                                 Expanded(child: Padding(
                                                   padding: const EdgeInsets.only(left: 3),
                                                   child: Text("SL No", style: TextStyle(color: Color(0xFF838383), fontWeight: FontWeight.bold,fontSize: 12,decoration: TextDecoration.underline, )),
                                                 )),
                                                 Padding(
                                                   padding: const EdgeInsets.only(right: 43),
                                                   child: Text("Spareparts Name", style: TextStyle(color: Color(0xFF838383), fontWeight: FontWeight.bold,fontSize: 12,decoration: TextDecoration.underline, )),
                                                 ),
                                                 Expanded(child: Center(child: Text("Amount", style: TextStyle(color: Color(0xFF838383), fontWeight: FontWeight.bold,fontSize: 12,decoration: TextDecoration.underline, )))),
                                               ],
                                             ),
                             ),
                 ),
             SizedBox(height: 140,),
             
                 Padding(
                  padding: const EdgeInsets.only(right: 22),
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(5),topRight: Radius.circular(5)),
                          
                      border: Border(
                        top: BorderSide(color: Color(0xFF0008B4), width: 2),
                        bottom: BorderSide(color: Color(0xFF0008B4), width: 1),
                      ),
                      color: Color(0xFF0008B4),
                    ),
                    padding:  EdgeInsets.symmetric(vertical: 10),
                    child:Center(child: Text("Operation & Labour Schedule",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                  ),
                ),
                 Padding(
                   padding: const EdgeInsets.only(top: 6),
                   child: Container(
                               child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                               children:  [
                                                 Expanded(child: Padding(
                                                   padding: const EdgeInsets.only(left: 3),
                                                   child: Text("SL No", style: TextStyle(color: Color(0xFF838383), fontWeight: FontWeight.bold,fontSize: 12,decoration: TextDecoration.underline, )),
                                                 )),
                                                 Padding(
                                                   padding: const EdgeInsets.only(right: 43),
                                                   child: Text("Charges", style: TextStyle(color: Color(0xFF838383), fontWeight: FontWeight.bold,fontSize: 12,decoration: TextDecoration.underline, )),
                                                 ),
                                                 Expanded(child: Center(child: Text("Amount", style: TextStyle(color: Color(0xFF838383), fontWeight: FontWeight.bold,fontSize: 12,decoration: TextDecoration.underline, )))),
                                               ],
                                             ),
                             ),
                 ),
              ],
             ),
           ),
               SizedBox(height: 140,),
                Padding(
                 padding: const EdgeInsets.only(right: 247),
                 child: Text("Payment Details", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 14,decoration: TextDecoration.underline, )),
               ),
               SizedBox(height: 20,),
                Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [Text("Total",style: getFonts(12, Colors.black),),
                      SizedBox(width: 4,),
                      Text(":",style: getFonts(12, Colors.black),),
                      SizedBox(width: 4,),
                      Text("5000",style: getFonts(12, Colors.black),),
                      ],
                    ),
                     SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [Text("Total",style: getFonts(12, Colors.black),),
                      SizedBox(width: 4,),
                      Text(":",style: getFonts(12, Colors.black),),
                      SizedBox(width: 4,),
                      Text("5000",style: getFonts(12, Colors.black),),
                      ],
                    ),
                     SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [Text("Total",style: getFonts(12, Colors.black),),
                      SizedBox(width: 4,),
                      Text(":",style: getFonts(12, Colors.black),),
                      SizedBox(width: 4,),
                      Text("5000",style: getFonts(12, Colors.black),),
                      ],
                    ),
 SizedBox(height: 30,),
               GestureDetector(
                  onTap: (){
                    
                  },
                  child: Container(
                    height: 44,width: 358,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                       color: Color(0xFF0A1EBE), 
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [Text("Total",style: getFonts(12, Colors.white),),
                      SizedBox(height: 10,),
                      Text(":",style: getFonts(12, Colors.white),),
                      Text("5000",style: getFonts(12, Colors.white),),
                      ],
                    ),
                     ),
                ),
                SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }

  Widget _Botton (String Txt){
  return GestureDetector(
                  onTap: (){
                    
                  },
                  child: Container(
                    height: 44,width: 171,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                       color: Color(0xFF0A1EBE), 
                    ),
                    child: Center(child: Text(Txt,style: getFonts(12, Colors.white)),
                   ) ),
                );
}

   Widget _newBillShortfield (String textrow,TextEditingController controller){
    return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                  
                  Text(textrow,style: getFonts(16, Colors.black),),
                  Text("*",style: TextStyle(fontSize: 16,color: Color(0xFFE22E37)),)
                ],),
                Container(
                        height: 45,
                        width: 171,
                        decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white, 
                border: Border.all(color: Appcolors().searchTextcolor)
                        ),
                        child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0), 
                child: Row(
                  children: [
                    SizedBox(width: 5), 
                    Expanded( 
                      child: TextFormField(
                        controller: controller,
                         validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter $textrow';
                        }
                        return null;
                      },
                        obscureText: false,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(bottom: 12), 
                        ),
                      ),
                    ),
                  ],
                ),
                        ),
                      ),
                      
              ],
            ),
          );
  }

  Widget _newjobtxtShortfield (String textrow,TextEditingController controller){
    return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                  
                  Text(textrow,style: getFonts(16, Colors.black),),
                  Text("*",style: TextStyle(fontSize: 16,color: Color(0xFFE22E37)),)
                ],),
                Container(
                        height: 45,
                        width: 171,
                        decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white, 
                border: Border.all(color: Appcolors().searchTextcolor)
                        ),
                        child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0), 
                child: Row(
                  children: [
                    SizedBox(width: 5), 
                    Expanded( 
                      child: TextFormField(
                        controller: controller,
                         validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter $textrow';
                        }
                        return null;
                      },
                        obscureText: false,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(bottom: 12), 
                        ),
                      ),
                    ),
                  ],
                ),
                        ),
                      ),
              ],
            ),
          );
  }
  Widget _Nnewjobtxtfield (String textrow,TextEditingController controller){
    return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Text(textrow,style: getFonts(16, Colors.black),),
                  Text("*",style: TextStyle(fontSize: 16,color: Color(0xFFE22E37)),)
                ],),
                Container(
                        height: 45,
                        width: 358,
                        decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white, 
                border: Border.all(color: Appcolors().searchTextcolor)
                        ),
                        child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0), 
                child: Row(
                  children: [
                    SizedBox(width: 5), 
                    Expanded( 
                      child: TextFormField(
                        controller: controller,
                         validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter $textrow';
                        }
                        return null;
                      },
                        obscureText: false,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(bottom: 12), 
                        ),
                      ),
                    ),
                  ],
                ),
                        ),
                      ),
              ],
            ),
          );
  }
   
}