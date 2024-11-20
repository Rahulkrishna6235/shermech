import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sher_mech/utility/colorss.dart';
import 'package:sher_mech/utility/databasedatails.dart';
import 'package:sher_mech/utility/drawer.dart';
import 'package:sher_mech/utility/font.dart';
import 'package:mssql_connection/mssql_connection.dart';
import 'package:fluttertoast/fluttertoast.dart';

class VehicleMake extends StatefulWidget {
  const VehicleMake({super.key});

  @override
  State<VehicleMake> createState() => _VehicleMakeState();
}

final sqlConnection = MssqlConnection.getInstance();

class _VehicleMakeState extends State<VehicleMake> {
  bool isLoading = false;
  List<Map<String, dynamic>> vehicleList = [];
  final TextEditingController _vehiclenameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int? _selectedSiNo;  // To store the SiNo of the vehicle to be edited

  @override
  void initState() {
    super.initState();
    connectAndGetData();
  }

  Future<void> connectAndGetData() async {
    bool isConnected = await connect();
    if (isConnected) {
      await getData(); 
    } else {
      Fluttertoast.showToast(msg: 'Database connection failed');
    }
  }

  Future<bool> connect() async {
    return await sqlConnection.connect(
      ip: ipAdress,
      port: port,
      databaseName: databasename,
      username: username,
      password: password,
    );
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

  Future<bool> post() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      String vehicleName = _vehiclenameController.text.replaceAll("'", "''");

      String queryMaxSiNo = 'SELECT MAX(SiNo) as MaxSiNo FROM vehicleMake';
      int nextSiNo = 1;  

      try {
        bool isConnected = await connect();
        if (isConnected) {
          String maxSiNoResult = await sqlConnection.getData(queryMaxSiNo);
          if (maxSiNoResult.isNotEmpty) {
            List<dynamic> resultList = json.decode(maxSiNoResult);
            if (resultList.isNotEmpty) {
              Map<String, dynamic> resultMap = resultList[0];
              if (resultMap['MaxSiNo'] != null) {
                nextSiNo = resultMap['MaxSiNo'] + 1;
              }
            }
          }

          String insertQuery = "INSERT INTO vehicleMake (SiNo, VehicleName) VALUES ($nextSiNo, '$vehicleName')";

          String result = await sqlConnection.writeData(insertQuery);
          Map<dynamic, dynamic> valueMap = json.decode(result);
          if (valueMap['affectedRows'] == 1) {
            _vehiclenameController.clear();
            await getData();  
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: "Vehicle added successfully");
            return true;
          } else {
            Fluttertoast.showToast(msg: "Failed to add vehicle");
            setState(() {
              isLoading = false;
            });
          }
        }
      } catch (e) {
        Fluttertoast.showToast(msg: "Error: $e");
      }
    }
    return false;
  }

  Future<bool> updateVehicle(int siNo, String newVehicleName) async {
    setState(() {
      isLoading = true;
    });

    String query = "UPDATE vehicleMake SET VehicleName = '$newVehicleName' WHERE SiNo = $siNo";

    try {
      bool isConnected = await connect();
      if (isConnected) {
        String result = await sqlConnection.writeData(query);
        Map<dynamic, dynamic> valueMap = json.decode(result);
        if (valueMap['affectedRows'] == 1) {
          Fluttertoast.showToast(msg: "Vehicle updated successfully");
          await getData(); 
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

  Future<bool> deleteVehicle(int siNo) async {
    setState(() {
      isLoading = true;
    });

    String query = "DELETE FROM vehicleMake WHERE SiNo = $siNo";

    try {
      bool isConnected = await connect();
      if (isConnected) {
        String result = await sqlConnection.writeData(query);
        Map<dynamic, dynamic> valueMap = json.decode(result);
        if (valueMap['affectedRows'] == 1) {
          Fluttertoast.showToast(msg: "Deleted");
          await getData(); 
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

  adaPopup({String? vehicleName, int? siNo}) {
    if (vehicleName != null && siNo != null) {
      _vehiclenameController.text = vehicleName;
      _selectedSiNo = siNo;  
    }

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
                Text(_selectedSiNo == null ? "Enter Details" : "Edit Details"),
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
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _vehiclenameController,
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
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Appcolors().maincolor),
                      ),
                      hintText: "Enter Vehicle Model",
                      hintStyle: TextStyle(color: Color(0xFF948C93)),
                    ),
                    autofocus: true,
                  ),
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () async {
                    bool success;
                    if (_selectedSiNo != null) {
                      success = await updateVehicle(_selectedSiNo!, _vehiclenameController.text);
                    } else {
                      success = await post();
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
        );
      },
    );
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
            child: Text("Vehicle Make", style: appbarFonts(18, Colors.white)),
          ),
        ),
        leading: Builder(
          builder: (context) => InkWell(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Image.asset("assets/images/Menu (2).png", scale: 1.8),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    adaPopup();
                  },
                  child: Container(
                    width: 20,
                    height: 22,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Center(
                      child: Icon(Icons.add, color: Colors.white, size: 17),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: FaIcon(FontAwesomeIcons.user, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Column(
        children: [
          const SizedBox(height: 16),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 18),
                    child: ListView.separated(
                      separatorBuilder: (context, index) => const SizedBox(height: 15),
                      itemCount: vehicleList.length,
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
                                      Text(vehicleList[index]['SiNo'].toString(), style: getFonts(16, Colors.black)),
                                      const SizedBox(width: 10),
                                      CircleAvatar(radius: 20, backgroundColor: Appcolors().maincolor),
                                      const SizedBox(width: 10),
                                      Text(vehicleList[index]['VehicleName'], style: getFonts(16, Colors.black)),
                                    ],
                                  ),
                                  PopupMenuButton<String>(
                                    color: Appcolors().scafoldcolor,
                                    onSelected: (value) {
                                      if (value == 'Edit') {
                                        adaPopup(vehicleName: vehicleList[index]['VehicleName'], siNo: vehicleList[index]['SiNo']);
                                      } else if (value == 'Delete') {
                                        deleteVehicle(vehicleList[index]['SiNo']); 
                                      }
                                    },
                                    itemBuilder: (BuildContext context) => [
                                      const PopupMenuItem(value: 'Edit', child: Text('Edit')),
                                      const PopupMenuItem(value: 'Delete', child: Text('Delete')),
                                    ],
                                    icon: Icon(Icons.more_vert, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
