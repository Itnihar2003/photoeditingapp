import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:photoeditingapp/editingpage.dart';
import 'package:photoeditingapp/homepage.dart';
import 'package:photoeditingapp/loginpage.dart';
import 'package:photoeditingapp/savepage.dart';

import 'firebase_options.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home:(FirebaseAuth.instance.currentUser!=null)? homepage(email:FirebaseAuth.instance.currentUser!.email ,):login(),
    ),
  );
}
