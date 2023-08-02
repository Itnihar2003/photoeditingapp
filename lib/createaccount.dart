import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:photoeditingapp/homepage.dart';
import 'package:photoeditingapp/loginpage.dart';

class account extends StatelessWidget {
  account({super.key});

  TextEditingController email = TextEditingController();
  TextEditingController pasward = TextEditingController();

  void save(BuildContext context) async {
    String savedemail = email.text.toString();
    String savedpasward = pasward.text.toString();
    if (savedemail == "" || savedpasward == "") {
      print("error");
    } else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: savedemail, password: savedpasward);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              "saved successfully",
              style: TextStyle(
                  color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        );
        if (userCredential != null) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => login(),
              ));
        }
      } on FirebaseAuthException catch (ex) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              ex.code.toString(),
              style: TextStyle(
                  color: Colors.green,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Create account",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        child: Center(
            child: SingleChildScrollView(
              child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
              SizedBox(
                  width: 300,
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: email,
                    decoration: InputDecoration(
                        hintText: "email",
                        hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                  )),
              SizedBox(
                height: 30,
              ),
              SizedBox(
                  width: 300,
                  child: TextField(
                    keyboardType: TextInputType.name,
                    controller: pasward,
                    decoration: InputDecoration(
                        hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        hintText: "pasward",
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
                    "save",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ))
                      ],
                    ),
            )),
        decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [
          Colors.red,
          Colors.black,
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      ),
    );
  }
}
