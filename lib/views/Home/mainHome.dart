import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sher_mech/utility/colorss.dart';
import 'package:sher_mech/utility/drawer.dart';
import 'package:sher_mech/utility/font.dart';
import 'package:sher_mech/views/Dashboard.dart';
import 'package:sher_mech/views/Home/jobcards.dart';
import 'package:sher_mech/views/Home/newjobcard.dart';
import 'package:sher_mech/views/jobcard_bill.dart';
import 'package:sher_mech/views/jobcardreport.dart';
import 'package:sher_mech/views/vehiclemake.dart';
import 'package:sher_mech/views/vehiclemodal.dart';

class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  var Names = [
    "NEW JOBCARD",
    "JOBCARD LIST",
    "JOBCARD BILL",   
    "JOB SPARE RATES",
    "REPORT & SEARCH",
    "CUSTOMERS",
    "SETTINGS",
    "SPARE INVENTORY",
    "ANALYTICS",
    "SMS",
    "WHATSAPP",
    "ABOUT"
  ];

  var images = [
    "assets/images/access-card (2).png",
    "assets/images/to-do-list (1).png",
    "assets/images/payment (1).png",
    "assets/images/wrench (1).png",
    "assets/images/business-report.png",
    "assets/images/team (1).png",
    "assets/images/setting (1).png",
    "assets/images/inventory (2).png",
    "assets/images/dashboard (1).png",
    "assets/images/email.png",
    "assets/images/whatsapp (2).png",
    "assets/images/information.png"
  ];

  final List<String> _locations = ['Vehicle Modal', 'Vehicle Make'];
  String? _selectedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors().scafoldcolor,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Appcolors().maincolor,
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
        title: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text("SherMech", style: appbarFonts(18, Colors.white)),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: IconButton(
              onPressed: () {},
              icon: FaIcon(FontAwesomeIcons.user, color: Colors.white),
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            crossAxisCount: 2,
          ),
          itemCount: Names.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                if (index == 0) {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => Newjobcard()));
                } else if (index == 1) {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => Jobcards()));
                }else if(index==2){
                   Navigator.push(context, MaterialPageRoute(builder: (_) => JobcardBill()));
                }
              },
              child: Container(
                width: 167,
                height: 138,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Color(0xFF0008B4)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        height: 77,
                        width: 77,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(42),
                          color: Appcolors().maincolor
                        ),
                        child: Image.asset(images[index],scale: 1.5, 
                        //fit: BoxFit.cover
                        ),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      Names[index],
                      style: getFonts(15, Colors.black),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
