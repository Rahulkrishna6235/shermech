
import 'package:easy_autocomplete/easy_autocomplete.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sher_mech/ApiRepository/jobcardPerforma.dart';
import 'package:sher_mech/ApiRepository/jobcardlist.dart';
import 'package:sher_mech/utility/colorss.dart';
import 'package:sher_mech/utility/drawer.dart';
import 'package:sher_mech/utility/font.dart';

class Performa extends StatefulWidget {
  const Performa({super.key});

  @override
  State<Performa> createState() => _Performa_invoiceState();
}

class _Performa_invoiceState extends State<Performa> {

  final TextEditingController _jobcardnocontroller= TextEditingController();
    final TextEditingController _datecontroller= TextEditingController();
  final TextEditingController _jobcard_datecontroller= TextEditingController();
  final TextEditingController _registercontroller= TextEditingController();

final TextEditingController _lobourschedulecontroller= TextEditingController();
final TextEditingController _amountcontroller= TextEditingController();
final _formKey = GlobalKey<FormState>();
final _pformKey = GlobalKey<FormState>();
  List<Map<String,dynamic>> billDetails=[];
  List<String> _vehicleNameSuggestions = [];
  List<String> _modelSuggestions = [];
  List<String> _makeSuggestions = [];
 bool isLoading=false;
 List JobcardbillList = [];
late Future<List<dynamic>> performa;
List<String> jobcardNumbers = [];
  List<dynamic> jobcardNos = []; 
  final ApiJobcardPerforma _apiJobcardPerforma=ApiJobcardPerforma();
  final ApiJobcardPerforma _apiJobcardPerformaperticular=ApiJobcardPerforma();

 @override
  void dispose() {
    _jobcardnocontroller.dispose();
    _lobourschedulecontroller.dispose();
    _amountcontroller.dispose();
    super.dispose();
  }



Future<void> submitPerformaPerticular() async {
  if (_formKey.currentState?.validate() ?? false) {
    String jobcardno = _jobcardnocontroller.text.trim();
    String labourschedule = _lobourschedulecontroller.text.trim();
    String amount = _amountcontroller.text.trim();

    Map<String, dynamic> jobCardData = {
      'jobcardno': jobcardno,
      'labourschedule': labourschedule,
      'amount': amount,
    };

    try {
      bool success = await _apiJobcardPerformaperticular.post_Performaperticular(jobCardData);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Job card added successfully')));

        setState(() {
          billDetails.add({
            'labourschedule': labourschedule,
            'amount': amount,
          });
        });
        _jobcardnocontroller.clear();
        _lobourschedulecontroller.clear();
        _amountcontroller.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add job card')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }
}


  void onJobcardSelected(String jobcardNo) {
  final selectedJobcard = jobcardNos.firstWhere(
 (jobcard) => jobcard['jobcardno'] == jobcardNo,
    orElse: () => <String, dynamic>{},
  );

  if (selectedJobcard.isNotEmpty) {
    setState(() {
      _jobcardnocontroller.text = selectedJobcard['jobcardno'] ?? '';
      _registercontroller.text = selectedJobcard['registerno'] ?? '';
      _jobcard_datecontroller.text = selectedJobcard['arivedate'] ?? '';
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
    performa=ApiJobcardRepository().getjobcard();
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
          child: Text("PERFORMA INVOICE",style: appbarFonts(18, Colors.white),),
        )),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: IconButton(onPressed: (){},  icon: FaIcon(FontAwesomeIcons.user,color: Colors.white,size: 17,)),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Form(
          key: _formKey,
          child: Expanded(
  child: Padding(
    padding: const EdgeInsets.only(right: 23),
    child: Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Appcolors().searchTextcolor,
            blurRadius: 2.0,
            spreadRadius: 0.0,
            offset: Offset(0.0, 0.0),
          )
        ],
      ),
      child: ListView.builder(
        itemCount: billDetails.length + 1,
        itemBuilder: (context, index) {
          if (index == billDetails.length) {
            // Adding a new row to enter data
            return Container(
              height: 50,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade400, width: 1),
                ),
              ),
              child: Row(
                children: [
                  Expanded(child: Center(child: Text("${index + 1}"))),
                  SizedBox(width: 15),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextField(
                        controller: _lobourschedulecontroller,
                        decoration: InputDecoration(
                          hintText: "Labour Schedule",
                          hintStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w300),
                          border: InputBorder.none,
                          isDense: false,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 25),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextField(
                        controller: _amountcontroller,
                        decoration: InputDecoration(
                          hintText: "Amount",
                          hintStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w300),
                          border: InputBorder.none,
                          isDense: false,
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    onPressed: () {
                      // Validate and add data to the list
                      if (_lobourschedulecontroller.text.isNotEmpty &&
                          _amountcontroller.text.isNotEmpty) {
                        final amount = double.tryParse(_amountcontroller.text);
                        if (amount != null) {
                          setState(() {
                            billDetails.add({
                              'labourschedule': _lobourschedulecontroller.text,
                              'amount': _amountcontroller.text,
                            });
                            _lobourschedulecontroller.clear();
                            _amountcontroller.clear();
                          });
                        } else {
                          Fluttertoast.showToast(msg: "Enter a valid amount!");
                        }
                      } else {
                        Fluttertoast.showToast(msg: "Enter all fields!");
                      }
                    },
                    icon: Icon(Icons.add_box_outlined, color: Colors.black, size: 20),
                  ),
                ],
              ),
            );
          } else {
            return Container(
              height: 50,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade400, width: 1),
                ),
              ),
              child: Row(
                children: [
                  Expanded(child: Center(child: Text("${index + 1}"))),
                  SizedBox(width: 15),
                  Expanded(flex: 2, child: Text(billDetails[index]['labourschedule'] ?? '')),
                  SizedBox(width: 15),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(billDetails[index]['amount'] ?? ''),
                    ),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        billDetails.removeAt(index);
                      });
                    },
                    icon: Icon(Icons.delete, color: Colors.red, size: 20),
                  ),
                ],
              ),
            );
          }
        },
      ),
    ),
  ),
), 
        ),
      ),
      bottomNavigationBar: GestureDetector(
                  onTap: (){
                    submitPerformaPerticular();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20),
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

}