import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:sher_mech/ApiRepository/jobcardlist.dart';
import 'package:sher_mech/utility/colorss.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sher_mech/utility/databasedatails.dart';
import 'package:sher_mech/utility/drawer.dart';
import 'package:sher_mech/utility/font.dart';
import 'package:sher_mech/views/Home/jobcards.dart';
import 'package:sher_mech/views/pdf_%20and%20_invoice/invoice.dart';
import 'package:sher_mech/views/vehiclemake.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
class Newjobcard extends StatefulWidget {
  final int? jobCardId; // Add this to pass job card ID
  const Newjobcard({Key? key, this.jobCardId}) : super(key: key);

  @override
  State<Newjobcard> createState() => _NewjobcardState();
}

class _NewjobcardState extends State<Newjobcard> {

  bool isLoading = false;
  List<Map<String, dynamic>> jobcardList = [];
    final TextEditingController _jobcardnoController = TextEditingController();

  final TextEditingController _customernameController = TextEditingController();
    final TextEditingController _locationController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _makeController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _registernoController = TextEditingController();
  final TextEditingController _adressnoController = TextEditingController();
  
    final TextEditingController _technicionController = TextEditingController();
      final TextEditingController _ariveDateController = TextEditingController();
  final TextEditingController _deliverDateController = TextEditingController();
  final TextEditingController _customervoiceController = TextEditingController();
  final TextEditingController _technicianvoiceController = TextEditingController();
  final TextEditingController _chassisnoController = TextEditingController();
 final TextEditingController _kilometerController = TextEditingController();
  final TextEditingController _jobadvisorController = TextEditingController();


  final _formKey = GlobalKey<FormState>();
  int? _selectedSiNo; 
bool isEditing = false;
  @override
  void initState() {
    super.initState();
   
  }
final ApiJobcardRepository _apiJobcardRepository = ApiJobcardRepository();

Future<void> submitJobCard() async {
    if (_formKey.currentState?.validate() ?? false) {
      Map<String, dynamic> jobCardData = {
        'jobcardno': _jobcardnoController.text,
        'arivedate': _ariveDateController.text,
        'customername': _customernameController.text,
        'location': _locationController.text,
        'mobilenumber': _mobileController.text,
        'make': _makeController.text,
        'model': _modelController.text,
        'registerno': _registernoController.text,
        'chassisno': _chassisnoController.text,
        'kilometer': _kilometerController.text,
        'selectjobadvisor': _jobadvisorController.text,
        'technicianvoke': _technicianvoiceController.text,
        'deliverdate': _deliverDateController.text,
        'adress': _adressnoController.text,
        'technicians': _technicionController.text,
        'customervoice': _customervoiceController.text,

      };

      try {
        bool success = await _apiJobcardRepository.postNewJobCard(jobCardData);

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

  Future<File> generateInvoice(List<Map<String, dynamic>> jobcardList) async {
  final pdf = pw.Document();
    if (jobcardList.isEmpty) {
    return Future.error("No job card data available to generate the invoice.");
  }
    Map<String, dynamic> lastJobCard = jobcardList.last;

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text("JobCard Invoice", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            pw.Text("Customer Information", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 5),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("Customer Name: ", style: pw.TextStyle(fontSize: 16)),
                pw.Text(lastJobCard['customername'] ?? 'N/A', style: pw.TextStyle(fontSize: 16)),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("Location: ", style: pw.TextStyle(fontSize: 16)),
                pw.Text(lastJobCard['location'] ?? 'N/A', style: pw.TextStyle(fontSize: 16)),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("Mobile: ", style: pw.TextStyle(fontSize: 16)),
                pw.Text(lastJobCard['mobilenumber'] ?? 'N/A', style: pw.TextStyle(fontSize: 16)),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("Adress: ", style: pw.TextStyle(fontSize: 16)),
                pw.Text(lastJobCard['adress'] ?? 'N/A', style: pw.TextStyle(fontSize: 16)),
              ],
            ),
            pw.SizedBox(height: 15),
            pw.Text("Vehicle Information", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 5),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("Job Card No: ", style: pw.TextStyle(fontSize: 16)),
                pw.Text(lastJobCard['jobcardno'] ?? 'N/A', style: pw.TextStyle(fontSize: 16)),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("Model: ", style: pw.TextStyle(fontSize: 16)),
                pw.Text(lastJobCard['model'] ?? 'N/A', style: pw.TextStyle(fontSize: 16)),
              ],
            ),pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("Make: ", style: pw.TextStyle(fontSize: 16)),
                pw.Text(lastJobCard['make'] ?? 'N/A', style: pw.TextStyle(fontSize: 16)),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("Register No: ", style: pw.TextStyle(fontSize: 16)),
                pw.Text(lastJobCard['registerno'] ?? 'N/A', style: pw.TextStyle(fontSize: 16)),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("Chassis No: ", style: pw.TextStyle(fontSize: 16)),
                pw.Text(lastJobCard['chassisno'] ?? 'N/A', style: pw.TextStyle(fontSize: 16)),
              ],
            ),
            pw.SizedBox(height: 15),
            pw.Text("Technician Information", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 5),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("Technician: ", style: pw.TextStyle(fontSize: 16)),
                pw.Text(lastJobCard['Technicians'] ?? 'N/A', style: pw.TextStyle(fontSize: 16)),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("Job Advisor: ", style: pw.TextStyle(fontSize: 16)),
                pw.Text(lastJobCard['selectjobadvisor'] ?? 'N/A', style: pw.TextStyle(fontSize: 16)),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("Technician Voice: ", style: pw.TextStyle(fontSize: 16)),
                pw.Text(lastJobCard['technicianvoke'] ?? 'N/A', style: pw.TextStyle(fontSize: 16)),
              ],
            ),
            pw.SizedBox(height: 15),
            pw.Text("Dates", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 5),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("Arrival Date: ", style: pw.TextStyle(fontSize: 16)),
                pw.Text(lastJobCard['arivedate'] ?? 'N/A', style: pw.TextStyle(fontSize: 16)),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("Delivery Date: ", style: pw.TextStyle(fontSize: 16)),
                pw.Text(lastJobCard['deliverdate'] ?? 'N/A', style: pw.TextStyle(fontSize: 16)),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Text("Invoice Details", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 5),
            
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("Date: ", style: pw.TextStyle(fontSize: 16)),
                pw.Text("${DateTime.now().toLocal().toString().split(' ')[0]}", style: pw.TextStyle(fontSize: 16)), // Current Date
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("Due Date: ", style: pw.TextStyle(fontSize: 16)),
                pw.Text("${DateTime.now().toLocal().add(Duration(days: 7)).toString().split(' ')[0]}", style: pw.TextStyle(fontSize: 16)), // 7 Days from the current date
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Text("Thank you ", style: pw.TextStyle(fontSize: 16)),
          ],
        );
      },
    ),
  );
  final outputDirectory = await getApplicationDocumentsDirectory();
  final file = File("${outputDirectory.path}/jobcard_invoice.pdf");
  await file.writeAsBytes(await pdf.save());
  return file;
}

