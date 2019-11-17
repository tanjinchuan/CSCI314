import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{
  
  final CollectionReference tourCollection = Firestore.instance.collection('Tours');
}