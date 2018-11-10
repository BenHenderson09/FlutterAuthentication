import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

abstract class BaseFunctions{
  Future<Map> createUser(Map info);
  Future<Map> authenticateUser(String email, String password);
  Future<String> currentUser();
  Future<void> signOut();
  Future<void> resetPassword(String email);
}

class AuthFunctions implements BaseFunctions{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<Map> createUser(Map info) async {
     FirebaseUser user;
     DatabaseReference users  = FirebaseDatabase.instance.reference().child("users");
     Map response = {"message":null, "success":false};

     try{
       user = await _firebaseAuth.createUserWithEmailAndPassword(email: info['email'], password: info['password']);

       users.push().set({
         'username':info['username'],
         'fullname':info['fullname'],
         'email':info['email'],
         'authID':user.uid
       });

        response["success"] = true;
     } 
     catch(err){
       response["message"] = err.message;
     }

    return response;
  }

  Future<Map> authenticateUser(String email, String password) async {
    FirebaseUser user;
    Map response = {"message":"", "success":false};

    try{
      user = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      response["success"] = true;
    }catch(err){
      response["message"] = err.message;
    }

    return response;
  }

  Future<String> currentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user != null ? user.uid : null;
  }

  Future<void> signOut() async{
    await _firebaseAuth.signOut();
  }

  Future<void> resetPassword(String email){
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}

