import 'package:flutter/material.dart';

import './Auth/Firebase/auth_functions.dart';

class Home extends StatelessWidget{
  final AuthFunctions auth = AuthFunctions();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),

      body: Center(
          child: ListView(
            children:<Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child:Text(
                      "Home",
                      style: TextStyle(
                        fontSize: 30.0
                      ),
                    )
                  ),

                  RaisedButton(
                    child: Text("Sign Out"),
                    onPressed: (){
                      auth.signOut().then((result){
                        Navigator.of(context).pushNamedAndRemoveUntil('/login', (_)=>false);
                      });
                    },
                  )
                ],
              )
            ]
        ),
      ) 
    );
  }
}