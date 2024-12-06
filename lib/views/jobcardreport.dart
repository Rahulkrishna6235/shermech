import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sher_mech/ApiRepository/jobcardlist.dart';
//import 'package:share_plus/share_plus.dart';
import 'package:sher_mech/utility/colorss.dart';
import 'package:intl/intl.dart';
import 'package:sher_mech/utility/drawer.dart';
import 'package:sher_mech/utility/font.dart';
import 'package:sher_mech/views/pdf_%20and%20_invoice/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

class Jobcardreport extends StatefulWidget {
  const Jobcardreport({super.key});

  @override
  State<Jobcardreport> createState() => _JobcardreportState();
}

class _JobcardreportState extends State<Jobcardreport> {
   List<Map<String, dynamic>> reportlist = [];
  List<Map<String, dynamic>> filter_reportlist = [];
  bool isSearchFieldVisible = false;
  bool isLoading = false;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _filterController = TextEditingController();
  String filterCriteria = 'Name';

  DateTime? _fromDate;
  DateTime? _toDate;
  final DateFormat _dateFormat = DateFormat('MM/dd/yyyy');

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      setState(() {
        if (isFromDate) {
          _fromDate = selectedDate;
        } else {
          _toDate = selectedDate;
        }
      });
      _filterReportList(); 
    }
  }


