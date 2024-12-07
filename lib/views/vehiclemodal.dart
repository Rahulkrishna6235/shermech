import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sher_mech/ApiRepository/vehiclemakerepo.dart';
import 'package:sher_mech/ApiRepository/vehiclemodalapi.dart';
import 'package:sher_mech/utility/colorss.dart';
import 'package:sher_mech/utility/drawer.dart';
import 'package:sher_mech/utility/font.dart';
import 'package:easy_autocomplete/easy_autocomplete.dart';


class Vehiclemodal extends StatefulWidget {
  final List<Map<String, dynamic>> vehicleData;

  const Vehiclemodal({Key? key, required this.vehicleData}) : super(key: key);
  @override
  State<Vehiclemodal> createState() => _VehiclemodalState();
}

class _VehiclemodalState extends State<Vehiclemodal> {

  bool isLoading = false;
  List vehiclemodalList = [];
  List filteredVehicleList = [];

  List<Map<String,dynamic>> vehicleList=[];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
 String filterCriteria = 'Model';
  final _formKey = GlobalKey<FormState>();
int? _selectedSiNo; 
late Future<List<dynamic>> jobcards;
List<String> Vmake = [];
  List<dynamic> vamnes = [];
final ApiVehicleModelRepository _apiModelRepository=ApiVehicleModelRepository();
final ApiVehicleModelRepository _apiDeleteModel=ApiVehicleModelRepository();
final ApiVehicleModelRepository _apiUpdateModel=ApiVehicleModelRepository();

