import 'package:flutter/material.dart';

import './root.dart';
import './home.dart';
import './Auth/login.dart';
import './Auth/registration.dart';
import './Auth/Firebase/auth_functions.dart';

void main() {
  runApp(Authentication());
}

class Authentication extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: Root(),
      routes: <String, WidgetBuilder>{
        '/register': (BuildContext context) => Registration(),
        '/login': (BuildContext context) => Login(),
        '/home': (BuildContext context) => Home(),
      },
    );
  }
}