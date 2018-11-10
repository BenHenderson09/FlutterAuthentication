import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './Auth/login.dart';
import './home.dart';
import './Auth/Firebase/auth_functions.dart';

class Root extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
      return RootState();
  }
}

class RootState extends State<Root>{
  final AuthFunctions auth = AuthFunctions();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool authenticated = false;

  @override
  void initState(){
    auth.currentUser().then((result){
      if (result != null){
        setState(() {
          authenticated = true;
        });
      }
    });
    super.initState();
  }

  
  @override
  Widget build(BuildContext context){
    if (authenticated){
      return Home();
    }
    return Login();
  }
}