import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertest/classes/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth{

  static Future<String> signUp(String email, String password) async {
    FirebaseUser user = (await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)).user;
    return user.uid;
  }

  static Future<String> signIn(String email, String password) async {
    FirebaseUser user = (await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)).user;
    return user.uid;
  }

  static Future<User> getUserFirestore(String userID) async {
    if (userID != null) {
      return Firestore.instance
          .collection('User')
          .document(userID)
          .get()
          .then((documentSnapshot) => User.fromDocument(documentSnapshot));
    } else {
      print('firestore userId can not be null');
      return null;
    }
  }

  static Future<FirebaseUser> getCurrentFirebaseUser() async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    return currentUser;
  }

  static Future<User> getUserLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('user') != null) {
      User user = userFromJson(prefs.getString('user'));
      //print('USER: $user');
      return user;
    } else {
      return null;
    }
  }

  static Future<String> storeUserLocal(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storeUser = userToJson(user);
    await prefs.setString('user', storeUser);
    return user.userID;
  }

  static Future<void> signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    FirebaseAuth.instance.signOut();
  }



}