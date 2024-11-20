import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:sher_mech/utility/colorss.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sher_mech/utility/databasedatails.dart';
import 'package:sher_mech/utility/drawer.dart';
import 'package:sher_mech/utility/font.dart';
import 'package:sher_mech/views/Home/jobcards.dart';
import 'package:sher_mech/views/vehiclemake.dart';

class Newjobcard extends StatefulWidget {
  const Newjobcard({super.key});

  @override
  State<Newjobcard> createState() => _NewjobcardState();
}

class _NewjobcardState extends State<Newjobcard> {

  bool isLoading = false;
  List<Map<String, dynamic>> jobcardList = [];
  final TextEditingController _customernameController = TextEditingController();
    final TextEditingController _locationController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _makeController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _registernoController = TextEditingController();
  final TextEditingController _chassisnoController = TextEditingController();
  final TextEditingController _kilometerController = TextEditingController();
  final TextEditingController _jobadvisorController = TextEditingController();
    final TextEditingController _technicionvoiceController = TextEditingController();
      final TextEditingController _ariveDateController = TextEditingController();
  final TextEditingController _deliverDateController = TextEditingController();



  final _formKey = GlobalKey<FormState>();
  int? _selectedSiNo; 

 Future<bool> post_newjobcard() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      String Customername = _customernameController.text.replaceAll("'", "''");
      String Location = _locationController.text.replaceAll("'", "''");
            String Mobile = _mobileController.text.replaceAll("'", "''");
      String Make = _makeController.text.replaceAll("'", "''");
      String Model = _modelController.text.replaceAll("'", "''");
      String Register = _registernoController.text.replaceAll("'", "''");
      String Chassisno = _chassisnoController.text.replaceAll("'", "''");
      String Kilometer = _kilometerController.text.replaceAll("'", "''");
      String Jobadvisor = _jobadvisorController.text.replaceAll("'", "''");
      String Techvoice = _technicionvoiceController.text.replaceAll("'", "''");
      String Date_arive = _ariveDateController.text.replaceAll("'", "''");
      String Date_deliver = _deliverDateController.text.replaceAll("'", "''");


      int nextID = 1;

