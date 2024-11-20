import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sher_mech/utility/colorss.dart';
import 'package:sher_mech/utility/databasedatails.dart';
import 'package:sher_mech/utility/font.dart';
import 'package:sher_mech/views/vehiclemake.dart';
import 'package:easy_autocomplete/easy_autocomplete.dart';
import 'package:sher_mech/views/vehiclemodal.dart';

class Hdhdh extends StatefulWidget {
  const Hdhdh({super.key});

  @override
  State<Hdhdh> createState() => _HdhdhState();
}

class _HdhdhState extends State<Hdhdh> {
  bool isLoading = false;
  List<Map<String, dynamic>> vehiclemodalList = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<String> _suggestions = [];
   int? _selectedSiNo; 

  Future<List<String>> gggetData(String searchValue) async {
    String query = 'SELECT VehicleName FROM vehicleMake ';
    List<String> suggestions = [];

    try {
      bool isConnected = await connect();
      if (isConnected) {
        String result = await sqlConnection.getData(query);
        if (result.isNotEmpty) {
          List<dynamic> data = json.decode(result);
          for (var item in data) {
            suggestions.add(item['VehicleName']);
          }
        }
      } else {
        Fluttertoast.showToast(msg: 'Database connection failed');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
    }

    return suggestions;
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
        });
      } else {
        Fluttertoast.showToast(msg: 'No data found');
        setState(() {
          vehiclemodalList = [];
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

  Future<bool> post() async {
  if (_formKey.currentState != null && _formKey.currentState!.validate()) {
    setState(() {
      isLoading = true;
    });

    String title = _titleController.text.replaceAll("'", "''");
    String subtitle = _subtitleController.text.replaceAll("'", "''");

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

     // print("Max ID Result: $maxSiNoResult");  

      if (maxSiNoResult.isNotEmpty) {
        List<dynamic> resultList = json.decode(maxSiNoResult);
        if (resultList.isNotEmpty && resultList[0]['MaxID'] != null) {
          nextID = resultList[0]['MaxID'] + 1; 
        }
      }

      String query = "INSERT INTO VehicleModel (ID, modeletitle, modalsubtitle) VALUES ($nextID, '$title', '$subtitle')";
      String result = await sqlConnection.writeData(query);

      //print("Insert Result: $result");  

      Map<String, dynamic> valueMap = json.decode(result);

      if (valueMap['affectedRows'] == 1) {
        _titleController.clear();
        _subtitleController.clear();
        await Getdata(); 
        Fluttertoast.showToast(msg: "Vehicle added successfully");
        return true;
      } else {
        Fluttertoast.showToast(msg: "Failed to add vehicle");
        //print("Failed to add vehicle. Affected rows: ${valueMap['affectedRows']}");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
      print("Error: $e");  
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  return false;
}

Future<bool> updateVehiclemodal(int ID, String modaltitle,String modalsubtitle) async {
    setState(() {
      isLoading = true;
    });

String query = "UPDATE VehicleModel SET modeletitle = '$modaltitle', modalsubtitle = '$modalsubtitle' WHERE ID = $ID";

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

  void fetchSuggestions(String query) async {
    if (query.isNotEmpty) {
      List<String> fetchedSuggestions = await gggetData(query);
      setState(() {
        _suggestions = fetchedSuggestions;
      });
    } else {
      setState(() {
        _suggestions = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors().Scfold,
      appBar: AppBar(backgroundColor: Appcolors().Scfold,),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Container(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                 Text("Vehicle Details",style: getFonts(20, Colors.black),),
                 SizedBox(height: 30,),
                
                    textfield("Enter Vehicle Model", _titleController),
                    SizedBox(height: 20),
                    Container(
                      width: 290,
                      height: 58,
                      decoration: BoxDecoration(
                        border: Border.all(color: Appcolors().maincolor),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: EasyAutocomplete(
                        
                        controller: _subtitleController,
                        suggestions: _suggestions,
                        
                        onChanged: (value) {
                          fetchSuggestions(value);
                        },
                        onSubmitted: (value) {
                          print('Selected value: $value');
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () async {
                         bool success;
                    if (_selectedSiNo != null) {
                      success = await updateVehiclemodal(_selectedSiNo!, _titleController.text,_subtitleController.text);
                    } else {
                      success = await post();
                    }
                    if (success) {
                      Navigator.pop(context);
                    }
                        // bool success = await post(_titleController.text, _subtitleController.text);
                        // if (success) {
                        //   Navigator.push(
                        //       context,
                        //       MaterialPageRoute(builder: (_) => Vehiclemodal(vehicleData: vehiclemodalList,))
                        //   );
                        // }
                      },
                      child: Center(
                        child: Container(
                          width: 165,
                          height: 53,
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
        ],
      ),
    );
  }

  Widget textfield(String hint, TextEditingController controller) {
    return Container(
      width: 290,
      height: 58,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextFormField(
        controller: controller,
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
                      hintText: hint,
                      hintStyle: TextStyle(color: Color(0xFF948C93)),
                    ),
        autofocus: true,
      ),
    );
  }
}
