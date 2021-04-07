import 'package:flutter/material.dart';
import 'package:rideon_driver/models/profile/documentModel.dart';

class AddFileScreen extends StatefulWidget {
  final Document document;
  AddFileScreen(this.document);
  @override
  _AddFileScreenState createState() => _AddFileScreenState();
}

class _AddFileScreenState extends State<AddFileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text(widget.document.title)),
      body: SingleChildScrollView(child: Column(children: [

        if(widget.document.subtitle != null)Text(widget.document.subtitle),
        if(widget.document.detail != null)Text(widget.document.detail),
        Icon(Icons.camera_roll)



      ])),
    );
  }
}
