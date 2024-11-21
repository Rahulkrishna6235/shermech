import 'dart:io';

import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';

class PDFViewerScreen extends StatelessWidget {
  final String path;

  PDFViewerScreen({required this.path});

  @override
  Widget build(BuildContext context) {
    File file  = File(path);
    PDFDocument doc =  PDFDocument.fromFile(file) as PDFDocument;
    return Scaffold(
      
      body: PDFViewer(
        document: doc,
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.share,
            size: 30,
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          onPressed: ()async {
          //  await Share.shareXFiles([XFile(path)], text: 'Financial Report');
          }),
    );
  }
}