 @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterSearchResults);
    jobcards = ApiVehicleModelRepository().get_vehiclemodel();
    fetchJobcards();
    _loadVehicleData();
    jobcards.then((data) {
      setState(() {
        vehicleList = List<Map<String, dynamic>>.from(data);
        filteredVehicleList = List.from(vehicleList);
      });
    });
  }
  Future<void> submitModel() async {
  if (_formKey.currentState?.validate() ?? false) {
    String title = _titleController.text.trim();
    String subtitle = _subtitleController.text.trim();

    if (title.isEmpty || subtitle.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter all fields')));
      return;
    }

    Map<String, dynamic> vehicleData = {
      'modeletitle': title,
      'modalsubtitle': subtitle,
    };

    try {
      if (_selectedSiNo == null) {
        bool success = await _apiModelRepository.post_vehiclemodel(vehicleData);

        if (success) {
          setState(() {
            filteredVehicleList.add({
              'ID': filteredVehicleList.length + 1,  
              'modeletitle': title,
              'modalsubtitle': subtitle,
            });
          });

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Vehicle model added successfully')));
          _titleController.clear();
          _subtitleController.clear();
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add vehicle model')));
        }
      } else {
        bool success = await _apiUpdateModel.updateVehicleModel(
          _selectedSiNo!.toString(),
          title,
          subtitle,
        );

        if (success) {
          setState(() {
            int index = filteredVehicleList.indexWhere((vehicle) => vehicle['ID'] == _selectedSiNo);
            if (index != -1) {
              filteredVehicleList[index]['modeletitle'] = title;
              filteredVehicleList[index]['modalsubtitle'] = subtitle;
            }
          });

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Vehicle model updated successfully')));
          _titleController.clear();
          _subtitleController.clear();
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update vehicle model')));
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }
}

void _applyFilter() {
  final searchText = _filterController.text.toLowerCase().trim();

  setState(() {
    if (searchText.isEmpty) {
      // Reset to show all data if the filter input is empty
      filteredVehicleList = List.from(vehicleList);
    } else {
      // Filter the list based on selected criteria
      filteredVehicleList = vehicleList.where((vehicle) {
        if (filterCriteria == 'Model') {
          final modelTitle = vehicle['modeletitle']?.toString().toLowerCase() ?? '';
          return modelTitle.contains(searchText);
        } else if (filterCriteria == 'Make') {
          final makeTitle = vehicle['modalsubtitle']?.toString().toLowerCase() ?? '';
          return makeTitle.contains(searchText);
        }
        return false;
      }).toList();
    }
  });
}

void _filterSearchResults() {
  setState(() {
    if (_searchController.text.isEmpty) {
      filteredVehicleList = List.from(vehicleList);
    } else {
      filteredVehicleList = vehicleList.where((vehicle) {
        final modelTitle = vehicle['modeletitle']?.toString().toLowerCase() ?? '';
        final subtitle = vehicle['modalsubtitle']?.toString().toLowerCase() ?? '';
        final searchText = _searchController.text.toLowerCase();

        return modelTitle.contains(searchText) || subtitle.contains(searchText);
      }).toList();
    }
  });
}
Future<void> _loadVehicleData() async {
  try {
    final data = await _apiModelRepository.get_vehiclemodel();
    setState(() {
      vehicleList = List<Map<String, dynamic>>.from(data);
      filteredVehicleList = List.from(vehicleList); // Initialize filtered list
    });
  } catch (e) {
    print("Error loading vehicle data: $e");
  }
}

Future<void> fetchJobcards() async {
  try {
    final fetchedJobcards = await ApiVehicleMakeRepository().get_vehiclemake();
    setState(() {
      vamnes = fetchedJobcards;  
      Vmake = fetchedJobcards
          .map<String>((jobcard) => jobcard['VehicleName'].toString()) 
          .toList();  
    });
  } catch (e) {
    setState(() {
      Fluttertoast.showToast(msg: 'Failed to fetch jobcards: $e');
    });
  }
}
  
  void onJobcardSelected(String jobcardNo) {
  final selectedJobcard = vamnes.firstWhere(
    (jobcard) => jobcard['VehicleName'] == jobcardNo,
    orElse: () => <String, dynamic>{},
  );

  if (selectedJobcard.isNotEmpty) {
   
  } else {
    setState(() {
      Fluttertoast.showToast(msg: 'VehicleName not found');
    });
  }
}

Future<void> _deletevehicleModel(int id) async {
    await _apiDeleteModel.deleteModel(id);
    setState(() {
      filteredVehicleList.removeWhere((jobcard) => jobcard['siNo'] == id);
    });
  }

  final TextEditingController _filterController = TextEditingController();
  



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
                    onPressed: () {
                      _showFilterBottomSheet(context);
                    },
                    icon: Icon(Icons.filter_list_alt, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: jobcards, 
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (snapshot.hasData) {
                  Future<void> _loadVehicleData() async {
  try {
    final data = await _apiModelRepository.get_vehiclemodel();
    setState(() {
      vehicleList = List<Map<String, dynamic>>.from(data);
      filteredVehicleList = List.from(vehicleList); // Initialize filtered list
    });
  } catch (e) {
    print("Error loading vehicle data: $e");
  }
}

                  return  ListView.separated(
                itemCount: filteredVehicleList.length,
                itemBuilder: (BuildContext context, int index) {
                  int sn = index + 1;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Container(
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
                                  Text(" $sn",style: getFonts(16, Colors.black)),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(filteredVehicleList[index]["modeletitle"]??"", style: getFonts(16, Colors.black)),
                                      Text(filteredVehicleList[index]["modalsubtitle"]?? "", style: TextStyle(color: Colors.black,)),
                                    ],
                                  ),
                                ],
                              ),
                              PopupMenuButton<String>(
                                color: Appcolors().scafoldcolor,
                                onSelected: (value) {
                                   if (value == 'Edit') {
                                     adaPopup(title:filteredVehicleList[index]["modeletitle"],subtitle: filteredVehicleList[index]["modalsubtitle"],
                                                 id:filteredVehicleList[index]["ID"] );  
                                        } else if (value == 'Delete') {
                                        _deletevehicleModel(filteredVehicleList[index]["ID"]);
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
                    ),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: 15),
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

 adaPopup({String? title, String? subtitle, int? id}) {
  if (title != null && subtitle != null && id != null) {
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
                          Text(_selectedSiNo == null ? "Enter Details" : "Edit Details", style: getFonts(18, Colors.black)),
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.close),
                          ),
                        ],
                      ),
                    ),
                    // Title field
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
                    // Subtitle (vehicle name) field with autocomplete
                    Container(
                      width: 290,
                      height: 58,
                      decoration: BoxDecoration(
                        border: Border.all(color: Appcolors().maincolor),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: EasyAutocomplete(
                        controller: _subtitleController,
                        suggestions: vamnes
                            .map((jobcard) => jobcard['VehicleName'].toString())
                            .toList(),
                        onSubmitted: (value) {
                          onJobcardSelected(value);  // Handle selection
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    GestureDetector(
                      onTap: () async {
                          submitModel();
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
                Expanded(
                  child: RadioListTile<String>(
                    title: Text('Model'),
                    value: 'Model',
                    groupValue: filterCriteria,
                    onChanged: (value) {
                      setState(() {
                        filterCriteria = value!;
                        _filterController.clear(); // Clear the filter input
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: Text('Make'),
                    value: 'Make',
                    groupValue: filterCriteria,
                    onChanged: (value) {
                      setState(() {
                        filterCriteria = value!;
                        _filterController.clear(); // Clear the filter input
                      });
                    },
                  ),
                ),
              ],
            ),
            TextField(
              controller: _filterController,
              decoration: InputDecoration(
                hintText: 'Enter ${filterCriteria == 'Model' ? 'model' : 'make'}...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context); // Close the BottomSheet
                  _applyFilter();
                },
                child: Container(
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Appcolors().maincolor,
                  ),
                  child: Center(
                    child: Text("Apply", style: getFonts(14, Colors.white)),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}


}
