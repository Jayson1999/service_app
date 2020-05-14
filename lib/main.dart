import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:serviceapp/firebase/auth.dart';
import 'package:serviceapp/wrapper.dart';

void main() {
  runApp(ServiceApp());
}

class ServiceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<FirebaseUser>.value(
        value: FireAuth().user,
        child: MaterialApp(home: Wrapper())
    );
  }
}
