import 'package:flutter/material.dart';
import 'package:sher_mech/utility/colorss.dart';
import 'package:sher_mech/utility/font.dart';
import 'package:sher_mech/views/Home/jobcards.dart';
import 'package:sher_mech/views/jobcard_bill.dart';
import 'package:sher_mech/views/jobcard_performa.dart';
import 'package:sher_mech/views/jobcardreport.dart';
import 'package:sher_mech/views/vehiclemake.dart';
import 'package:sher_mech/views/vehiclemodal.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

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
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: const [
                SizedBox(width: 10),
              ],
            ),
          ),
           Padding(
            padding: const EdgeInsets.only(left: 9),
            child: ExpansionTile(
              
              title: Text("MASTERS", style: DrewerFonts()),
              
              children: [

                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 28),
                      child: Container(
                                width: 2, // Width of the divider
                                height: 90, // Total height covering both ListTiles
                                color: Appcolors().maincolor, // Divider color
                              ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          ListTile(
                                        title: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text("Vehicle Modal", style: DrewerFonts()),
                                        ),
                                        onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => Vehiclemodal(vehicleData: [],)));
                                        },
                                      ),
                                      ListTile(
                                        title: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text("Vehicle Make", style: DrewerFonts()),
                                        ),
                                        onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => VehicleMake()));
                                        },
                                      ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 9),
            child: ListTile(
              title: Text("CAMPAIGNS", style: DrewerFonts()),
              onTap: () {
                // Handle navigation or actions here
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 9),
            child: ExpansionTile(
              
              childrenPadding: EdgeInsets.zero,
              title: Text("JOB CARD", style: DrewerFonts()),
              
              children: [
              
                ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text("PERFORMA INVOICE", style: DrewerFonts()),
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => Performa_invoice()));
                  },
                ),
                ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text("JOBCARD BILL", style: DrewerFonts()),
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => JobcardBill()));
                  },
                ),
              ],
            ),
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
