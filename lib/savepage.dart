import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:photoeditingapp/editingpage.dart';
import 'package:photoeditingapp/homepage.dart';
import 'package:uuid/uuid.dart';

class savepage extends StatelessWidget {
  final email2;
  savepage({
    super.key,
    this.email2,
  });

  delete(id) {
     
      FirebaseFirestore.instance.collection("editimage").doc(id).delete();
    
  }

  // final savedimage1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => homepage(
                              email: FirebaseAuth.instance.currentUser!.email,
                            )));
              },
              icon: Icon(Icons.arrow_back))
        ],
        backgroundColor: Colors.transparent,
        title: Text(
          "save list",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection("editimage").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                height: 5000,
                child: Container(
                  color: Colors.transparent,
                  width: 3000,
                  height: 240,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      Map<String, dynamic> imagedata =
                          snapshot.data!.docs[index].data()
                              as Map<String, dynamic>;
                      return Container(
                        width: 200,
                        height: 200,

                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 200,
                                width: 200,
                                child: Image.network(
                                  imagedata["editimage"],
                                 
                                ),
                              ),
                            ),
                            Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  child: IconButton(
                                      onPressed: () =>
                                          delete(snapshot.data!.docs[index].id),
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                        size: 30,
                                      )),
                                ))
                          ],
                        ),

                        // child: Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: Image.network(
                        //     imagedata["editimage"],
                        //     fit: BoxFit.fill,
                        //   ),
                        // ),
                      );
                    },
                  ),
                ),
              );
            } else {
              return Text("nodata");
            }
          },
        ),
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Colors.red,
          Colors.black,
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      ),
    );
  }
}
