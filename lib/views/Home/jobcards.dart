import 'dart:convert';
import 'package:intl/intl.dart'; 
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sher_mech/ApiRepository/jobcardlist.dart';
import 'package:sher_mech/utility/colorss.dart';
import 'package:sher_mech/utility/databasedatails.dart';
import 'package:sher_mech/utility/drawer.dart';
import 'package:sher_mech/utility/font.dart';
import 'package:sher_mech/views/Home/newjobcard.dart';
import 'package:sher_mech/views/tabs/pendingdelivary.dart';
import 'package:sher_mech/views/tabs/pendingjobcard.dart';
import 'package:sher_mech/views/vehiclemake.dart';

class Jobcards extends StatefulWidget {
  
  const Jobcards({super.key});

  @override
  State<Jobcards> createState() => _JobcardsState();
}
class _JobcardsState extends State<Jobcards> {
  int _selectedIndex = 0;
  bool isLoading = false;
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> filteredJobcardList = [];
  final _formKey = GlobalKey<FormState>();
  int? _selectedSiNo;

  late Future<List<dynamic>> jobcards;

  @override
  void initState() {
    super.initState();
     _searchController.addListener(_filterSearchResults);
    jobcards = ApiJobcardRepository().getjobcard();
  }

  void _OnTabSelected(int index) {
    setState(() {
      _selectedIndex = index; 
    });
    switch (_selectedIndex) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PendingCard()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PEndingDelivary()),
        );
        break;
      default:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PendingCard()),
        );
    }
  }

  void _filterSearchResults() {
    setState(() {
      filteredJobcardList = jobcards as List<dynamic>; // Filter jobcards based on search query
      if (_searchController.text.isNotEmpty) {
        filteredJobcardList = filteredJobcardList
            .where((jobcard) => jobcard['customername']
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Color(0xFF0008B4),
        title: Center(
            child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text("JOBCARDS", style: appbarFonts(18, Colors.white)),
        )),
        leading: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios_new_sharp,
                  color: Colors.white, size: 15)),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => Newjobcard()));
                  },
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.white, width: 2)),
                    child: Center(
                        child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 15,
                    )),
                  ),
                ),
                IconButton(
                    onPressed: () {},
                    icon: FaIcon(
                      FontAwesomeIcons.user,
                      color: Colors.white,
                      size: 16,
                    ))
              ],
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: Column(
        children: [
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 14, right: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () => _OnTabSelected(0),
                  child: Container(
                    width: 175,
                    height: 33,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: _selectedIndex == 0 ? Color(0xFF0008B4) : Colors.white,
                    ),
                    child: Center(
                      child: Text(
                        "PENDING JOBCARDS",
                        style: getFonts(
                          14,
                          _selectedIndex == 0 ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _OnTabSelected(1),
                  child: Container(
                    width: 175,
                    height: 33,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: _selectedIndex == 1 ? Color(0xFF0008B4) : Colors.white,
                    ),
                    child: Center(
                      child: Text(
                        "PENDING DELIVERY",
                        style: getFonts(
                          14,
                          _selectedIndex == 1 ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 11, right: 10),
            child: Container(
              height: 39,
              width: 358,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                       _filterSearchResults(); 
                      },
                      child: Icon(
                        Icons.search,
                        color: Colors.grey,
                        size: 18,
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
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
          SizedBox(height: 20),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: jobcards, 
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (snapshot.hasData) {
                  filteredJobcardList = snapshot.data!;

                  return ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(height: 20),
                    itemCount: filteredJobcardList.length,
                    itemBuilder: (BuildContext context, int index) {
                      int sn = index + 1;
                      return Padding(
                        padding: const EdgeInsets.only(left: 26, right: 26),
                        child: Container(
                          width: 358,
                          height: 260,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5),
                            ),
                            color: Color(0xFFFFFFFF),
                          ),
                          child: Column(
                            children: [
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
                                      child: Text("SN :  $sn", style: TextStyle(color: Colors.white)),
                                    ),
                                    PopupMenuButton<String>(
                                      color: Colors.white,
                                      onSelected: (value) {
                                        if (value == 'Edit') {
                                          // Edit action
                                        } else if (value == 'Delete') {
                                          // Delete action
                                        }
                                      },
                                      itemBuilder: (BuildContext context) => [
                                        PopupMenuItem(
                                          value: 'Edit',
                                          child: Row(
                                            children: [
                                              Icon(Icons.edit, color: Colors.blue),
                                              Text('Edit'),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: 'Delete',
                                          child: Row(
                                            children: [
                                              Icon(Icons.delete, color: Colors.red),
                                              Text('Delete'),
                                            ],
                                          ),
                                        ),
                                      ],
                                      icon: Icon(Icons.more_horiz, color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 5),
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Row(
                                  children: [
                                    _listcontents("DATE"),
                                    Expanded(flex: 3, child: Text(" :   ${filteredJobcardList[index]['arivedate']}  ", style: filedFonts())),
                                  ],
                                ),
                              ),
                              SizedBox(height: 5),
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Row(
                                  children: [
                                    _listcontents("JOBCARD NO"),
                                    Expanded(flex: 3, child: Text(" :   ${filteredJobcardList[index]['jobcardno']} ", style: filedFonts())),
                                  ],
                                ),
                              ),
                              SizedBox(height: 5),
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Row(
                                  children: [
                                    _listcontents("CUSTOMER NAME"),
                                    Expanded(flex: 3, child: Text(" :   ${filteredJobcardList[index]['customername']} ", style: filedFonts())),
                                  ],
                                ),
                              ),
                              SizedBox(height: 5),
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Row(
                                  children: [
                                    _listcontents("MODEL"),
                                    Expanded(flex: 3, child: Text(" :   ${filteredJobcardList[index]['model']}", style: filedFonts())),
                                  ],
                                ),
                              ),
                              SizedBox(height: 5),
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Row(
                                  children: [
                                    _listcontents("REGISTRATION NO"),
                                    Expanded(flex: 3, child: Text(" :   ${filteredJobcardList[index]['registerno']}", style: filedFonts())),
                                  ],
                                ),
                              ),
                              SizedBox(height: 5),
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Row(
                                  children: [
                                    _listcontents("REMARK"),
                                    Expanded(flex: 3, child: Text(" :   ${filteredJobcardList[index]['remark']} ", style: filedFonts())),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: Text("No data available"));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _listcontents(String listtext) {
    return Expanded(
      flex: 3,
      child: Padding(
        padding: const EdgeInsets.only(left: 9, top: 5),
        child: Text(
          listtext,
          style: getFonts(14, Colors.black),
        ),
      ),
    );
  }
}
