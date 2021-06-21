import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<String> signInWithEmailAndPassword(String email, String password);
  Future<String> createUserWithEmailAndPassword(String email, String password);
  Future<String> currentUser();
  Future<void> signOut();
  Future<String> getCurrentUID();
}

class Auth implements BaseAuth {
  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    User user = (await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email, password: password)).user;
    user.email;
    print(user?.uid);
    return user?.uid;
  }

  Future<String> createUserWithEmailAndPassword(
      String email, String password) async {
    User user = (await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email, password: password)).user;
    return user?.uid;
  }

  Future<String> currentUser() async {
    User user = await FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  Future<void> signOut() async {
    return FirebaseAuth.instance.signOut();
  }

  Future<String> getCurrentUID() async{
    return (await FirebaseAuth.instance.currentUser).uid;
  }

}



