import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';  
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

  // Function to download the PDF
  Future<void> _downloadPDF() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final String newFilePath = "${directory.path}/downloaded_report.pdf";
      
      final File originalFile = File(widget.path);
      if (await originalFile.exists()) {
        await originalFile.copy(newFilePath);  // Copy the file to app's directory
        Fluttertoast.showToast(msg: "PDF downloaded successfully!");
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
    // Use the file path that was passed to this widget
    final String filePath = widget.path;
    final File file = File(filePath);
    
    if (await file.exists()) {
      // Create an XFile from the file path
      //XFile xFile = XFile(filePath);
      
      // Share the file using the share_plus package
      //await Share.shareXFiles([xFile], text: 'Check out this PDF!');
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
          ? Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Download button
                FloatingActionButton.extended(
                  label: Text(
                    "Download",
                    style: getFonts(14, Colors.white),
                  ),
                  backgroundColor: Appcolors().maincolor,
                  onPressed: () {
                    _pdfViewController.setPage(_totalPages! ~/ 2);  // Optionally set the page to the middle
                    _downloadPDF();  // Call the download function
                  },
                ),
                SizedBox(height: 10),
                // Share button
                FloatingActionButton.extended(
                  label: Text(
                    "Share",
                    style: getFonts(14, Colors.white),
                  ),
                  backgroundColor: Appcolors().maincolor,
                  onPressed: _sharePDF,  // Call the share function
                ),
              ],
            )
          : Container(),
    );
  }
}
