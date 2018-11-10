import 'package:flutter/material.dart';

import '../Auth/Firebase/auth_functions.dart';

class Login extends StatefulWidget{
  @override
  State createState() => LoginState();
}

class LoginState extends State<Login>{
  final AuthFunctions auth = AuthFunctions();
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  
  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

    @override
    Widget build(BuildContext context){
      return Scaffold(
        key:key,
        body: Center(
          child:ListView(   
            children:<Widget>[
              
              Padding(
                padding: EdgeInsets.only(top: 40.0),
                child: Image.asset(
                  'assets/flutter.png',
                  height: 200.0,
                  width: 200.0,
                ),
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:<Widget>[
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 10.0),
                    child: Column(
                      children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(bottom: 10.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: "Email",
                                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(35.0))),
                              ),
                              controller: _emailController,
                            ),
                          ),       

                          Padding(
                            padding: EdgeInsets.only(bottom: 30.0),
                            child: TextFormField(
                              obscureText: true,
                                decoration: InputDecoration(
                                  hintText: "Password",
                                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(35.0))),
                                ),
                                controller: _passwordController,
                              ),
                          ),

                          ButtonTheme(
                            minWidth: double.infinity,
                            padding: EdgeInsets.all(15.0),
                            child: RaisedButton(
                              child:  Text(
                                "Log In",
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 16.0,
                                  ),
                                ),
                              elevation: 5.0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(35.0))),
                              color: Colors.lightBlueAccent,
                              textColor: Colors.white,
                              onPressed: (){
                                auth.authenticateUser(_emailController.text, _passwordController.text).then((result){
                                  if (result["success"]){
                                    Navigator.of(context).pushNamedAndRemoveUntil('/home', (_) => false);
                                  }
                                  else{
                                    key.currentState.showSnackBar(SnackBar(
                                        content: Text(result['message']),
                                        duration: Duration(seconds: 2),
                                     )
                                    );
                                  }
                                });
                              },
                            )
                          ),

              
                        FlatButton(
                          child: Text(
                            "Forgot Password",
                            style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 16.0,
                            ),
                          ),

                          onPressed: (){
                            auth.resetPassword(_emailController.text).then((result){
                              key.currentState.showSnackBar(SnackBar(
                                  content: Text("Password reset email sent."),
                                  duration: Duration(seconds: 2),
                                )
                              );
                            });
                          },
                        ),

                        FlatButton(
                          child:Text(
                            "Register",
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Colors.black
                            ),
                          ),

                          onPressed: (){
                            Navigator.of(context).pushNamed('/register');
                          },
                        ),
                      ],
                    )
                  ), 
                ]
              ),
            ]
          ),
        ),
      );
    }
  }