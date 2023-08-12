import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photoeditingapp/editingpage.dart';
import 'package:photoeditingapp/loginpage.dart';
import 'package:photoeditingapp/savepage.dart';
import 'package:uuid/uuid.dart';

class homepage extends StatefulWidget {
  homepage({super.key, this.email});
  final email;
  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  TextEditingController saveimage = TextEditingController();
  save(BuildContext context) async {
    var saveimage1 = saveimage.text;
    saveimage.clear();
    if (saveimage1 != "" || selectedimage != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "saved sucessefully",
            style: TextStyle(color: Colors.green),
          ),
        ),
      ).timeout(const Duration(seconds: 1), onTimeout: () {
        Navigator.pop(context);
      });
      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child("storedimage")
          .child(Uuid().v1())
          .putFile(selectedimage!);
      TaskSnapshot taskSnapshot = await uploadTask;
      String url = await taskSnapshot.ref.getDownloadURL();

      Map<String, dynamic> data = {"saveas": saveimage1, "url": url};
      await FirebaseFirestore.instance
          .collection(widget.email)
          .doc(saveimage1)
          .set(data);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "error",
            style: TextStyle(color: Colors.red),
          ),
        ),
      ).timeout(const Duration(seconds: 1), onTimeout: () {
        Navigator.pop(context);
      });
    }
  }

  File? selectedimage;

  pick(ImageSource source1) async {
    XFile? selected = await ImagePicker().pickImage(source: source1);
    if (selected != null) {
      File image = File(selected.path);
      setState(() {
        selectedimage = image;
      });
    } else
      print("Not selected");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Color.fromARGB(255, 207, 75, 66),
        child: ListView(
          children: [
            DrawerHeader(
                child: Icon(
              Icons.person,
              size: 80,
            )),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection(widget.email)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SizedBox(
                    height: 200,
                    width: 1000,
                    child: ListView.builder(
                      itemCount: 1,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "current user :",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                widget.email,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                } else {
                  return Text("null");
                }
              },
            ),
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => savepage(
                          email2: widget.email,
                        ),
                      ));
                },
                child: Container(
                    height: 80,
                    width: 100,
                    child: Column(
                      children: [
                        Icon(
                          Icons.save_alt,
                          size: 50,
                          color: Colors.black,
                        ),
                        Text(
                          "savelist",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    )))
          ],
        ),
      ),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => login(),
                    ));
              },
              child: Text(
                "logout",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ))
        ],
        title: Text(
          "welcome",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: 1200,
          height: 900,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.red, Colors.black])),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection(widget.email)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Container(
                            color: Colors.transparent,
                            width: 3000,
                            height: 240,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                Map<String, dynamic> showdata =
                                    snapshot.data!.docs[index].data()
                                        as Map<String, dynamic>;

                                return Row(
                                  children: [
                                    Column(
                                      children: [
                                        //circular avatar

                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CupertinoButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        editingpage(
                                                      url2: showdata["url"],
                                                      text2: showdata["saveas"],
                                                      image: showdata["url"],
                                                      collect: widget.email,
                                                    ),
                                                  ));
                                            },
                                            child: CircleAvatar(
                                              radius: 75,
                                              backgroundColor: Colors.red,
                                              backgroundImage:
                                                  NetworkImage(showdata["url"]),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          showdata["saveas"],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                          );
                        } else {
                          return Text("nodata");
                        }
                      }),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: Container(
                        child: (selectedimage != null)
                            ? Container(
                                width: 350,
                                height: 300,
                                child: Image.file(
                                  selectedimage!,
                                  fit: BoxFit.fill,
                                ))
                            : Container(
                                child: FlutterLogo(
                                  size: 250,
                                ),
                              )),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                      width: 300,
                      child: TextField(
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        keyboardType: TextInputType.name,
                        controller: saveimage,
                        decoration: InputDecoration(
                            hintStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                            hintText: "save as",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  TextButton(
                      onPressed: () {
                        save(context);
                      },
                      child: Text(
                        "Save",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text(
                      "selected one=",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                    actionsPadding: EdgeInsets.symmetric(horizontal: 40),
                    content: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 20),
                          child: IconButton(
                              onPressed: () => pick(ImageSource.gallery)
                                      .timeout(const Duration(seconds: 0),
                                          onTimeout: () {
                                    Navigator.pop(context);
                                  }),
                              icon: Icon(
                                Icons.photo_album,
                                size: 45,
                              )),
                        ),
                        IconButton(
                            onPressed: () => pick(ImageSource.camera).timeout(
                                    Duration(seconds: 0), onTimeout: () {
                                  Navigator.pop(context);
                                }),
                            icon: Icon(
                              Icons.camera,
                              size: 45,
                            ))
                      ],
                    ),
                    // actions: [
                    //   TextButton(
                    //       onPressed: () {
                    //         Navigator.pop(context);
                    //       },
                    //       child: Text("close")),
                    // ],
                  ));
        },
        child: Icon(
          Icons.add_a_photo_outlined,
          size: 40,
        ),
      ),
    );
  }
}
