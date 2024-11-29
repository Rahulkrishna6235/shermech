import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sher_mech/utility/colorss.dart';
import 'package:sher_mech/utility/databasedatails.dart';
import 'package:sher_mech/utility/drawer.dart';
import 'package:sher_mech/utility/font.dart';
import 'package:sher_mech/views/easyautocom.dart';
import 'package:sher_mech/views/vehiclemake.dart';
import 'package:flutter_async_autocomplete/flutter_async_autocomplete.dart';
import 'package:easy_autocomplete/easy_autocomplete.dart';


class Vehiclemodal extends StatefulWidget {
  final List<Map<String, dynamic>> vehicleData;

  const Vehiclemodal({Key? key, required this.vehicleData}) : super(key: key);
  @override
  State<Vehiclemodal> createState() => _VehiclemodalState();
}

class _VehiclemodalState extends State<Vehiclemodal> {

  bool isLoading = false;
  List<Map<String, dynamic>> vehiclemodalList = [];
  List<Map<String, dynamic>> filteredVehicleList = [];
  List<Map<String,dynamic>> vehicleList=[];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  List<String> _suggestions = [];
int? _selectedSiNo; 
  @override
  void initState() {
    super.initState();
    connectAndGetData();
    _searchController.addListener(_filterSearchResults);
    getData();
  }

  Future<void> connectAndGetData() async {
    bool isConnected = await connect();
    if (isConnected) {
      await Getdata();
    } else {
      Fluttertoast.showToast(msg: 'Database connection failed');
    }
  }

  Future<bool> post(String modelTitle, String modalSubtitle) async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      String title = modelTitle.replaceAll("'", "''");
      String subtitle = modalSubtitle.replaceAll("'", "''");

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

        String queryMaxSiNo = 'SELECT MAX(ID) as MaxID FROM VehicleModel';
        String maxSiNoResult = await sqlConnection.getData(queryMaxSiNo);

        if (maxSiNoResult.isNotEmpty) {
          List<dynamic> resultList = json.decode(maxSiNoResult);
          if (resultList.isNotEmpty && resultList[0]['MaxID'] != null) {
            nextID = resultList[0]['MaxID'] + 1;
          }
        }

        String query = "INSERT INTO VehicleModel (ID, modeletitle, modalsubtitle) VALUES ($nextID, '$title', '$subtitle')";
        String result = await sqlConnection.writeData(query);
        Map<String, dynamic> valueMap = json.decode(result);

