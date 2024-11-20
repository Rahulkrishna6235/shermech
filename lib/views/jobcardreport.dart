import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sher_mech/utility/colorss.dart';
import 'package:intl/intl.dart';
import 'package:sher_mech/utility/databasedatails.dart';
import 'package:sher_mech/utility/drawer.dart';
import 'package:sher_mech/utility/font.dart';
import 'package:sher_mech/views/vehiclemake.dart';


class Jobcardreport extends StatefulWidget {
  const Jobcardreport({super.key});

  @override
  State<Jobcardreport> createState() => _JobcardreportState();
}

class _JobcardreportState extends State<Jobcardreport> {
  List<Map<String,dynamic>> reportlist=[];
  bool isLoading = false;

  DateTime? _fromDate;
  DateTime? _toDate;
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

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
    }
  }

   @override
  void initState() {
    super.initState();
    connectAndGetData();
   // _searchController.addListener(_filterSearchResults);
  }

  Future<void> connectAndGetData() async {
    bool isConnected = await connect();
    if (isConnected) {
      await getData_reportcard();
    } else {
      Fluttertoast.showToast(msg: 'Database connection failed');
    }
  }
   Future<void> getData_reportcard() async {
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
        List<Map<String, dynamic>> tempList = List<Map<String, dynamic>>.from(data);

        final DateFormat dateFormat = DateFormat('yyyy-MM-dd');  
        if (_fromDate != null && _toDate != null) {
          tempList = tempList.where((jobCard) {
            try {
              DateTime jobCardDate = dateFormat.parse(jobCard['arivedate']?.toString() ?? '');
              return jobCardDate.isAfter(_fromDate!.subtract(Duration(days: 1))) &&
                     jobCardDate.isBefore(_toDate!.add(Duration(days: 1)));
            } catch (e) {
              print("Error parsing date: ${jobCard['arivedate']}");
              return false; 
            }
          }).toList();
        }

        setState(() {
          reportlist = tempList;
        });
      } else {
        Fluttertoast.showToast(msg: 'No data found');
        setState(() {
          reportlist = [];
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


 Future<void> _select_reportDate(BuildContext context, bool isFromDate) async {
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
    await getData_reportcard();
  }
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors().Scfold,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: const Color(0xFF0008B4),
        title: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              "JobCard Report",
              style: appbarFonts(18, Colors.white),
            ),
          ),
        ),
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.search, color: Colors.white),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const FaIcon(FontAwesomeIcons.user, color: Colors.white),
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
                            onTap: () => _select_reportDate(context, true),
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
                            onTap: () => _select_reportDate(context, false),
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
                     // generateAndSharePDF(context);
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
              child: ListView.builder(
                  itemCount: reportlist.isEmpty ? 0 : reportlist.length,
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
                        Expanded(child: Center(child: Text(reportlist[index]['arivedate']?.toString() ?? ""))),
                        Expanded(child: Center(child: Text(reportlist[index]['id']?.toString() ?? ""))),
                        Expanded(child: Center(child: Text(reportlist[index]['customername']?.toString() ?? ""))),
                      ],
                    ),
                  );
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
    );
  }
}