void _filterReportList() {
  setState(() {
    filter_reportlist = reportlist.where((report) {
      DateFormat dateFormat = DateFormat('MM/dd/yyyy');
      DateTime reportDate;
      try {
        reportDate = dateFormat.parse(report['arivedate']);
      } catch (e) {
        return false;
      }

      bool isWithinDateRange = true;
      if (_fromDate != null && _toDate != null) {
        isWithinDateRange = reportDate.isAfter(_fromDate!.subtract(Duration(days: 1))) &&
            reportDate.isBefore(_toDate!.add(Duration(days: 1)));
      }
      bool matchesSearchQuery = true;
      String query = _filterController.text.toLowerCase();
      if (query.isNotEmpty) {
        if (filterCriteria == 'Name') {
          matchesSearchQuery = report['customername']?.toLowerCase().contains(query) ?? false;
        } else if (filterCriteria == 'Jobcard No') {
          matchesSearchQuery = report['jobcardno']?.toString().toLowerCase().contains(query) ?? false;
        }
      }

      return isWithinDateRange && matchesSearchQuery;
    }).toList();
  });
}



  late Future<List<dynamic>> reportget;

  @override
  void initState() {
    super.initState();
    reportget = ApiJobcardRepository().getjobcard();
    reportget.then((data) {
      setState(() {
        reportlist = List<Map<String, dynamic>>.from(data);
        filter_reportlist = List.from(reportlist); 
      });
    });
  }

  Future<File> generatePDF(List<Map<String, dynamic>> reportList) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: [
              pw.Text("JobCard Report", style: pw.TextStyle(fontSize: 24, font: pw.Font.courier())),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                context: context,
                data: <List<String>>[
                  ['id', 'Booking Date', 'JC No', 'Name'], // Header row
                  ...reportList.map((report) => [
                    report['id'].toString(),
                    report['arivedate'] ?? '',
                    report['jobcardno'] ?? '',
                    report['customername'] ?? '',
                  ]),
                ],
                cellAlignment: pw.Alignment.center,
              ),
            ],
          );
        },
      ),
    );

    final outputDirectory = await getApplicationDocumentsDirectory();
    final file = File("${outputDirectory.path}/jobcard_report.pdf");

    await file.writeAsBytes(await pdf.save());
    return file;
  }

  Future<void> _generateAndViewPDF() async {
    if (filter_reportlist.isEmpty) {
      Fluttertoast.showToast(msg: 'No data available to generate PDF');
      return;
    }

    List<Map<String, dynamic>> formattedReportList = List<Map<String, dynamic>>.from(filter_reportlist);

    print("Formatted Report list: $formattedReportList");
    File pdfFile = await generatePDF(formattedReportList);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PDFScreen(path: pdfFile.path),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors().Scfold,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: const Color(0xFF0008B4),
         title: isSearchFieldVisible
      ? Padding(
        padding: const EdgeInsets.only(top: 16),
        child: TextField(
            controller: _searchController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Search...",
              hintStyle: TextStyle(color: Colors.white),
              border: InputBorder.none,
            ),
            autofocus: true, 
            onChanged: (value) {
              _filterReportList();}
            // automatically focus when the field is visible
          ),
      )
      : Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Center(
            child: Text(
              "JobCard Report",
              style: appbarFonts(18, Colors.white),
            ),
          ),
        ),
        leading: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios_new_sharp,color: Colors.white,size: 15,)),
      ),
        actions: [
          Padding(
          padding: const EdgeInsets.only(top: 20),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                     setState(() {
                isSearchFieldVisible = !isSearchFieldVisible; 
                if (isSearchFieldVisible) {
                  _searchController.clear(); 
                  _filterReportList();
                }
              });
                    },
                  icon: const Icon(Icons.search, color: Colors.white,size: 18,),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const FaIcon(FontAwesomeIcons.user, color: Colors.white,size: 17,),
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 39,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => _selectDate(context, true),
                            child: Row(
                              children: [
                                Icon(Icons.calendar_month_outlined, color: Appcolors().maincolor),
                                SizedBox(width: 5),
                                Text(
                                  _fromDate != null ? _dateFormat.format(_fromDate!) : "From Date",
                                  style: getFonts(13, _fromDate != null ? Appcolors().maincolor : Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          Text("-", style: TextStyle(color: Appcolors().maincolor)),
                          GestureDetector(
                            onTap: () => _selectDate(context, false),
                            child: Row(
                              children: [
                                Icon(Icons.calendar_month_outlined, color: Appcolors().maincolor),
                                SizedBox(width: 5),
                                Text(
                                  _toDate != null ? _dateFormat.format(_toDate!) : "To Date",
                                  style: getFonts(13, _toDate != null ? Appcolors().maincolor : Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  width: 39,
                  height: 39,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFF0008B4),
                  ),
                  child: IconButton(
                    onPressed: () {
                     _generateAndViewPDF();
                    },
                    icon: const Icon(Icons.download_rounded, color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(5),topRight: Radius.circular(5)),

                border: Border(
                  top: BorderSide(color: Color(0xFF0008B4), width: 2),
                  bottom: BorderSide(color: Color(0xFF0008B4), width: 1),
                ),
                color: Color(0xFF0008B4),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: const [
                  Expanded(child: Center(child: Text("SN", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
                  Expanded(child: Center(child: Text("Booking Date", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
                  Expanded(child: Center(child: Text("JC No", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
                  Expanded(child: Center(child: Text("Name", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
                ],
              ),
            ),
            Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: reportget, 
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (snapshot.hasData) {
                  reportlist = List<Map<String, dynamic>>.from(snapshot.data!);

                  return   Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 18),
                    child: ListView.builder(
                  itemCount: filter_reportlist.length,
                itemBuilder: (context, index) {
                  
                  int sn=index+1;
                  return Container(
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
                        Expanded(child: Center(child: Text("$sn"))),
                        Expanded(child: Center(child: Text(filter_reportlist[index]['arivedate']?.toString() ?? ""))),
                        Expanded(child: Center(child: Text(filter_reportlist[index]['jobcardno']?.toString() ?? ""))),
                        Expanded(child: Center(child: Text(filter_reportlist[index]['customername']?.toString() ?? ""))),
                      ],
                    ),
                  );
                },
              ),
                  ),
                );
                } else {
                  return Center(child: Text("No data available"));
                }
              },
            ),
          ),
            Padding(
              padding: const EdgeInsets.only(left: 240),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back_ios_new, size: 16)),
                  Text("1"),
                  IconButton(onPressed: () {}, icon: Icon(Icons.arrow_forward_ios_outlined, size: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: GestureDetector(
          onTap: (){
            _showFilterBottomSheet(context);
          },
          child: Container(
            width: 48,
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              color: Appcolors().maincolor,
            ),
            child: Icon(Icons.filter_list_alt, color: Colors.white),
          ),
        ),
      ),
    );

    
  }
  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Filter by:', style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Radio<String>(
                    value: 'Name',
                    groupValue: filterCriteria,
                    onChanged: (value) {
                      setState(() {
                        filterCriteria = value!;
                      });
                    },
                  ),
                  Text('Name'),
                  Radio<String>(
                    value: 'Jobcard No',
                    groupValue: filterCriteria,
                    onChanged: (value) {
                      setState(() {
                        filterCriteria = value!;
                      });
                    },
                  ),
                  Text('Jobcard No'),
                ],
              ),
              TextField(
                controller: _filterController,
                decoration: InputDecoration(
                  hintText: 'Enter ${filterCriteria == 'Name' ? 'customer name' : 'jobcard number'}...',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              Center(
               child: GestureDetector(
                onTap: () {
                   _filterReportList();
                    Navigator.pop(context);
                },
                 child: Container(
                    width: 100,height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Appcolors().maincolor
                    ),
                    child: Center(child: Text("Apply",style: getFonts(14, Colors.white),)),
                 ),
               )
              ),
            ],
          ),
        );
      },
    );
  }

}
