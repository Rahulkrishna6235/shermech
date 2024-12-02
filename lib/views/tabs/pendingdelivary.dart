import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sher_mech/utility/colorss.dart';
import 'package:sher_mech/utility/font.dart';

class PEndingDelivary extends StatefulWidget {
  const PEndingDelivary({super.key});

  @override
  State<PEndingDelivary> createState() => _PEndingDelivaryState();
}

class _PEndingDelivaryState extends State<PEndingDelivary> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors().scafoldcolor,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Appcolors().maincolor,
      leading: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios_new_sharp,color: Colors.white,size: 15,)),
      ),
        title: Center(child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text("PENDING DELIVARY",style: appbarFonts(18, Colors.white),),
        )),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: IconButton(onPressed: (){},  icon: FaIcon(FontAwesomeIcons.user,color: Colors.white,size: 17,)),
          )
        ],
      ),
      floatingActionButton: GestureDetector(
        onTap: (){},
        child: Container(
          width: 50,height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Appcolors().maincolor,
          ),
          child: Center(child: Icon(Icons.add)),
        ),
      ),
    );
  }
}