import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';  
//import 'package:share_plus/share_plus.dart';  // Import the share_plus package
import 'package:sher_mech/utility/colorss.dart';
import 'package:sher_mech/utility/font.dart';

class PDFScreen extends StatefulWidget {
  final String path;

  PDFScreen({required this.path});

  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  late PDFViewController _pdfViewController; 
  int? _totalPages = 0;
  int _currentPage = 0;

  Future<void> _requestPermission() async {
    PermissionStatus status = await Permission.storage.request();
    if (status.isGranted) {
      print("Permission granted");
    } else {
      Fluttertoast.showToast(msg: "Permission denied");
    }
  }
  Future<void> _downloadPDF() async {
    try {
      await _requestPermission();
      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download'); 
      } else {
        directory = await getExternalStorageDirectory();
      }

      final String newFilePath = "${directory!.path}/downloaded_report.pdf";

      final File originalFile = File(widget.path);
      if (await originalFile.exists()) {
        await originalFile.copy(newFilePath);  // 
        Fluttertoast.showToast(msg: "PDF downloaded successfully");
        print("File saved to: $newFilePath");
      } else {
        Fluttertoast.showToast(msg: "File not found.");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error saving the file: $e");
    }
  }
Future<void> _sharePDF() async {
  try {
    final String filePath = widget.path;  // Path to the PDF file
    final File file = File(filePath);     // Create a File object
    
    // Check if the file exists
    if (await file.exists()) {
      // Create an XFile from the file path
      XFile xFile = XFile(filePath);
      
      // Share the file using the share_plus package
      await Share.shareXFiles([xFile], text: 'Check out this PDF!');
    } else {
      Fluttertoast.showToast(msg: "File not found for sharing.");
    }
  } catch (e) {
    Fluttertoast.showToast(msg: "Error sharing the file: $e");
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Appcolors().maincolor,
        leading: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_new_sharp, color: Colors.white, size: 15),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 20, right: 35),
          child: Center(child: Text('REPORT', style: appbarFonts(18, Colors.white))),
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
            onViewCreated: (PDFViewController pdfViewController) {
              _pdfViewController = pdfViewController;
            },
          ),
          _totalPages == 0
              ? Center(child: CircularProgressIndicator())
              : Container(),
        ],
        
      ),
      floatingActionButton: _totalPages != 0
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 40,
                  child: FloatingActionButton.extended(
                    extendedPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    label: Text(
                      "Download",
                      style: getFonts(12, Colors.white),
                    ),
                    backgroundColor: Appcolors().maincolor,
                    onPressed: () {
                      _pdfViewController.setPage(_totalPages! ~/ 2);  
                      _downloadPDF();  
                    },
                  ),
                ),
                SizedBox(width: 10),
                Container(height: 40,
                  child: FloatingActionButton.extended(
                    label: Text(
                      "Share",
                      style: getFonts(12, Colors.white),
                    ),
                    backgroundColor: Appcolors().maincolor,
                    onPressed: _sharePDF,  
                  ),
                ),
              ],
            )
          : Container(),
    );
  }
}