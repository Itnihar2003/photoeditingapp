import 'dart:html';

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:photoeditingapp/homepage.dart';
import 'package:photoeditingapp/savepage.dart';

class editingpage extends StatefulWidget {
  editingpage({super.key, this.url2, this.text2});
  final url2;
  final text2;

  @override
  State<editingpage> createState() => _editingpageState();
}

class _editingpageState extends State<editingpage> {
  // List emptylist1 = [];

  // void save1() {
  //   emptylist1.add(widget.url2);
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                // save1();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => savepage(),
                    ));
              },
              icon: Icon(
                Icons.save,
                color: Colors.white,
                size: 25,
              ))
        ],
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => homepage(),
                  ));
            },
            icon: Icon(
              Icons.backspace,
              color: Colors.white,
              size: 25,
            )),
        backgroundColor: Colors.transparent,
        title: Text(
          "Editing page",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.text2,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.network(widget.url2),
            ),
          ],
        ),
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Colors.red,
          Colors.black,
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      ),
      bottomNavigationBar: GNav(tabs: [
        GButton(
          text: "delete",
          icon: Icons.delete,
          onPressed: () {},
        ),
        GButton(
          text: "edit",
          icon: Icons.edit,
          onPressed: () {},
        ),
        GButton(
          text: "crop",
          icon: Icons.crop,
          onPressed: () {},
        )
      ]),
    );
  }
}
