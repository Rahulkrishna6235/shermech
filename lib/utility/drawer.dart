import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:sher_mech/utility/colorss.dart';
import 'package:sher_mech/utility/font.dart';
import 'package:sher_mech/views/Home/jobcards.dart';
import 'package:sher_mech/views/jobcard_bill.dart';
import 'package:sher_mech/views/jobcard_performa.dart';
import 'package:sher_mech/views/jobcardreport.dart';
import 'package:sher_mech/views/vehiclemake.dart';
import 'package:sher_mech/views/vehiclemodal.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
bool _isExpanded = false;
bool isexpand=false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Appcolors().Scfold,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 111,
            color: Appcolors().maincolor,
          ),
           Padding(
             padding: const EdgeInsets.only(top: 10,left: 17),
             child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
             Padding(
               padding: const EdgeInsets.symmetric(horizontal: 9),
               child: Text("MASTERS", style: DrewerFonts()),
             ),
              IconButton(
                icon: Icon(
                  _isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded; 
                  });
                },
              ),
                       ],
                     ),
           ),
        if (_isExpanded) 
          Row(
            children: [
              Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Container(
                                width: 2, // Width of the divider
                                height: 80, // Total height covering both ListTiles
                                color: Appcolors().maincolor, // Divider color
                              ),
                    ),
              Column(
                children: [
                  
                  TextButton(onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (_) => Vehiclemodal(vehicleData: [],)));

                  }, child: Text("VEHICLE MODEL", style: drewerFonts())),
                  TextButton(onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (_) => VehicleMake()));

                  }, child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text("VEHICLE MAKE", style: drewerFonts()),
                  )),
                ],
              ),
            ],
          ),
          
          Padding(
            padding: const EdgeInsets.only(left: 9),
            child: ListTile(
              title: Text("CAMPAIGNS", style: DrewerFonts()),
              onTap: () {
              },
            ),
          ),
           Padding(
             padding: const EdgeInsets.only(left: 17),
             child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
             Padding(
               padding: const EdgeInsets.symmetric(horizontal: 9),
               child: Text("JOB CARDS", style: DrewerFonts()),
             ),
              IconButton(
                icon: Icon(
                  isexpand ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    isexpand = !isexpand; 
                  });
                },
              ),
                       ],
                     ),
           ),
        if (isexpand) 
          Row(
            children: [
              Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Container(
                                width: 2, // Width of the divider
                                height: 80, // Total height covering both ListTiles
                                color: Appcolors().maincolor, // Divider color
                              ),
                    ),
              Column(
                children: [
                  
                  TextButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_) => Performa_invoice()));

                  }, child: Text("PERFORMA INVOICE", style: drewerFonts())),
                  TextButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_) => JobcardBill()));

                  }, child: Padding(
                    padding: const EdgeInsets.only(right: 40),
                    child: Text("JOBCARD BILL", style: drewerFonts()),
                  )),
                ],
              ),
            ],
          ),
        
          Padding(
            padding: const EdgeInsets.only(left: 9),
            child: ListTile(
              title: Text("REPORTS", style: DrewerFonts()),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => Jobcardreport()));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 9),
            child: ListTile(
              title: Text("TODAY REPORT", style: DrewerFonts()),
              onTap: () {
                // Add any action you need
              },
            ),
          ),
        
         
        ],
      ),
    );
  }
}