Future<void> _generateinvoice() async {
  // Check if jobcardList is empty
  if (jobcardList.isEmpty) {
    Fluttertoast.showToast(msg: 'No data available to generate PDF');
    return;
  }

  // If everything is valid, proceed to generate the invoice
  try {
    File pdfFile = await generateInvoice(jobcardList);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InvoiceScreen(path: pdfFile.path),
      ),
    );
  } catch (e) {
    Fluttertoast.showToast(msg: e.toString());
  }
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
          child: Text("NEW JOB CARD",style: appbarFonts(18, Colors.white),),
        )),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: IconButton(onPressed: (){},  icon: FaIcon(FontAwesomeIcons.user,color: Colors.white,size: 16,)),
          )
        ],
      ),
      
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
                        hintStyle: searchFonts(13, Appcolors().searchTextcolor),
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
                  SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.only(left: 27),
              child: Container(
                child: Form(
                  key: _formKey,
                  child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Row(
                          
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: _newjobtxtShortfield("Jobcard No",_jobcardnoController),
                            ),
                            
                            SizedBox(width: 4,),
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
                                             Padding(
                                               padding: const EdgeInsets.only(right: 5),
                                               child: Container(
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
                                                                                           hintStyle: TextStyle(color: Color(0xFF948C93),fontSize: 12),
                                                                                           hintText: "Select Date",
                                                                                         ),
                                                                                         autofocus: true,
                                                                                       ),
                                                                                     ),
                                             ),
                                            ],
                                          ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20,),
                    _newjobtxtfield("Customer Name",_customernameController),
                    SizedBox(height: 10,),
                                _newjobtxtfield("Location",_locationController),
                                SizedBox(height: 20,),
                               Container(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Text("Mobile Number", style: formFonts(16, Colors.black)),
          Text("*", style: TextStyle(fontSize: 16, color: Color(0xFFE22E37))),
        ],
        
      ),
      SizedBox(height: 10,),
      Container(
        height: 45,
        width: 358,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
          border: Border.all(color: Appcolors().searchTextcolor),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              SizedBox(width: 5),
              Expanded(
                child: TextFormField(
                  controller: _mobileController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a mobile number';
                    }
                    if (value.length != 10) {
                      return 'Mobile number must be 10 digits';
                    }
                    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return 'Mobile number must contain only digits';
                    }
                    return null;
                  },
                  obscureText: false,
                  keyboardType: TextInputType.phone,
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
)
,
                     
                           SizedBox(height: 20,),
                            _newjobtxtfield("Address",_adressnoController),
                           
                           SizedBox(height: 20,),
                  ],),
                ),
              ),
            ),
        
                      
                                            SizedBox(height: 19,),
                    Container(
                      child: Column(
                        children: [
                            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                        _newjobtxtShortfield("Make",_makeController),
                        _newjobtxtShortfield("Model",_modelController)
                       ],) ,
                                            SizedBox(height: 20,),
                                         Row(
                                                                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                   children: [
                                                                 _newjobtxtShortfield("Register No",_registernoController),
                                                                 _newjobtxtShortfield("Chassis No",_chassisnoController)
                                                                ],) ,
                                            SizedBox(height: 20,),
        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                        _newjobtxtShortfield("Kilometer",_kilometerController),
                        _newjobtxtShortfield("Select Job Advisor",_jobadvisorController)
                       ],) ,
                       SizedBox(height: 20,),
                        Padding(
                          padding: const EdgeInsets.only(right: 3),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                          
                          _newjobtxtShortfield("Select Technicion",_technicionController),
                           Container(
                                     
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                            
                                            Text("Expected Date",style: formFonts(16, Colors.black),),
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
                                        hintStyle: TextStyle(color: Appcolors().searchTextcolor,fontSize: 12),
                                        hintText: "Select Date",
                                      ),
                                      autofocus: true,
                                    ),
                                  ),
                                        ],
                                      ),
                                    )
                                                 ],),
                        )
                        ],
                      ),
                    ) ,              
          SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(left: 26),
              child: _Nnewjobtxtfield("Customer Voice", _customervoiceController),
            ),
        
            SizedBox(height: 20,),
             Padding(
               padding: const EdgeInsets.only(left: 26),
               child: _Nnewjobtxtfield("Technicion Voice", _technicianvoiceController),
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
                   // int siNo=_selectedSiNo?? 0;
                   bool success=true;
                    if (isEditing) {
                     // success = await updateVehicle(_selectedSiNo!, _vehiclenameController.text);
        //             success =await update_jobcard(
        //                _ariveDateController.text, 
        // _jobcardnoController.text,  
        // _customernameController.text, 
        // _modelController.text, 
        // _registernoController.text, 
        // //siNo ,
        // widget.jobCardId!,
        //               );
                    } else {
                      submitJobCard();
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
                    child: Center(child: Text(isEditing ? "Update JobCard" : "Create JobCard",style: getFonts(12, Colors.white)),
                   ) ),
                ),
                //_Botton("Create JobCard"),
                GestureDetector(
                  onTap: (){
                    _generateinvoice();
                  },
                  child: Container(
                    height: 44,width: 171,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                       color: Color(0xFF0A1EBE), 
                    ),
                    child: Center(child: Text("Create Direct Invoice",style: getFonts(12, Colors.white)),
                   ) ),
                ),
               // _Botton("Create Direct Invoice")
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
                        height: 180,
                        width: 358,
                        decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white, 
                border: Border.all(color: Appcolors().searchTextcolor)
                        ),
                        child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0), 
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                         maxLines: null,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(bottom: 12), 
                        ),
                        textAlign: TextAlign.start, 
            
             keyboardType: TextInputType.multiline, // Enable multiline input
            textInputAction: TextInputAction.newline,
             
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
// Future<void> createInvoice(BuildContext context) async {
//   final pdf = pw.Document();
//   pdf.addPage(
//     pw.Page(
//       build: (pw.Context context) {
//         return pw.Center(
//           child: pw.Column(
//             children: [
//               pw.Text("Invoice", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
//               pw.SizedBox(height: 10),
//               pw.Text("Customer Name: ${_customernameController.text}", style: pw.TextStyle(fontSize: 16)),
//               pw.Text("Job Card No: ${_jobcardnoController.text}", style: pw.TextStyle(fontSize: 16)),
//               pw.Text("Model: ${_modelController.text}", style: pw.TextStyle(fontSize: 16)),
//               pw.Text("Register No: ${_registernoController.text}", style: pw.TextStyle(fontSize: 16)),
//               pw.SizedBox(height: 20),
//               pw.Text("Thank you for your business!", style: pw.TextStyle(fontSize: 16)),
//             ],
//           ),
//         );
//       },
//     ),
//   );

//   // Save the PDF to a file
//   final outputFile = await getExternalStorageDirectory();
//   final file = File('${outputFile!.path}/invoice.pdf');
//   await file.writeAsBytes(await pdf.save());

//   // Show the file (open PDF)
//   Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
// }

// Future<void> saveInvoice() async {
//   final outputFile = await getExternalStorageDirectory();
//   final file = File('${outputFile!.path}/invoice.pdf');

//   // Generate PDF as shown earlier
//   final pdf = await generateInvoice(); // Your PDF generation logic here
//   await file.writeAsBytes(await pdf.save());

//   // Notify the user that the file is saved
//   Fluttertoast.showToast(msg: 'Invoice saved to ${file.path}');
// }
//   getExternalStorageDirectory() {}
  
}