      try {
        bool isConnected = await connect();
        if (!isConnected) {
          Fluttertoast.showToast(msg: 'Database connection failed');
          setState(() {
            isLoading = false;
          });
          return false;
        }

        // String queryMaxSiNo = 'SELECT MAX(ID) as MaxID FROM Newjobcard';
        // String maxSiNoResult = await sqlConnection.getData(queryMaxSiNo);

        // if (maxSiNoResult.isNotEmpty) {
        //   List<dynamic> resultList = json.decode(maxSiNoResult);
        //   if (resultList.isNotEmpty && resultList[0]['MaxID'] != null) {
        //     nextID = resultList[0]['MaxID'] + 1;
        //   }
        // }

        String query = "INSERT INTO Newjobcard (customername, location,mobilenumber,make,model,registerno,chassisno,kilometer,selectjobadvisor,technicianvoke,arivedate,deliverdate) VALUES ('$Customername', '$Location', '$Mobile','$Make','$Model','$Register','$Chassisno','$Kilometer','$Jobadvisor','$Techvoice','$Date_arive','$Date_deliver')";
        String result = await sqlConnection.writeData(query);
        Map<String, dynamic> valueMap = json.decode(result);

        if (valueMap['affectedRows'] == 1) {
          _customernameController.clear();
          _locationController.clear();
                    _makeController.clear();
          _mobileController.clear();
          _modelController.clear();
          _registernoController.clear();
          _chassisnoController.clear();
          _kilometerController.clear();
          _jobadvisorController.clear();
          _technicionvoiceController.clear();
          _ariveDateController.clear();
          _ariveDateController.clear();

          await getData_jobcard();
          Fluttertoast.showToast(msg: "Added Successfully");
          return true;
        } else {
          Fluttertoast.showToast(msg: "Failed to Add");
        }
      } catch (e) {
        Fluttertoast.showToast(msg: "Error: $e");
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
    return false;
  }

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
            jobcardList = List<Map<String, dynamic>>.from(data);
          });
         // int siNo=1;
          // for(var vehiclemake in vehicleList){
          //     vehiclemake['SiNo']=siNo++;
          // }
        } else {
          Fluttertoast.showToast(msg: 'No data found');
          setState(() {
            jobcardList = [];
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
          child: Text("NEW JOB CARD",style: appbarFonts(18, Colors.white),),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Container(
                      height: 39,
                      width: 358,
                      decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white, 
              border: Border.all(color: Appcolors().searchTextcolor)
                      ),
                      child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0), 
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Icon(Icons.search, color: Colors.grey,size: 17,),
                  ),
                  SizedBox(width: 5), 
                  Expanded( 
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search",
                        hintStyle: getFonts(13, Appcolors().searchTextcolor),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(bottom: 12), 
                      ),
                    ),
                  ),
                ],
              ),
                      ),
                    ),
          ),
                  SizedBox(height: 16,),
            Padding(
              padding: const EdgeInsets.only(left: 27),
              child: Container(
                child: Form(
                  key: _formKey,
                  child: Column(
                   
                    children: [
                    _newjobtxtfield("Customer Name",_customernameController),
                    SizedBox(height: 19,),
                                _newjobtxtfield("Location",_locationController),
                                SizedBox(height: 13,),
                           _newjobtxtfield("Mobile Number",_mobileController),
                           SizedBox(height: 19,),
                  ],),
                ),
              ),
            ),
        
                       SizedBox(height: 19,),
                       Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                        Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                  
                  Text("Arrived Date",style: getFonts(16, Colors.black),),
                  Text("*",style: TextStyle(fontSize: 16,color: Color(0xFFE22E37)),)
                ],),
               Container(
          height: 45,
                        width: 171,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
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
                
                _ariveDateController.text = formattedDate;
              }
            },
            controller: _ariveDateController,
            readOnly: true, 
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.blue),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.blue),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.blue),
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
          Container(
           
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                  
                  Text("Deliver Date",style: getFonts(16, Colors.black),),
                  Text("*",style: TextStyle(fontSize: 16,color: Color(0xFFE22E37)),)
                ],),
               Container(
          height: 45,
                        width: 171,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
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
                
                _deliverDateController.text = formattedDate;
              }
            },
            controller: _deliverDateController,
            readOnly: true, 
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.blue),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.blue),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.blue),
              ),
              hintStyle: TextStyle(color: Color(0xFF948C93)),
              hintText: "Select Date",
            ),
            autofocus: true,
          ),
        ),
              ],
            ),
          )
                       ],) ,
                                            SizedBox(height: 19,),
                       Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                        _newjobtxtShortfield("Make",_makeController),
                        _newjobtxtShortfield("Model",_modelController)
                       ],) ,
                                            SizedBox(height: 19,),
        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                        _newjobtxtShortfield("Register No",_registernoController),
                        _newjobtxtShortfield("Chassis No",_chassisnoController)
                       ],) ,
                                            SizedBox(height: 19,),
        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                        _newjobtxtShortfield("Kilometer",_kilometerController),
                        _newjobtxtShortfield("select job advisor",_jobadvisorController)
                       ],) ,   
                                            SizedBox(height: 30,),
            
        
            SizedBox(height: 10,),
        
            Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
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
                      child: TextField(
                        obscureText: true,
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
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.only(left: 26),
                child: _newjobtxtfield("Technician Voice",_technicionvoiceController),
              ),
              SizedBox(height: 25,),
        ],),

      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                  onTap: ()async{
                    //post_newjobcard();
                   bool success=true;
                    if (_selectedSiNo != null) {
                     // success = await updateVehicle(_selectedSiNo!, _vehiclenameController.text);
                    } else {
                      success = await post_newjobcard();
                    }
                    if (success) {
                       MaterialPageRoute(builder: (_) => Jobcards());
                    }
                  },
                  child: Container(
                    height: 44,width: 171,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                       color: Color(0xFF0A1EBE), 
                    ),
                    child: Center(child: Text("Create JobCard",style: getFonts(12, Colors.white)),
                   ) ),
                ),
                //_Botton("Create JobCard"),
                _Botton("Create Direct Invoice")
              ],),
      ),
    );
  }

  Widget _newjobtxtfield (String textrow,TextEditingController controller){
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

  
}