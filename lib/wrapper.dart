import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:serviceapp/authenticate_screen/authenticate.dart';
import 'package:provider/provider.dart';
import 'package:serviceapp/home_screen/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    FirebaseUser user = Provider.of<FirebaseUser>(context);

    if(user != null){
      return Home();
    }
    else{
      return Authenticate();
    }

  }
}
