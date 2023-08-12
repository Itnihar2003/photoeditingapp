// import 'dart:html';

// import 'dart:html';

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:photoeditingapp/homepage.dart';
import 'package:photoeditingapp/savepage.dart';
import 'package:uuid/uuid.dart';

class editingpage extends StatelessWidget {
  editingpage(
      {super.key, this.url2, this.text2, required this.image, this.collect});
  final collect;
  final url2;
  final text2;
  final image;
  void save2() async {
    // UploadTask uploadTask = FirebaseStorage.instance
    //     .ref()
    //     .child("editfile")
    //     .child(Uuid().v1())
    //     .putFile(image);
    // TaskSnapshot taskSnapshot = await uploadTask;
    // String url3 = await taskSnapshot.ref.getDownloadURL();
    Map<String, dynamic> editdata = {"editimage": image};
    FirebaseFirestore.instance.collection("editimage").add(editdata);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                save2();

                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => savepage()));
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
              text2,
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
              child: Image.network(url2),
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
            FirebaseFirestore.instance.collection(collect).doc(text2).delete();
          },
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
