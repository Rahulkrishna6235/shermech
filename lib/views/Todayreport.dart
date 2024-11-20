import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class _TodayReporState extends StatefulWidget {
  const _TodayReporState({super.key});

  @override
  State<_TodayReporState> createState() => __TodayReporStateState();
}

class __TodayReporStateState extends State<_TodayReporState> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        toolbarHeight: 80,
                backgroundColor: Color(0xFF0008B4),
        title: 
        Center(child: Text("JOBCARDS",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700,color: Colors.white))),
        leading: IconButton(onPressed: (){}, 
        icon: Icon(Icons.menu_rounded,color: Colors.white,)),
       
        actions: [
          Row(children: [
            Container(
              width: 20,height: 22,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.white,width: 2)
              ),
              child: Center(child: Icon(Icons.add,color: Colors.white,size: 17,)),
            ),
          IconButton(onPressed: (){},  icon: FaIcon(FontAwesomeIcons.user,color: Colors.white,))
          ],)
        ],
      ),
      body: Column(children: [
        Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 175,height: 33,
                   
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  color:Color(0xFF0008B4),
                  ),
                  child: Center(child: 
                  Text("PENDING JOBCARDS",style: TextStyle(color: Colors.white),),),
                ),
                Container(
                  width: 175,height: 33,
                   
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  color:Colors.white,
                  ),
                  child: Center(child: 
                  Text("PENDING DELIVARY"),),
                ),
              ],
            ),
          ),
      ],),
    );
  }
}