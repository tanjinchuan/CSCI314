
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertest/classes/user.dart';

class StateModel {
  bool isLoading;
  FirebaseUser firebaseUserAuth;
  User user;

  StateModel({
    this.isLoading = false,
    this.firebaseUserAuth,
    this.user,
  });
}
