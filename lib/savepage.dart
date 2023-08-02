import 'dart:io';

import 'package:flutter/material.dart';

class savepage extends StatelessWidget {
  savepage({super.key, });
  // final savedimage1;
  // final List emptylist;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "save list",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        // child: GridView.builder(
        //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //     crossAxisCount: 2,
        //   ),
        //   itemCount: emptylist.length,
        //   itemBuilder: (BuildContext context, int index) {
        //     return Container(
        //         width: 200,
        //         height: 200,
        //         child: Image.file(File(emptylist[index])));
        //   },
        // ),
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Colors.red,
          Colors.black,
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      ),
    );
  }
}
