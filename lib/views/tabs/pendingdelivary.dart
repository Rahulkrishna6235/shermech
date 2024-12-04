import 'dart:convert';

import 'package:easy_autocomplete/easy_autocomplete.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sher_mech/ApiRepository/jobcardlist.dart';
import 'package:sher_mech/ApiRepository/pendingdelivaryrepo.dart';
import 'package:sher_mech/utility/colorss.dart';
import 'package:sher_mech/utility/databasedatails.dart';
import 'package:sher_mech/utility/font.dart';
import 'package:sher_mech/views/vehiclemake.dart';

class PEndingDelivary extends StatefulWidget {
  const PEndingDelivary({super.key});

  @override
  State<PEndingDelivary> createState() => _PEndingDelivaryState();
}

class _PEndingDelivaryState extends State<PEndingDelivary> {

   final TextEditingController _cardnumberController=TextEditingController();
  final TextEditingController _nameController=TextEditingController();
  final TextEditingController _registrationtroller=TextEditingController();
  final TextEditingController _modelController=TextEditingController();
  final TextEditingController _statusController=TextEditingController();
  final _formkey= GlobalKey<FormState>();
 List pending=[];
 List pendingjcardList=[];
  bool isLoading=false;
  late Future<List<dynamic>> jobcards;
  List<String> jobcardNumbers = [];
  List<dynamic> jobcardNos = []; 
  final ApiPendingdelivaryrepo _apiJobcardRepository = ApiPendingdelivaryrepo();

Future<void> submitJobCard() async {
    if (_formkey.currentState?.validate() ?? false) {
      Map<String, dynamic> jobCardData = {
        'cardno': _cardnumberController.text,
        'customerName': _nameController.text,
        'model': _registrationtroller.text,
        'regno': _modelController.text,
        'status': _statusController.text,
        
      };

      try {
        bool success = await _apiJobcardRepository.post_pendingdelivary(jobCardData);

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Job card added successfully')));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add job card')));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> fetchJobcards() async {
  try {
    final fetchedJobcards = await ApiJobcardRepository().getjobcard();
    setState(() {
      jobcardNos = fetchedJobcards;  
      jobcardNumbers = fetchedJobcards
          .map<String>((jobcard) => jobcard['jobcardno'].toString()) // Extract jobcardno
          .toList();  
    });
  } catch (e) {
    setState(() {
      Fluttertoast.showToast(msg: 'Failed to fetch jobcards: $e');
    });
  }
}

  
   void onJobcardSelected(String jobcardNo) {
  final selectedJobcard = jobcardNos.firstWhere(
    (jobcard) => jobcard['jobcardno'] == jobcardNo,
    orElse: () => <String, dynamic>{},
  );

  if (selectedJobcard.isNotEmpty) {
    setState(() {
      _cardnumberController.text = selectedJobcard['jobcardno'] ?? '';
      _nameController.text = selectedJobcard['customername'] ?? '';
      _registrationtroller.text = selectedJobcard['registerno'] ?? '';
      _modelController.text = selectedJobcard['model'] ?? '';
    });
  } else {
    setState(() {
      Fluttertoast.showToast(msg: 'Jobcard not found');
    });
  }
}


@override
  void initState() {
    super.initState();
    jobcards=ApiPendingdelivaryrepo().get_pendingdelivary();
    //jobcards=ApiJobcardRepository().getjobcard();
    fetchJobcards();
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
          child: Text("PENDING DELIVARY",style: appbarFonts(18, Colors.white),),
        )),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: IconButton(onPressed: (){},  icon: FaIcon(FontAwesomeIcons.user,color: Colors.white,size: 17,)),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: jobcards, 
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (snapshot.hasData) {
                  pendingjcardList = snapshot.data!;

                  return  ListView.separated(
             separatorBuilder: (context, index) => SizedBox(height: 20),
              itemCount: pendingjcardList.length,
              itemBuilder: (BuildContext content,int index){
                
            int sn = index + 1; 
              return Padding(
                padding: const EdgeInsets.only(left: 26,right: 26),
                child: Container(
                  width: 358,height: 260,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                    ),
                                      color: Color(0xFFFFFFFF),

                  ),
                  child: Column(children: [
                     Container(
                      width: 358,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                         topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                          ),
                          color: Color(0xFF0008B4),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text("SN :  $sn",style:getFonts(16, Colors.white),),
                          ),
                        ],
                      ),
                     ),
                     SizedBox(height: 5,),
                     Padding(
                       padding: const EdgeInsets.only(left: 15),
                       child: Row(
                        children: [
                          _listcontents("JOBCARD NO"),
                        Expanded(flex: 3, child: Text(" :   ${pendingjcardList[index]['cardno']}  ",style: filedFonts())),
                        ],
                       ),
                     ),
                                          SizedBox(height: 5,),
                     Padding(
                       padding: const EdgeInsets.only(left: 15),
                       child: Row(
                        children: [
                          _listcontents("CUSTOMER NAME"),
                        Expanded(flex: 3, child: Text(" :   ${pendingjcardList[index]['customername']} ",style: filedFonts())),
                        ],
                       ),
                     ),
                                          SizedBox(height: 5,),
                     Padding(
                       padding: const EdgeInsets.only(left: 15),
                       child: Row(
                        children: [
                          _listcontents("MODEL"),
                        Expanded(flex: 3, child: Text(" :   ${pendingjcardList[index]['model']} ",style: filedFonts())),
                        ],
                       ),
                     ),
                                          SizedBox(height: 5,),
                     Padding(
                       padding: const EdgeInsets.only(left: 15),
                       child: Row(
                        children: [
                          _listcontents("REGISTRATION NO"),
                        Expanded(flex: 3, child: Text(" :   ${pendingjcardList[index]['regno']}",style: filedFonts())),
                        ],
                       ),
                     ),
                                          SizedBox(height: 5,),
                     Padding(
                       padding: const EdgeInsets.only(left: 15),
                       child: Row(
                        children: [
                          _listcontents("STATUS"),
                        Expanded(flex: 3, child: Text(" :   ${pendingjcardList[index]['status']}",style: filedFonts())),
                        ],
                       ),
                     ),
                                          SizedBox(height: 5,),
            
                  ],),
                ),
              );
            });
                } else {
                  return Center(child: Text("No data available"));
                }
              },
            ),
          ),
      ),
      floatingActionButton: GestureDetector(
        onTap: (){
          addPopup();
        },
        child: Container(
          width: 50,height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Appcolors().maincolor,
          ),
          child: Center(child: Icon(Icons.add,color: Colors.white,size: 30,)),
        ),
      ),
    );
  }

  addPopup() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Appcolors().Scfold,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text( "Enter Details"),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close),
                ),
              ],
            ),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("JobcardNo",style: formFonts(14, Colors.black),),
          SizedBox(height: 3,),
                      Container(
                      width: 200,
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
                                    child: Container(width: 200,
                                      child: EasyAutocomplete(
                      controller: _cardnumberController,
                      suggestionTextStyle: filedFonts(),
                      suggestions: jobcardNos
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
                          ),
                        ],
                      ),
                                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  
                  _field(_nameController,"Name"),
                  SizedBox(height: 10),
                  _field(_modelController,"Model"),
                  SizedBox(height: 10,),
                  _field(_registrationtroller,"RegistrationNo"),
                  SizedBox(height: 10,),
                  _field(_statusController,"Status"),
                  SizedBox(height: 10,),
              
                  GestureDetector(
                    onTap: () async {
                submitJobCard();
                Navigator.pop(context);
                    },
                    child: Center(
                      child: Container(
                        width: 155,
                        height: 43,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xFF0008B4),
                        ),
                        child: Center(
                          child: Text("Save", style: getFonts(14, Colors.white)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _field (TextEditingController controller,String text){
    return Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$text",style: formFonts(14, Colors.black),),
          SizedBox(height: 3,),
        Container(
          width: 200,
          child: TextFormField(
                          controller: controller,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a vehicle model name';
                            }
                            return null;
                          },  
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: Appcolors().scafoldcolor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(color: Appcolors().maincolor),
                            ),
                            
                            hintStyle: TextStyle(color: Color(0xFF948C93)),
                          ),
                          autofocus: true,
                        ),
        ),
      ],
    );
  }
    Widget _listcontents(String listtext) {
    return Expanded(
        flex: 3,
        child: Padding(
          padding: const EdgeInsets.only(left: 9,top: 5),
          child: Text(
            listtext,
             style: getFonts(14, Colors.black),
          ),
        ));
  }
}