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
  final TextEditingController _chassisNoController=TextEditingController();
    final TextEditingController _engineNoController=TextEditingController();
        final TextEditingController _nameNoController=TextEditingController();
    final TextEditingController _adressNoController=TextEditingController();
    final TextEditingController _phonenoNoController=TextEditingController();
final TextEditingController _cusvoiceController=TextEditingController();
final TextEditingController _totalAmountController=TextEditingController();
final TextEditingController _discountControler=TextEditingController();


  List<String> _vehicleNameSuggestions = [];
  List<String> _modelSuggestions = [];
  List<String> _makeSuggestions = [];
 bool isLoading=false;
 List JobcardbillList = [];
 List performaList = [];
String totalAmountString = '0.00';

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

Future<void> get_Performa() async {
    String query = 'SELECT * FROM PerformaPerticular ORDER BY JobcardNo';
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
            performaList = List<Map<String, dynamic>>.from(data);
            //filteredJobcardList = List.from(JobcardbillList); 
          });
        } else {
          Fluttertoast.showToast(msg: 'No data found');
          setState(() {
            performaList = [];
            //filteredJobcardList = [];
            performaList.clear();
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

 void onJobcardSelected(String jobcardNo) {
  final selectedJobcard = JobcardbillList.firstWhere(
    (jobcard) => jobcard['jobcardno'] == jobcardNo,
    orElse: () => <String, dynamic>{} 
  );

 final selectedPerforma = performaList
    .where((performa) => performa['Jobcardno'] == jobcardNo)
    .toList();

      

  if (selectedJobcard.isNotEmpty) {
    setState(() {
      _jobcard_dateController.text = selectedJobcard['arivedate'] ?? '';
      _registernoController.text = selectedJobcard['registerno'] ?? '';
      _modalController.text = selectedJobcard['model'] ?? '';
      _makeController.text = selectedJobcard['make'] ?? '';
      _machanicController.text = selectedJobcard['Technicians'] ?? '';
      _kvmcoverController.text = selectedJobcard['kilometer'].toString() ;
      _jc_startnoController.text = selectedJobcard['jc_start'] ?? '';
      _jc_finishController.text = selectedJobcard['jc_finish'] ?? '';
      _engineNoController.text = selectedJobcard['engine_no'] ?? '';
      _chassisNoController.text = selectedJobcard['chassisno'] ?? '';
      _nameNoController.text = selectedJobcard['customername'] ?? '';
      _adressNoController.text = selectedJobcard['adress'] ?? '';
      _phonenoNoController.text = selectedJobcard['mobilenumber'] ?? '';
      _cusvoiceController.text = selectedJobcard['customervoice'] ?? '';
      
      performaList = selectedPerforma.map((performa) {
  return {
    'labourschedule': performa['labourschedule'] ?? '',
    'amount': (performa['amount'] ?? '').toString(), 
  };
}).toList();

  double totalAmount = 0.0;
      for (var performa in selectedPerforma) {
        var amount = performa['amount'];
        if (amount != null) {
          totalAmount += double.tryParse(amount.toString()) ?? 0.0;
        }
      }
      totalAmountString = totalAmount.toStringAsFixed(2);
    });
  } else {
    
    setState(() {
      performaList.clear(); 
      Fluttertoast.showToast(msg: 'Jobcard not found');
    });
  }
}



  @override
  void initState() {
    super.initState();
    getData_jobcard();
    get_Performa();
  }
  
  @override
  void dispose() {
    performaList=[];
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors().scafoldcolor,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Appcolors().maincolor,
      leading: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios_new_sharp,color: Colors.white,size: 15,)),
      ),
        title: Center(child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text("JOBCARD BILL",style: appbarFonts(18, Colors.white),),
        )),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: IconButton(onPressed: (){},  icon: FaIcon(FontAwesomeIcons.user,color: Colors.white,size: 17,)),
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
                        Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                  
                  Text("Jobcard No",style: formFonts(16, Colors.black),),
                  Text("*",style: TextStyle(fontSize: 16,color: Color(0xFFE22E37)),)
                ],),
                IntrinsicHeight(
  child: Container(
    constraints: BoxConstraints(
      minHeight: 45,
      maxWidth: 171, 
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: Colors.white,
      border: Border.all(color: Appcolors().searchTextcolor),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: 5),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: EasyAutocomplete(
              controller: _jobcardnoController,
              suggestionTextStyle: filedFonts(),
              suggestions: JobcardbillList
                  .map((jobcard) => jobcard['jobcardno'].toString())
                  .toList(),
              onSubmitted: (value) {
                onJobcardSelected(value);
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true, // Make the input compact
                contentPadding: EdgeInsets.symmetric(vertical: 8), // Adjust spacing
              ),
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
            
                         Container(
           
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                  
                  Text("Date",style: formFonts(16, Colors.black),),
                  Text("*",style: TextStyle(fontSize: 16,color: Color(0xFFE22E37)),)
                ],),
                SizedBox(height: 10,),
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
                       SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                        
                         _newjobtxtShortfield("Register No", _registernoController),
                         Container(
           
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                  
                  Text("Jobcard Date",style: formFonts(16, Colors.black),),
                  Text("*",style: TextStyle(fontSize: 16,color: Color(0xFFE22E37)),)
                ],),
                SizedBox(height: 10,),
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
            style: filedFonts(),
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
                       SizedBox(height: 20,),
                       Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _newjobtxtShortfield("Model", _modalController),
                         _newjobtxtShortfield("Make", _makeController)

                        ],
                       ),
                       SizedBox(height: 20,),
                       Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _newjobtxtShortfield("Mechanic", _machanicController),
                         _newjobtxtShortfield("KM Covered", _kvmcoverController)

                        ],
                       ),
                       SizedBox(height: 20,),
                       Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _newjobtxtShortfield("JC start", _jc_finishController),
                         _newjobtxtShortfield("JC finish", _jc_finishController)

                        ],
                       ),
                       SizedBox(height: 20,),
                       Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _newjobtxtShortfield("Enigine No", _engineNoController),
                         _newjobtxtShortfield("Chassis No", _chassisNoController)

                        ],
                       ),
                       SizedBox(height: 20,),
               Padding(
                 padding: const EdgeInsets.only(right: 247),
                 child: Text("Customer Details", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 14,decoration: TextDecoration.underline, )),
               ),
           SizedBox(height: 16,),
               Padding(
                 padding: const EdgeInsets.only(left: 25),
                 child: _Nnewjobtxtfield("Name", _nameNoController),
               ),
               SizedBox(height: 20,),
               Padding(
                 padding: const EdgeInsets.only(left: 25),
                 child: Container(
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                  Row(children: [
                    Text("Address",style: formFonts(16, Colors.black),),
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
                          controller: _adressNoController,
                          style: filedFonts(),
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
               SizedBox(height: 20,),
               Padding(
                 padding: const EdgeInsets.only(left: 25),
                 child: _Nnewjobtxtfield("Mobile", _phonenoNoController),
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
                                                   padding: const EdgeInsets.only(right: 103),
                                                   child: Text("Demand/Request", style: TextStyle(color: Color(0xFF838383), fontWeight: FontWeight.bold,fontSize: 12,decoration: TextDecoration.underline, )),
                                                 ),
                                              
                                               ],
                                             ),
                             ),
                 ),

                  Container(
                height: 200,
              child: ListView.builder(
                  itemCount: _cusvoiceController.text.isNotEmpty
        ? _cusvoiceController.text.split(',').length
        : 0,
                itemBuilder: (context, index) {
                  final List<String> customerRequests = _cusvoiceController.text.split(',');
      final sn = index + 1;
      final request = customerRequests[index].trim();
                  return Padding(
                    padding: const EdgeInsets.only(right: 25),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(5),topRight: Radius.circular(5)),
                        border: Border(
                          
                          bottom: BorderSide(
                            color: Colors.grey.shade400,
                            width: 1,
                          ),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                         
                          Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Text("$sn"),
                          ),
                           
                          Expanded(child: Center(child: Padding(
                            padding: const EdgeInsets.only(left: 70),
                            child: Text(request),
                          ))),
                         
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
                 
             SizedBox(height: 10,),
             
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
                                                   padding: const EdgeInsets.only(left: 9),
                                                   child: Text("SL No", style: TextStyle(color: Color(0xFF838383), fontWeight: FontWeight.bold,fontSize: 12,decoration: TextDecoration.underline, )),
                                                 )),
                                                 Padding(
                                                   padding: const EdgeInsets.only(right: 83),
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
     Container(padding: EdgeInsets.symmetric(horizontal: 23),
  height: 200,
  // decoration: BoxDecoration(
  //   color: Colors.white,
  //         boxShadow: [
  //                            BoxShadow(
  //                 color: Appcolors().searchTextcolor,
  //                 blurRadius: 2.0,
  //                 spreadRadius: 0.0,
  //                 offset: Offset(0.2, 0.0,), // shadow direction: bottom right
  //                            )
  //                        ],
  // ),
  child: ListView.builder(
    itemCount: performaList.length, // Use the length of the populated list
    itemBuilder: (context, index) {
      final sn = index + 1;
      final labourschedule = performaList[index]['labourschedule'];
      final amount = performaList[index]['amount'].toString();

      return Container(
        decoration: BoxDecoration(
          
          borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade400,
              width: 1,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 22),
              child: Text("$sn"),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 70),
                  child: Text(labourschedule ?? ''),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 70),
                  child: Text(amount ?? ''),
                ),
              ),
            ),
          ],
        ),
      );
    },
  ),
),


               SizedBox(height: 20,),
               Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20),
  child: Container(
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    height: 150,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Appcolors().searchTextcolor,
          blurRadius: 2.0,
          spreadRadius: 0.0,
          offset: Offset(0.0, 0.0), // shadow direction: bottom right
        )
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Section: Payment Details
        Text(
          "Payment Details",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 14,
            decoration: TextDecoration.underline,
          ),
        ),
        SizedBox(height: 10),

        // Total Material Row
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(flex: 1,
              child: Text("Total Material", style: getFonts(12, Colors.black))),
           
            Expanded(flex: 1,
              child: Text("                    :", style: getFonts(12, Colors.black))),
            
            Expanded(flex: 1,
              child: Text("5000", style: getFonts(12, Colors.black))),
          ],
        ),
        SizedBox(height: 10),

        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(flex: 1,
              child: Text("Total Labour", style: getFonts(12, Colors.black))),
          
            Expanded(flex: 1,
              child: Text("                    :", style: getFonts(12, Colors.black))),
            
            Expanded(flex: 1,
              child: Text("${totalAmountString ?? '0.00'}", style: getFonts(12, Colors.black))),
          ],
        ),
               Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(flex: 1,
              child: Text("Discount", style: getFonts(12, Colors.black))),
            
            Expanded(flex: 1,
              child: Text("                    :", style: getFonts(12, Colors.black))),
           
            Expanded(
              flex: 1,
              child: TextField(
                controller: _discountControler,
                style: getFonts(12, Colors.black),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  isDense: false,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  ),
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
                      
                      Text(":",style: getFonts(12, Colors.white),),
                      Text("${(double.tryParse(totalAmountString) ?? 0.0) - (double.tryParse(_discountControler.text) ?? 0.0)}",style: getFonts(12, Colors.white),),
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
                  
                  Text(textrow,style: formFonts(16, Colors.black),),
                  Text("*",style: TextStyle(fontSize: 16,color: Color(0xFFE22E37)),)
                ],),
                SizedBox(height: 10,),
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
                  
                  Text(textrow,style: formFonts(16, Colors.black),),
                  Text("*",style: TextStyle(fontSize: 16,color: Color(0xFFE22E37)),)
                ],),
                SizedBox(height: 10,),
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
                        style: filedFonts(),
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
                  Text(textrow,style: formFonts(16, Colors.black),),
                  Text("*",style: TextStyle(fontSize: 16,color: Color(0xFFE22E37)),)
                ],),
                SizedBox(height: 10,),
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
                        style: filedFonts(),
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