import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:photoeditingapp/createaccount.dart';
import 'package:photoeditingapp/homepage.dart';

class login extends StatelessWidget {
  
  login({super.key});

  TextEditingController email = TextEditingController();
  TextEditingController pasward = TextEditingController();

  void save(BuildContext context) async {
    String savedemail = email.text.toString();
    String savedpasward = pasward.text.toString();
    email.clear();
    pasward.clear();
    if (savedemail == "" || savedpasward == "") {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Error",
            style: TextStyle(
                color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      );
    } else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: savedemail, password: savedpasward);

        if (userCredential != null) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => homepage(email: savedemail,),
              ));
        }
      } on FirebaseAuthException catch (ex) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              ex.code.toString(),
              style: TextStyle(
                  color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
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
      appBar: AppBar(automaticallyImplyLeading: false,
        title: Text(
          "welcome",
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
                    "LOGIN",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => account(),
                        ));
                  },
                  child: Text(
                    "create account",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
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
