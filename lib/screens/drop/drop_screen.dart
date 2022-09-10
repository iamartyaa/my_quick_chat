import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DropScreen extends StatelessWidget {
  static const routeName = '/drop-screen';
  const DropScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: TextButton(
        onPressed: () {
          FirebaseAuth.instance.signOut();
        },
        child: Text('Drop Screen'),
      )),
    );
  }
}
