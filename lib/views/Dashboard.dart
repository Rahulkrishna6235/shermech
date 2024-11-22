import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sher_mech/utility/colorss.dart';
import 'package:sher_mech/utility/font.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _names = ["Total Vehicles", "Ready For Delivery", "Service Vehicles", "Pending Vehicles"];
  final _data = ["24", "25", "25", "44"];
  final _assetImages = [
    "assets/images/car.png",
    "assets/images/finished-work.png",
    "assets/images/maintenance (1) 1.png",
    "assets/images/maintenance.png",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: const Color(0xFF0008B4),
        title: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text("DASHBOARD", style: appbarFonts(18, Colors.white)),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Container(
            child: Image.asset("assets/images/Menu (2).png", scale: 1.8),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 20,
                    height: 22,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Center(
                      child: Icon(Icons.add, color: Colors.white, size: 17),
                    ),
                  ),
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
      body: Column(
        children: [
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _container(_names[0], _data[0], _assetImages[0]),
              _container(_names[1], _data[1], _assetImages[1]),
            ],
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _container(_names[2], _data[2], _assetImages[2]),
              _container(_names[3], _data[3], _assetImages[3]),
            ],
          ),
          SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Vehicle List", style: getFonts(15, Colors.black)),
                IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.search, color: Colors.black, size: 16)),
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: ListView.separated(
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Container(
                        width: 358,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Appcolors().scafoldcolor,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(width: 5),
                                    Container(
                                      width: 17,
                                      height: 17,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          color: Colors.green),
                                    ),
                                    SizedBox(width: 5),
                                    Text("KL5666"),
                                  ],
                                ),
                                PopupMenuButton<String>(
                                  color: Appcolors().scafoldcolor,
                                  onSelected: (value) {
                                    if (value == 'Edit') {
                                    } else if (value == 'Delete') {}
                                  },
                                  itemBuilder: (BuildContext context) => [
                                    const PopupMenuItem(
                                        value: 'Edit', child: Text('Edit')),
                                    const PopupMenuItem(
                                        value: 'Delete', child: Text('Delete')),
                                  ],
                                  icon: Icon(Icons.more_horiz, color: Colors.black),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 250),
                              child: Text("yamaha :"),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 30, right: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("JCNO :"),
                                  Container(
                                    width: 104,
                                    height: 23,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: Colors.green,
                                    ),
                                    child: Center(
                                        child: Text("Delivary",
                                            style: getFonts(12, Colors.white))),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.only(left: 30, right: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Name", style: getFonts(12, Colors.black)),
                                  Text("Arival Date",
                                      style: getFonts(12, Colors.black)),
                                  Text("Delivary Date",
                                      style: getFonts(12, Colors.black))
                                ],
                              ),
                            ),
                            SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.only(left: 30, right: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Name", style: getFonts(12, Colors.black)),
                                  Text("Arival Date",
                                      style: getFonts(12, Colors.black)),
                                  Text("Delivary Date",
                                      style: getFonts(12, Colors.black))
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 15),
                  itemCount: 2),
            ),
          )
        ],
      ),
    );
  }

  Widget _container(String title, String data, String imagePath) {
    return Container(
      width: 171,
      height: 74,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
              Image.asset(imagePath, width: 30, height: 30), // Correctly display image
            ],
          ),
          
          Text(
            data,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
