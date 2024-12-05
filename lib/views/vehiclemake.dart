import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sher_mech/ApiRepository/vehiclemakerepo.dart';
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
  List vehicleList = [];
  final TextEditingController _vehiclenameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int? _selectedSiNo;  // To store the SiNo of the vehicle to be edited
  late Future<List<dynamic>> make;
  final ApiVehicleMakeRepository _apimakeRepository =ApiVehicleMakeRepository();
  final ApiVehicleMakeRepository _apimakeDelete =ApiVehicleMakeRepository();
  @override
  void initState() {
    super.initState();
    make=ApiVehicleMakeRepository().get_vehiclemake();
  }

Future<void> submitMake() async {
  if (_formKey.currentState?.validate() ?? false) {
    String vehicleName = _vehiclenameController.text.trim();
    if (vehicleName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter a vehicle name')));
      return;
    }

    Map<String, dynamic> vehicleData = {
      'VehicleName': vehicleName,
    };

    try {
      bool success = await _apimakeRepository.post_vehiclemake(vehicleData);

      if (success) {
        setState(() {
          vehicleList.add({
            'SiNo': vehicleList.length + 1,  
            'VehicleName': vehicleName,
          });
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Vehicle added successfully')));
        Navigator.pop(context); 
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add vehicle')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }
}


   Future<void> _deletevehicleMake(int id) async {
    await _apimakeDelete.deleteMake(id);
    setState(() {
      vehicleList.removeWhere((jobcard) => jobcard['siNo'] == id);
    });
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
                    submitMake();
                    //Navigator.of(context).pop();
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
     
      body: Column(
        children: [
          const SizedBox(height: 16),
          isLoading
              ? Center(child: CircularProgressIndicator())
              :  Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: make, 
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (snapshot.hasData) {
                  vehicleList = snapshot.data!;

                  return   Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 18),
                    child: ListView.separated(
                      separatorBuilder: (context, index) => const SizedBox(height: 15),
                      itemCount: vehicleList.length,
                      itemBuilder: (BuildContext context, int index) {
                        int sn = index + 1; 
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
                                      Text("$sn", style: getFonts(16, Colors.black)),
                                      const SizedBox(width: 10),
                                      CircleAvatar(radius: 20, backgroundColor: Appcolors().maincolor),
                                      const SizedBox(width: 10),
                                      Text(vehicleList[index]['VehicleName']??"", style: getFonts(16, Colors.black)),
                                    ],
                                  ),
                                  PopupMenuButton<String>(
                                    color: Appcolors().scafoldcolor,
                                    onSelected: (value) {
                                      if (value == 'Edit') {
                                        adaPopup(vehicleName: vehicleList[index]['VehicleName'], siNo: vehicleList[index]['SiNo']);
                                      } else if (value == 'Delete') {
                                        _deletevehicleMake(vehicleList[index]["siNo"]);
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
}
