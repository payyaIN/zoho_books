import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:payzo_books/import_data.dart';

class BillPreviewScreen extends StatelessWidget {
  final String htmlData;

  const BillPreviewScreen({super.key, required this.htmlData});

  @override
  Widget build(BuildContext context) {
    return ScalingFactor(
      child: Scaffold(
        appBar: AppBar(title: const Text("Bill Preview")),
        body: SingleChildScrollView(
          child: Html(data: htmlData),
        ),
      ),
    );
  }
}
