import 'package:flutter/material.dart';
import 'package:sher_mech/utility/font.dart';
import 'package:sher_mech/views/Home/mainHome.dart';
import 'package:sher_mech/views/login.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MainHome()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
          Color(0xFF0616BA),
        Color(0xFF387FE9),])
      ),
      child: Column(
  mainAxisAlignment: MainAxisAlignment.center, 
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    SizedBox(height: 300,),
    Center(
      child: Text(
        "SherMech", 
        style: splashFonts(),
      ),
    ),
    Expanded(
      child: Align(
        alignment: Alignment.bottomCenter, 
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [
            Text(
              "Powered By Shersoft", 
              style: splash2Fonts(),
            ),
          ],
        ),
      ),
    ),
    SizedBox(height: 20,)
  ],
)

      ),
    );
  }

}