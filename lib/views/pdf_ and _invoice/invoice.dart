import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:sher_mech/utility/colorss.dart';
import 'package:sher_mech/utility/font.dart';
import 'package:sher_mech/views/Home/mainHome.dart';


class InvoiceScreen extends StatefulWidget {
  final String path;

  InvoiceScreen({required this.path});

  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<InvoiceScreen> {
  late PDFViewController _pdfViewController;
  int? _totalPages = 0;
  int _currentPage = 0;

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
          Navigator.push(context, MaterialPageRoute(builder: (_) => MainHome()));
        }, icon: Icon(Icons.arrow_back_ios_new_sharp,color: Colors.white,size: 15,)),
      ),
        title: Padding(
          padding: const EdgeInsets.only(top: 20,right: 35),
          child: Center(child: Text('INVOICE',style: appbarFonts(18,Colors.white),)),
        ),
      ),
      body: Stack(
        children: [
          PDFView(
            filePath: widget.path,
            autoSpacing: true,
            swipeHorizontal: true,
            onRender: (pages) {
              setState(() {
                _totalPages = pages;
              });
            },
            onPageChanged: (int? page, int? total) {
              setState(() {
                _currentPage = page!;
              });
            },
            onError: (error) {
              print(error.toString());
            },
            onPageError: (page, error) {
              print('Page $page error: $error');
            },
          ),
          _totalPages == 0
              ? Center(child: CircularProgressIndicator())
              : Container(),
        ],
      ),
      floatingActionButton: _totalPages != 0
          ? FloatingActionButton.extended(
              label: Text("Print ",style: getFonts(14, Colors.white),),
              backgroundColor: Appcolors().maincolor,
              onPressed: () {
                _pdfViewController.setPage(_totalPages! ~/ 2);
              },
            )
          : Container(),
    );
  }
}
