import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle getFonts (double fontsize,Color color){
  return GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: fontsize ,color:color );
}
TextStyle appbarFonts (double fontsize,Color color){
  return GoogleFonts.poppins(fontWeight: FontWeight.w700,fontSize: fontsize ,color:color );
}
TextStyle DrewerFonts (){
  return GoogleFonts.nunitoSans(fontWeight: FontWeight.w700,fontSize: 14 ,color:Colors.black );
}