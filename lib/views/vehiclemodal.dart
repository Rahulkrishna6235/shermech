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
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  List<String> _suggestions = [];

  @override
  void initState() {
    super.initState();
    connectAndGetData();
    _searchController.addListener(_filterSearchResults);
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
  
   fetchSuggestions(String query) async {
    // if (query.isNotEmpty) {
      List<String> fetchedSuggestions = await gggetData(query);
      setState(() {
       _suggestions = fetchedSuggestions.map((e) => e).toList();
      //   fetchedSuggestions.firstWhere((element) {
      // return element.toLowerCase().contains(query.toLowerCase());
      //   },);
      });
    // } else {
    //   setState(() {
    //     _suggestions = [];
    //   });
    // }
    // return _suggestions;
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
                            // Navigator.push(context, MaterialPageRoute(builder: (_) => Hdhdh(id: index,modalsubtitle: vehiclemodalList[index]['modelsubtitle'],modeletitle: vehiclemodalList[index]['modelsubtitle'], )));
                                  updateVehiclemodal(vehiclemodalList[index]['ID'], vehiclemodalList[index]['modeltitle'], vehiclemodalList[index]['modelsubtitle']);
                                     
                                      } else if (value == 'Delete') {
                                        deleteVehicle(filteredVehicleList[index]["ID"]); 
                                      }
                                // if (value == 'Edit') {
                                //   // Add edit functionality here
                                // } else if (value == 'Delete') {
                                //   deleteVehicle(filteredVehicleList[index]["ID"]);
                                // }
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
  adaPopup() {
    

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Appcolors().Scfold,
          
          content: SingleChildScrollView(
            child: SafeArea(
              child: Container(
                height: 350,
                child: Column(
                  children: [
                    Container(
                          width: 290,
                          height: 58,
                          decoration: BoxDecoration(
                            border: Border.all(color: Appcolors().maincolor),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Expanded(
                            child: EasyAutocomplete(
                              progressIndicatorBuilder: Center(
                                child: CircularProgressIndicator(),
                              ),
                              controller: _subtitleController,
                              suggestions: _suggestions,
                              // asyncSuggestions: (searchValue) async{
                              // return  await fetchSuggestions(searchValue);},
                              // suggestionBuilder: (data) {
                              //   return Text(data);
                              // },
                              onChanged: (value) {
                               setState(() {
                                  fetchSuggestions(value);
                               });
                              },
                              onSubmitted: (value) {
                                final selectedModel = value;
                                print('Selected value: $value');
                                // _subtitleController.clear();
                                
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none
                              ),
                            ),
                          ),
                        ),
                    // const SizedBox(height: 15),
                    // GestureDetector(
                    //   onTap: () async {
                        
                    //   },
                    //   child: Center(
                    //     child: Container(
                    //       width: 155,
                    //       height: 43,
                    //       decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(10),
                    //         color: Color(0xFF0008B4),
                    //       ),
                    //       child: Center(
                    //         child: Text("Save", style: getFonts(14, Colors.white)),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
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
