import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:photoeditingapp/editingpage.dart';
import 'package:text_editor/text_editor.dart';

class editpage extends StatefulWidget {
  editpage({super.key, this.url3});
  final url3;
  @override
  State<editpage> createState() => _editpageState();
}

class _editpageState extends State<editpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      // appBar: AppBar(title: Text("Edit page"),),
      body: Stack(alignment: Alignment.center, children: [
        Center(child: Image.network(widget.url3)),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: TextEditor(
                fonts: [
                  'OpenSans',
                  'Billabong',
                  'GrandHotel',
                  'Oswald',
                  'Quicksand',
                  'Beautifulpeople'
                ],
                onEditCompleted: (style, alling, text) {
                  style = TextStyle(fontSize: 35, fontWeight: FontWeight.bold);
                  alling = TextAlign.center;
                  text = "sample text";
                }),
          ),
        ),
      ]),
    );
  }
}
