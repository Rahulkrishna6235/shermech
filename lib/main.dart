import 'package:flutter/material.dart';
import 'package:sher_mech/views/Dashboard.dart';
import 'package:sher_mech/views/Home/mainHome.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainHome(),
    );
  }
}

