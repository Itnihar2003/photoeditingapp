import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:photoeditingapp/editingpage.dart';

import 'package:photoeditingapp/homepage.dart';
import 'package:uuid/uuid.dart';

class savepage extends StatefulWidget {
  final text3;
  final String email2;
  savepage({
    super.key,
    required this.email2,
    this.text3,
  });

  @override
  State<savepage> createState() => _savepageState();
}

class _savepageState extends State<savepage> {
  List savelist = [];

  @override
  Widget build(BuildContext context) {
    int i;
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
              FirebaseFirestore.instance.collection(widget.email2).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              //     .data() as Map<String, dynamic>;
              for (i = 0; i < snapshot.data!.docs.length; i++) {
                if (snapshot.data!.docs[i].get("edit") == true) {
                  savelist.add(snapshot.data!.docs[i].get("url"));
                }
              }

              return Container(
                height: 5000,
                child: Container(
                    color: Colors.transparent,
                    width: 3000,
                    height: 240,
                    child: Container(
                      height: 200,
                      width: 200,
                      child: ListView.builder(
                        itemCount: savelist.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Container(
                                    child: Image.network(savelist[index])),
                                Container(
                                  child: ListTile(
                                    title: Text(
                                      "Saved image:",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    trailing: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          FirebaseFirestore.instance
                                              .collection(widget.email2)
                                              .doc(widget.text3)
                                              .update({"edit": false});
                                        });
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => homepage(
                                                    email: widget.email2)));
                                      },
                                      icon: Icon(Icons.delete),
                                      color: Colors.white,
                                      iconSize: 25,
                                    ),
                                    leading: CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(savelist[index]),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    )),
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
