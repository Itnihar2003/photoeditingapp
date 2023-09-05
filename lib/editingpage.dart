// import 'dart:html';

// import 'dart:html';

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:photoeditingapp/editpage.dart';
import 'package:photoeditingapp/homepage.dart';
import 'package:photoeditingapp/savepage.dart';
import 'package:text_editor/text_editor.dart';
import 'package:uuid/uuid.dart';

class editingpage extends StatefulWidget {
  editingpage({
    super.key,
    this.url2,
    this.text2,
    required this.image,
    required this.collect,
  });
  final String? collect;
  final url2;
  final text2;
  final image;

  @override
  State<editingpage> createState() => _editingpageState();
}

class _editingpageState extends State<editingpage> {
  // void save2() async {

  save2() {
    setState(() {
      FirebaseFirestore.instance
          .collection(widget.collect!)
          .doc(widget.text2)
          .update({"edit": true});
    });
  }

  @override
  Widget build(BuildContext context) {
    int i;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                save2();

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => savepage(
                              email2: widget.collect!,
                              text3: widget.text2,
                            )));
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
                    builder: (context) => homepage(
                      email: FirebaseAuth.instance.currentUser!.email,
                    ),
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
          onPressed: () {
            Navigator.pop(context);
            FirebaseFirestore.instance
                .collection(widget.collect!)
                .doc(widget.text2)
                .delete();
          },
        ),
        GButton(
          text: "edit",
          icon: Icons.edit,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => editpage(
                    url3: widget.image,
                  ),
                ));
          },
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
