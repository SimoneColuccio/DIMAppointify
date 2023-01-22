import 'package:Appointfy/Pages/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignoutScreen extends StatefulWidget {
  static String id = 'test';
  @override
  _SignoutScreenState createState() => _SignoutScreenState();
}

class _SignoutScreenState extends State<SignoutScreen> {

  void logout() async {
    await FirebaseAuth.instance.signOut().
    then((value) =>
    {
      Navigator
          .push(context,
          MaterialPageRoute(builder: (context) => const WelcomeScreen()))
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                // _auth.signOut();
                // Navigator.pop(context);
                logout();
                //   getMessages();
                //Implement logout functionality
              }),
        ],
        title: Text('⚡️signout'),
        backgroundColor: Colors.lightBlueAccent,
      ),
    );
  }
}