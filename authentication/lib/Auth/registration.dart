import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import '../Auth/Firebase/auth_functions.dart';


class Registration extends StatefulWidget{
  @override
  State createState() => RegistrationState();
}

class RegistrationState extends State<Registration>{
  final AuthFunctions auth = AuthFunctions();
  final TextEditingController _usernameController = new TextEditingController();
  final TextEditingController _fullnameController = new TextEditingController();
  final TextEditingController _emailController    = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();

  Map validateInput(){
    String username = _usernameController.text;
    String fullname = _fullnameController.text;
    String email    = _emailController.text;
    String password = _passwordController.text;
    
    // Username
    if (username.length <= 4) return {"message":"Usernames must be longer than 4 characters.", "success":false};

    if (username.length >= 35) return {"message":"Usernames must be shorter than 35 characters", "success":false};

    // Fullname
    if (fullname.length <= 1) return {"message":"Names must be longer than 1 character.", "success":false};

    if (fullname.length >= 50) return {"message":"Names must be shorter than 50 characters", "success":false};

    // Email
    if (email.length <= 5) return {"message":"Emails must be longer than 5 character.", "success":false};

    if (email.length >= 50) return {"message":"Emails must be shorter than 50 characters", "success":false};

    if (!email.contains('@')) return {"message":"Emails must be valid.", "success":false};

    // Password
    if (password.length <= 5) return {"message":"Passwords must be longer than 5 character.", "success":false};

    if (password.length >= 50) return {"message":"Passwords must be shorter than 50 characters", "success":false};

    return {"message":"", "success":true};
  }

  final GlobalKey<ScaffoldState>  key =  GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      key: key,
      body: Center(
        child:ListView(   
          children:<Widget>[
            
            Padding(
              padding: EdgeInsets.only(top: 6.0),
              child: Image.asset(
                'assets/flutter.png',
                height: 180.0,
                width: 180.0,
              ),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:<Widget>[
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 5.0),
                  child: Column(
                    children: <Widget>[

                        Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: "Username",
                              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(35.0))),
                            ),
                            controller: _usernameController,
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: "Fullname",
                              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(35.0))),
                            ),
                            controller: _fullnameController,
                          ),
                        ),

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
                          padding: EdgeInsets.only(bottom: 20.0),
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
                              "Register",
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
                              Map input = validateInput();

                              if (input['success']){

                                Map user = {
                                  'username': _usernameController.text,
                                  'fullname': _fullnameController.text,
                                  'email': _emailController.text,
                                  'password': _passwordController.text
                                };

                                _uniqueUsername(_usernameController.text).then((result){
                                  if (result){
                                    auth.createUser(user).then((result){
                                        if (result['success']){
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
                                  }  
                                  else{
                                    key.currentState.showSnackBar(SnackBar(
                                        content: Text("Username is already taken."),
                                        duration: Duration(seconds: 1),
                                     )
                                    );
                                  }
                                });  

                              }
                              else{
                                key.currentState.showSnackBar(SnackBar(
                                  content: Text(input['message']),
                                  duration: Duration(seconds: 1),
                                 )
                                );
                              } 
                            },
                          )
                        ),

                      FlatButton(
                        child:Text(
                          "Login",
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Colors.black
                          ),
                        ),

                        onPressed: (){
                          Navigator.of(context).pushNamed('/login');
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

  Future<bool> _uniqueUsername(String username) async {
    return await FirebaseDatabase.instance.reference().child("users").once().then((DataSnapshot snapshot) {
      final users = snapshot.value as Map;
      bool unique = true;

      users.forEach((var key, var value){
        print("DB: " + users[key]['username'] + " Current: " + username + " Equal: " + (users[key]['username'] == username).toString());
        if(users[key]['username'] == username){
          unique = false;
        }
      });

      return unique;
    });
  }
}
