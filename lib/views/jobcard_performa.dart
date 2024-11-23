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

class Performa_invoice extends StatefulWidget {
  const Performa_invoice({super.key});

  @override
  State<Performa_invoice> createState() => _Performa_invoiceState();
}

class _Performa_invoiceState extends State<Performa_invoice> {

  final TextEditingController _jobcardnocontroller= TextEditingController();
    final TextEditingController _datecontroller= TextEditingController();
  final TextEditingController _jobcard_datecontroller= TextEditingController();
  final TextEditingController _registercontroller= TextEditingController();




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

   void onJobcardSelected(String jobcardNo) {
    final selectedJobcard =
        JobcardbillList.firstWhere((jobcard) => jobcard['jobcardno'] == jobcardNo);
    setState(() {
      _jobcard_datecontroller.text = selectedJobcard['arivedate'] ?? '';
      _registercontroller.text = selectedJobcard['registerno'] ?? '';
      
    });
  }

  @override
  void initState() {
    super.initState();
    getData_jobcard();
  }

  List names =[
    "Labour Charge","Labour Charge","Labour Charge"
  ];
  List amt =[
    "100","200","600"
  ];

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
          child: Text("PERFORMA INVOICE",style: appbarFonts(18, Colors.white),),
        )),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: IconButton(onPressed: (){},  icon: FaIcon(FontAwesomeIcons.user,color: Colors.white,)),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Column(
          
          children: [
            SizedBox(height: 20,),
            Padding(
                          padding: const EdgeInsets.only(right: 26),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                  
                  Text("Jobcard No",style: getFonts(16, Colors.black),),
                  Text("*",style: TextStyle(fontSize: 16,color: Color(0xFFE22E37)),)
                ],),
              IntrinsicHeight(
  child: Container(
    constraints: BoxConstraints(
      minHeight: 45,
      maxWidth: 171, // Optional: Adjust as needed
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
              controller: _jobcardnocontroller,
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
                                                
                                                _datecontroller.text = formattedDate;
                                              }
                                            },
                                            controller: _datecontroller,
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
                                              hintStyle: TextStyle(color: Color(0xFF948C93)),
                                              hintText: "Select Date",
                                            ),
                                            autofocus: true,
                                          ),
                                        ),
                                              ],
                                            ),
                              ),
                            ],
                          ),
                        ),
                       SizedBox(height: 15,),
                        Padding(
                          padding: const EdgeInsets.only(right: 26),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              
                              Container(
                                child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                  
                                                  Text("JobcardDate",style: getFonts(16, Colors.black),),
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
                                                
                                                _jobcard_datecontroller.text = formattedDate;
                                              }
                                            },
                                            controller: _jobcard_datecontroller,
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
                                              hintStyle: TextStyle(color: Color(0xFF948C93)),
                                              hintText: "Select Date",
                                            ),
                                            autofocus: true,
                                          ),
                                        ),
                                              ],
                                            ),
                              ),
                              _newjobtxtShortfield("Register No",_registercontroller),
                            ],
                          ),
                        ),
        
                         SizedBox(height: 40),
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
                                              SizedBox(width: 10,),
                                               Expanded(child: Padding(
                                                 padding: const EdgeInsets.only(left: 3),
                                                 child: Text("SL No", style: TextStyle(color: Color(0xFF838383), fontWeight: FontWeight.bold,fontSize: 12,decoration: TextDecoration.underline, )),
                                               )),
                                               SizedBox(width: 8,),
                                               Padding(
                                                 padding: const EdgeInsets.only(right: 33),
                                                 child: Expanded(child: Text("Labour schedule", style: TextStyle(color: Color(0xFF838383), fontWeight: FontWeight.bold,fontSize: 12,decoration: TextDecoration.underline, ))),
                                               ),
                                               SizedBox(width: 20,),
                                               Expanded(child: Center(child: Text("Amount", style: TextStyle(color: Color(0xFF838383), fontWeight: FontWeight.bold,fontSize: 12,decoration: TextDecoration.underline, )))),
                                               Expanded(child: Center(child: Text("            ", style: TextStyle(color: Color(0xFF838383), fontWeight: FontWeight.bold,fontSize: 12)))),
                                             ],
                                           ),
                           ),
               ),
                Expanded(
  child: Padding(
    padding: const EdgeInsets.only(right: 20), // Adjust padding to reduce empty space
    child: ListView.builder(
      itemCount: names.length,
      itemBuilder: (context, index) {
        int sn = index + 1;
        return Container(
          width: MediaQuery.of(context).size.width - 40, // Dynamically calculate width
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
            ),
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
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 30), // Adjust padding for alignment
                    child: Text("$sn"),
                  ),
                ),
              ),
              SizedBox(width: 15,),
              Center(
                child: Container(
                  width: 40,
                  child: TextField()),
              ),
              SizedBox(width: 15,),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 50),
                    child: Container(
                      width: 40,
                      child: TextField()),
                  ),
                ),
              ),
              SizedBox(width: 5,),
               Expanded(
                child: Center(
                  child: Icon(Icons.delete,color: Colors.red,size: 15,),
                ),
              ),
            ],
          ),
        );
      },
    ),
  ),
),

          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: GestureDetector(
                    onTap: (){
                      
                    },
                    child: Container(
                      height: 51,width: 358,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                         color: Color(0xFF0A1EBE), 
                      ),
                      child: Center(child: Text("Save",style: getFonts(16, Colors.white)),
                     ) ),
                  ),
      )
    );
  }
   Widget _newjobtxtShortfield (String textrow,TextEditingController controller){
    return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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