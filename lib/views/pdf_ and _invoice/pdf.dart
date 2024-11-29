import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';  // Add this to get application documents directory
import 'package:sher_mech/utility/colorss.dart';
import 'package:sher_mech/utility/font.dart';

class PDFScreen extends StatefulWidget {
  final String path;

  PDFScreen({required this.path});

  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  late PDFViewController _pdfViewController; // Declare the controller
  int? _totalPages = 0;
  int _currentPage = 0;

  // Function to download the PDF
  Future<void> _downloadPDF() async {
    try {
      // Get the application's document directory
      final directory = await getApplicationDocumentsDirectory();
      
      // Define the path for the new file
      final String newFilePath = "${directory.path}/downloaded_report.pdf";
      
      // Get the original file from widget.path and copy it to the new path
      final File originalFile = File(widget.path);
      
      // Check if the original file exists
      if (await originalFile.exists()) {
        await originalFile.copy(newFilePath);
        Fluttertoast.showToast(msg: "PDF downloaded successfully!");

        // Optionally, you can navigate to the downloaded file or show a message
        print("File saved to: $newFilePath");
      } else {
        Fluttertoast.showToast(msg: "File not found.");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error saving the file: $e");
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
              // Initialize the controller here
              _pdfViewController = pdfViewController;
            },
          ),
          _totalPages == 0
              ? Center(child: CircularProgressIndicator())
              : Container(),
        ],
      ),
      floatingActionButton: _totalPages != 0
          ? FloatingActionButton.extended(
              label: Text(
                "Download",
                style: getFonts(14, Colors.white),
              ),
              backgroundColor: Appcolors().maincolor,
              onPressed: () {
                _pdfViewController.setPage(_totalPages! ~/ 2);  // Now this should work
                _downloadPDF();  // Call the download function
              },
            )
          : Container(),
    );
  }
}
