import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

User userFromJson(String str) {
  final jsonData = json.decode(str);
  return User.fromJson(jsonData);
}

String userToJson(User data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class User{
  String userID;
  String displayName;
  String email;

  User({this.userID,this.displayName,this.email});

  factory User.fromDocument(DocumentSnapshot doc) {
      return User.fromJson(doc.data);
  }

  Map<String, dynamic> toJson() => {
    "userID": userID,
    "displayName":displayName,
    "email": email,
  };

  factory User.fromJson(Map<String, dynamic> json) => new User(
    userID: json["userID"],
    displayName: json["displayName"],
    email: json["email"],
  );

}