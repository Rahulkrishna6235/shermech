import 'dart:convert';
import 'package:intl/intl.dart'; 
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sher_mech/utility/colorss.dart';
import 'package:sher_mech/utility/databasedatails.dart';
import 'package:sher_mech/utility/drawer.dart';
import 'package:sher_mech/utility/font.dart';
import 'package:sher_mech/views/Home/newjobcard.dart';
import 'package:sher_mech/views/vehiclemake.dart';

class Jobcards extends StatefulWidget {
  const Jobcards({super.key});

  @override
  State<Jobcards> createState() => _JobcardsState();
}

class _JobcardsState extends State<Jobcards> {
 int _selectedIndex = 0;
  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  bool isLoading = false;
  List<Map<String, dynamic>> jobcardList = [];
    final TextEditingController _searchController = TextEditingController();
    List<Map<String, dynamic>> filteredJobcardList = [];
  final _formKey = GlobalKey<FormState>();
  int? _selectedSiNo;  

  @override
  void initState() {
    super.initState();
    connectAndGetData();
    _searchController.addListener(_filterSearchResults);
  }

  Future<void> connectAndGetData() async {
    bool isConnected = await connect();
    if (isConnected) {
      await getData_jobcard();
    } else {
      Fluttertoast.showToast(msg: 'Database connection failed');
    }
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
            filteredJobcardList=List.from(jobcardList);
          });
         
        } else {
          Fluttertoast.showToast(msg: 'No data found');
          setState(() {
            jobcardList = [];
            filteredJobcardList=[];
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
  
Future<bool> delete_jobcard(int siNo) async {
    setState(() {
      isLoading = true;
    });

    String query = "DELETE FROM Newjobcard WHERE id = $siNo";

    try {
      bool isConnected = await connect();
      if (isConnected) {
        String result = await sqlConnection.writeData(query);
        Map<dynamic, dynamic> valueMap = json.decode(result);
        if (valueMap['affectedRows'] == 1) {
          Fluttertoast.showToast(msg: "Deleted");
          await getData_jobcard(); 
          return true;
        } else {
          Fluttertoast.showToast(msg: "Failed to delete Newjobcard");
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }

    return false;
  }


  Future<bool> update_jobcard(
    String date,String Jobcardno,
    String Cusname,String Model,String Register,String Remark,int siNo, 
    ) async {
    setState(() {
      isLoading = true;
    });

String query = """
  UPDATE Jobcard 
  SET 
    date = '$date}',
    jobcardno = '$Jobcardno',
    customername = '$Cusname',
    modal = '$Model',
    registrationno = '$Register',
    remark = '$Remark'
  WHERE 
    ID = $siNo
""";

    try {
      bool isConnected = await connect();
      if (isConnected) {
        String result = await sqlConnection.writeData(query);
        Map<dynamic, dynamic> valueMap = json.decode(result);
        if (valueMap['affectedRows'] == 1) {
          Fluttertoast.showToast(msg: "Updated successfully");
          await getData_jobcard(); 
          return true;
        } else {
          Fluttertoast.showToast(msg: "Failed to update");
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }

    return false;
  }
 void _filterSearchResults() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredJobcardList = jobcardList.where((jobcard) {
        return jobcard['customername'].toLowerCase().contains(query) ||
               jobcard['registerno'].toLowerCase().contains(query);
      }).toList();
    });
  }

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        toolbarHeight: 80,
                backgroundColor: Color(0xFF0008B4),
        title: 
        Center(child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text("JOBCARDS",style: appbarFonts(18, Colors.white)),
        )),
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
            child: Row(children: [
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (_) => Newjobcard()));
                },
                child: Container(
                  width: 20,height: 22,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.white,width: 2)
                  ),
                  child: Center(child: Icon(Icons.add,color: Colors.white,size: 17,)),
                ),
              ),
            IconButton(onPressed: (){},  icon: FaIcon(FontAwesomeIcons.user,color: Colors.white,))
            ],),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: Column(
        children: [
          Tab(
      child: Padding(
        padding: const EdgeInsets.only(left: 14,right: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () => _onTabSelected(0),
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
                    style: getFonts(14, _selectedIndex == 0 ? Colors.white : Colors.black,),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _onTabSelected(1),
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
                    style: getFonts(14, _selectedIndex == 1 ? Colors.white : Colors.black,),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),

          SizedBox(height: 5,),

          Padding(
            padding: const EdgeInsets.only(left: 11,right: 10),
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
            onTap: (){
              _filterSearchResults();
            },
            child: Icon(Icons.search, color: Colors.grey,size: 18,)),
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
          

          SizedBox(height: 10,),

          Expanded(
            child: ListView.separated(
             separatorBuilder: (context, index) => SizedBox(height: 20),
              itemCount: filteredJobcardList.length,
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
                            child: Text("SN :$sn",style:getFonts(18, Colors.white),),
                          ),
                          PopupMenuButton<String>(
                        color: Appcolors().scafoldcolor,
                        onSelected: (value) {
                          if (value == 'Edit') {
                           //adaPopup(jobcardno: jobcardList[index]['jobcardno'],cusname: jobcardList[index]['customername'],modal: jobcardList[index]['modal'],register: jobcardList[index]['registrationno'],remark: jobcardList[index]['remark']);
                   
                          } else if (value == 'Delete') {
                            delete_jobcard(jobcardList[index]['id']);
                          }
                        },
                        itemBuilder: (BuildContext context) => [
                          PopupMenuItem(
                            value: 'Edit',
                            child: Row(
                              children: [
                              Icon(Icons.edit,color: Colors.blue,),
                  
                                Text('Edit'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'Delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete,color: Colors.red,),
                                Text('Delete'),
                              ],
                            ),
                          ),
                        ],
                        icon: Icon(Icons.more_horiz,color: Colors.white,),
                      )
                          // IconButton(onPressed: (){}, 
                          // icon: Icon(Icons.more_horiz,color: Colors.white,))
                        ],
                      ),
                     ),
                     SizedBox(height: 5,),
                     Padding(
                       padding: const EdgeInsets.only(left: 15),
                       child: Row(
                        children: [
                          _listcontents("DATE"),
                        Expanded(flex: 3, child: Text(" :${jobcardList[index]['arivedate']}  ")),
                        ],
                       ),
                     ),
                                          SizedBox(height: 5,),
                     Padding(
                       padding: const EdgeInsets.only(left: 15),
                       child: Row(
                        children: [
                          _listcontents("JOBCARD NO"),
                        Expanded(flex: 3, child: Text(" : ${jobcardList[index]['id']} ")),
                        ],
                       ),
                     ),
                                          SizedBox(height: 5,),
                     Padding(
                       padding: const EdgeInsets.only(left: 15),
                       child: Row(
                        children: [
                          _listcontents("CUSTOMER NAME"),
                        Expanded(flex: 3, child: Text(" : ${jobcardList[index]['customername']} ")),
                        ],
                       ),
                     ),
                                          SizedBox(height: 5,),
                     Padding(
                       padding: const EdgeInsets.only(left: 15),
                       child: Row(
                        children: [
                          _listcontents("MODEL"),
                        Expanded(flex: 3, child: Text(" : ${jobcardList[index]['model']}")),
                        ],
                       ),
                     ),
                                          SizedBox(height: 5,),
                     Padding(
                       padding: const EdgeInsets.only(left: 15),
                       child: Row(
                        children: [
                          _listcontents("REGISTRATION NO"),
                        Expanded(flex: 3, child: Text(" : ${jobcardList[index]['registerno']}")),
                        ],
                       ),
                     ),
                                          SizedBox(height: 5,),
                     Padding(
                       padding: const EdgeInsets.only(left: 15),
                       child: Row(
                        children: [
                          _listcontents("REMARK"),
                        Expanded(flex: 3, child: Text(" : ${jobcardList[index]['remark']} ")),
                        ],
                       ),
                     )
                  ],),
                ),
              );
            }),
          ),
          
        ],
      ),
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