        if (valueMap['affectedRows'] == 1) {
          _titleController.clear();
          _subtitleController.clear();
          await Getdata();
          Fluttertoast.showToast(msg: "Vehicle added successfully");
          return true;
        } else {
          Fluttertoast.showToast(msg: "Failed to add vehicle");
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

  Future<void> Getdata() async {
    String query = 'SELECT * FROM VehicleModel ORDER BY ID';
    setState(() {
      isLoading = true;
    });

    try {
      bool isConnected = await connect();
      if (!isConnected) {
        Fluttertoast.showToast(msg: 'Database connection failed');
        setState(() {
          isLoading = false;
        });
        return;
      }

      String result = await sqlConnection.getData(query);
      if (result.isNotEmpty) {
        List<dynamic> data = json.decode(result);
        setState(() {
          vehiclemodalList = List<Map<String, dynamic>>.from(data);
          filteredVehicleList = List.from(vehiclemodalList);
        });

        int nextID = 1;
        for (var vehicle in vehiclemodalList) {
          vehicle['ID'] = nextID++;
        }
      } else {
        Fluttertoast.showToast(msg: 'No data found');
        setState(() {
          vehiclemodalList = [];
          filteredVehicleList = [];
        });
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<bool> deleteVehicle(int nextID) async {
    setState(() {
      isLoading = true;
    });

    String query = "DELETE FROM VehicleModel WHERE ID = $nextID";

    try {
      bool isConnected = await connect();
      if (isConnected) {
        String result = await sqlConnection.writeData(query);
        Map<dynamic, dynamic> valueMap = json.decode(result);
        if (valueMap['affectedRows'] == 1) {
          Fluttertoast.showToast(msg: "Deleted");
          await Getdata();
          return true;
        } else {
          Fluttertoast.showToast(msg: "Failed to delete vehicle");
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

  Future<bool> updateVehiclemodal(int id, String modaltitle,String modalsubtitle) async {
    setState(() {
      isLoading = true;
    });

String query = "UPDATE VehicleModel SET modeletitle = '$modaltitle', modalsubtitle = '$modalsubtitle' WHERE ID = $id";

    try {
      bool isConnected = await connect();
      if (isConnected) {
        String result = await sqlConnection.writeData(query);
        Map<dynamic, dynamic> valueMap = json.decode(result);
        if (valueMap['affectedRows'] == 1) {
          Fluttertoast.showToast(msg: "Vehicle updated successfully");
          await Getdata(); 
          return true;
        } else {
          Fluttertoast.showToast(msg: "Failed to update vehicle");
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
      filteredVehicleList = vehiclemodalList
          .where((vehicle) =>
              vehicle['modeletitle'].toLowerCase().contains(query) ||
              vehicle['modalsubtitle'].toLowerCase().contains(query))
          .toList();
    });
  }

Future<void> getData() async {
    String query = 'SELECT * FROM vehicleMake ORDER BY SiNo';
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
            vehicleList = List<Map<String, dynamic>>.from(data);
          });
          int siNo=1;
          for(var vehiclemake in vehicleList){
              vehiclemake['SiNo']=siNo++;
          }
        } else {
          Fluttertoast.showToast(msg: 'No data found');
          setState(() {
            vehicleList = [];
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
  try {
    final selectedJobcard =
        vehicleList.firstWhere((jobcard) => jobcard['VehicleName'] == jobcardNo);

    // Perform necessary actions with selectedJobcard
    print('Selected Jobcard: $selectedJobcard');
  } catch (e) {
    Fluttertoast.showToast(msg: 'Error: No matching data found');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors().Scfold,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Color(0xFF0008B4),
        title: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text("Vehicle Modal", style: appbarFonts(18, Colors.white)),
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
                GestureDetector(
                  onTap: () {
                    adaPopup();
                  },
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Center(
                      child: Icon(Icons.add, color: Colors.white, size: 15),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: FaIcon(FontAwesomeIcons.user, color: Colors.white,size: 17,),
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 19, right: 10,top: 13),
                child: Container(
                  height: 39,
                  width: 317,
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
                          child: Icon(Icons.search, color: Colors.grey)),
                        SizedBox(width: 5),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: "Search..",
                              hintStyle: TextStyle(fontSize: 13),
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
              SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  width: 39,
                  height: 39,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFF0008B4),
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.filter_list_alt, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16,right: 18),
              child: ListView.separated(
                itemCount: filteredVehicleList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    width: 358,
                    height: 59,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Appcolors().scafoldcolor,
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(" ${filteredVehicleList[index]['ID']}",style: getFonts(16, Colors.black)),
                                SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(filteredVehicleList[index]["modeletitle"], style: getFonts(16, Colors.black)),
                                    Text(filteredVehicleList[index]["modalsubtitle"], style: TextStyle(color: Colors.black,)),
                                  ],
                                ),
                              ],
                            ),
                            PopupMenuButton<String>(
                              color: Appcolors().scafoldcolor,
                              onSelected: (value) {
                                 if (value == 'Edit') {
                                   adaPopup(title:vehiclemodalList[index]["modeletitle"],subtitle: vehiclemodalList[index]["modalsubtitle"],id:vehiclemodalList[index]["ID"] );  
                                      } else if (value == 'Delete') {
                                        deleteVehicle(filteredVehicleList[index]["ID"]); 
                                      }
      
                              },
                              itemBuilder: (BuildContext context) => [
                                PopupMenuItem(
                                  value: 'Edit',
                                  child: Text('Edit'),
                                ),
                                PopupMenuItem(
                                  value: 'Delete',
                                  child: Text('Delete'),
                                ),
                              ],
                              icon: Icon(Icons.more_vert, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
  adaPopup({String ? title,String? subtitle,int? id}) {
    if (title != null && subtitle != null && id !=null) {
      setState(() {
      _titleController.text = title;
      _subtitleController.text = subtitle;
      _selectedSiNo = id; 
    });  
    }
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Appcolors().Scfold,
          
          content: SingleChildScrollView(
            child: SafeArea(
              child: Container(
                height: 250,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        
                                        Text(_selectedSiNo == null ? "Enter Details" : "Edit Details",style: getFonts(18, Colors.black),),
                                        IconButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          icon: Icon(Icons.close),
                                        ),
                                      ],
                                    ),
                      ),
                        Container(
                        width: 290,
                        height: 58,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextFormField(
                          controller: _titleController,
                          validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a vehicle model';
                        }
                        return null;
                      }, 
                          decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: Appcolors().scafoldcolor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Appcolors().maincolor),
                        ),
                        hintText: "Enter the model",
                        hintStyle: TextStyle(color: Color(0xFF948C93)),
                      ),
                          autofocus: true,
                        ),
                      ),
                      Container(
                            width: 290,
                            height: 58,
                            decoration: BoxDecoration(
                              border: Border.all(color: Appcolors().maincolor),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: EasyAutocomplete(
                                                        controller: _subtitleController,
                                                        suggestions: vehicleList
                                      .map((jobcard) => jobcard['VehicleName'].toString())
                                      .toList(),
                                                        onSubmitted: (value) {
                                    onJobcardSelected(value);
                                                        },
                                                      decoration: InputDecoration(
                            border: InputBorder.none
                          ),
                                                      ),
                          ),
                      const SizedBox(height: 15),
                      GestureDetector(
                        onTap: () async {
                          bool success = false;
                      if (_selectedSiNo != null) {
                        success = await updateVehiclemodal(_selectedSiNo!, _subtitleController.text,_titleController.text);
                      } else {
                        success = await post(
                          _titleController.text.trim(),
        _subtitleController.text.trim(),
                        );
                      }
                      if (success) {
                        Navigator.pop(context);
                      }
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
            ),
          ),
        );
      },
    );
  }
  @override
  void dispose(){
    super.dispose();
    _subtitleController.clear();
    _subtitleController.dispose();
  }
}
