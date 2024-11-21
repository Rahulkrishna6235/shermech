import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sher_mech/utility/colorss.dart';
import 'package:sher_mech/utility/drawer.dart';
import 'package:sher_mech/utility/font.dart';

class JobcardBill extends StatefulWidget {
  const JobcardBill({super.key});

  @override
  State<JobcardBill> createState() => _JobcardBillState();
}

class _JobcardBillState extends State<JobcardBill> {
 final TextEditingController _jobcardnoController=TextEditingController();
  final TextEditingController _closingdateController=TextEditingController();
 final TextEditingController _jobcard_dateController=TextEditingController();
 final TextEditingController _registernoController=TextEditingController();
 final TextEditingController _modalController=TextEditingController();
 final TextEditingController _makeController=TextEditingController();
 final TextEditingController _machanicController=TextEditingController();
 final TextEditingController _kvmcoverController=TextEditingController();
 final TextEditingController _jc_startnoController=TextEditingController();
 final TextEditingController _jc_finishController=TextEditingController();


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
        title: Center(child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text("NEW JOB CARD",style: appbarFonts(18, Colors.white),),
        )),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: IconButton(onPressed: (){},  icon: FaIcon(FontAwesomeIcons.user,color: Colors.white,)),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Container(
                      height: 39,
                      width: 358,
                      decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white, 
              border: Border.all(color: Appcolors().searchTextcolor)
                      ),
                      child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0), 
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Icon(Icons.search, color: Colors.grey,size: 17,),
                  ),
                  SizedBox(width: 5), 
                  Expanded( 
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search",
                        hintStyle: getFonts(13, Appcolors().searchTextcolor),
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
 Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                        
                        _newBillShortfield("jobcard No", _jobcardnoController),
                         Container(
           
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                  
                  Text("Expected Date",style: getFonts(16, Colors.black),),
                  Text("*",style: TextStyle(fontSize: 16,color: Color(0xFFE22E37)),)
                ],),
               Container(
          height: 45,
                        width: 171,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
          child: TextField(
            onTap: () async {
              DateTime? selectedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900), 
                lastDate: DateTime(2100), 
              );
              if (selectedDate != null) {
                String formattedDate = DateFormat('MM/dd/yyyy').format(selectedDate);
                
                _jobcard_dateController.text = formattedDate;
              }
            },
            controller: _jobcard_dateController,
            readOnly: true, 
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(color: Appcolors().searchTextcolor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(color: Appcolors().searchTextcolor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(color: Appcolors().searchTextcolor),
              ),
              hintStyle: TextStyle(color: Appcolors().searchTextcolor),
              hintText: "Select Date",
            ),
            autofocus: true,
          ),
        ),
              ],
            ),
          )
                       ],) ,
          ],
        ),
      ),
    );
  }

  Widget _Botton (String Txt){
  return GestureDetector(
                  onTap: (){
                    
                  },
                  child: Container(
                    height: 44,width: 171,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                       color: Color(0xFF0A1EBE), 
                    ),
                    child: Center(child: Text(Txt,style: getFonts(12, Colors.white)),
                   ) ),
                );
}

   Widget _newBillShortfield (String textrow,TextEditingController controller){
    return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                  
                  Text(textrow,style: getFonts(16, Colors.black),),
                  Text("*",style: TextStyle(fontSize: 16,color: Color(0xFFE22E37)),)
                ],),
                Container(
                        height: 45,
                        width: 171,
                        decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white, 
                border: Border.all(color: Appcolors().searchTextcolor)
                        ),
                        child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0), 
                child: Row(
                  children: [
                    SizedBox(width: 5), 
                    Expanded( 
                      child: TextFormField(
                        controller: controller,
                         validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter $textrow';
                        }
                        return null;
                      },
                        obscureText: false,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(bottom: 12), 
                        ),
                      ),
                    ),
                  ],
                ),
                        ),
                      ),
              ],
            ),
          );
  }
}