import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ViewPdf extends StatefulWidget {
  final String url;
  final String name;
  ViewPdf(this.url,this.name);
  @override
  _ViewPdfState createState() => _ViewPdfState(this.url,this.name);
}

class _ViewPdfState extends State<ViewPdf> {
  final String url;
  final String name;
  _ViewPdfState(this.url,this.name);

  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: SfPdfViewer.network(
        url,
        key: _pdfViewerKey,
      ),
    );
  }
}
