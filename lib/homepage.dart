import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photoeditingapp/editingpage.dart';
import 'package:photoeditingapp/loginpage.dart';
import 'package:uuid/uuid.dart';

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

TextEditingController saveimage = TextEditingController();
save(BuildContext context) async {
  var saveimage1 = saveimage.text;
  if (saveimage1 != "" || selectedimage != null) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("saved sucessefully"),
      ),
    );
    UploadTask uploadTask = FirebaseStorage.instance
        .ref()
        .child("storedimage")
        .child(Uuid().v1())
        .putFile(selectedimage!);
    TaskSnapshot taskSnapshot = await uploadTask;
    String url = await taskSnapshot.ref.getDownloadURL();

    Map<String, dynamic> data = {"saveas": saveimage1, "url": url};
    await FirebaseFirestore.instance
        .collection("users")
        .doc(saveimage1)
        .set(data);
  } else {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("error"),
      ),
    );
  }
}

File? selectedimage;

class _homepageState extends State<homepage> {
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () {
                Navigator.push(
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
        leading: Icon(
          Icons.person,
          size: 30,
        ),
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
                          .collection("users")
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
                                        CupertinoButton(
                                          onPressed: () {Navigator.push(context, MaterialPageRoute(builder:(context) =>editingpage(url2:showdata["url"] ,text2: showdata["saveas"],) ,));},
                                          child: CircleAvatar(
                                            radius: 75,
                                            backgroundImage:
                                                NetworkImage(showdata["url"]),
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
                        onPressed: () => pick(ImageSource.gallery),
                        icon: Icon(
                          Icons.photo_album,
                          size: 45,
                        )),
                  ),
                  IconButton(
                      onPressed: () => pick(ImageSource.camera),
                      icon: Icon(
                        Icons.camera,
                        size: 45,
                      ))
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("close")),
              ],
            ),
          );
        },
        child: Icon(
          Icons.add_a_photo_outlined,
          size: 40,
        ),
      ),
    );
  }
}
