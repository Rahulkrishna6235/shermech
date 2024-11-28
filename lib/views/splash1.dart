import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sher_mech/utility/colorss.dart';
import 'package:sher_mech/views/splash.dart';

class Splash1 extends StatefulWidget {
  const Splash1({super.key});

  @override
  State<Splash1> createState() => _Splash1State();
}

class _Splash1State extends State<Splash1> {
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Splash()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors().scafoldcolor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
           
            if (Platform.isAndroid)
              const CupertinoActivityIndicator(
                color: Color.fromARGB(255, 44, 22, 241),
                radius: 20,
              )
            else
              const CircularProgressIndicator(
                color: Color.fromARGB(255, 44, 22, 241),
              )
          ],
        ),
      ),
    );
  }
}