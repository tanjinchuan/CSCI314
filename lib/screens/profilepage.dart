import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertest/classes/tour.dart';
import 'package:fluttertest/util/state.dart';
import 'package:fluttertest/util/state_widget.dart';
import 'package:fluttertest/widgets/stardisplay.dart';
import 'loginpage.dart';


class ProfilePage extends StatefulWidget {
  final Tour tour;
  bool showButton;
  ProfilePage({Key key, this.tour, this.showButton}) : super(key: key);

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  StateModel appState;

  String name;
  String ratings;
  int totalRaters;
  String ratingChoice;
  
  

  String description;
    final List<DropdownMenuItem> rate = [];


  @override
  void initState(){
        getProfile();

    super.initState();


  }
  
  //update all
  void setRatingParameter() async{
    var doc = await Firestore.instance.collection('User').getDocuments();
    for (int i = 0; i < doc.documents.length; i++){
      await Firestore.instance.collection('User').document(doc.documents[i]['userID']).updateData({
        'ratings': 4,
        'totalRaters': 1,
      });
    }
  }
  @override

  Widget build (BuildContext context){

    appState = StateWidget.of(context).state;
    if ((appState.firebaseUserAuth == null || appState.user == null)) {
      return LoginPage();
    }
    return new Scaffold(
      appBar: new AppBar (
        centerTitle: true,
        title: new Text('Profile'),
        actions: <Widget>[
          new FlatButton(
            onPressed:(){
              saveReview(ratingChoice);
              Navigator.pop(context);
            },
            child: new Text('Save'),
          )
        ],
      ),
      
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(name),
            new StarDisplay(value: double.parse(ratings).floor()),
            new Text(double.parse(ratings).toStringAsFixed(1)),
            new Visibility(
              visible: widget.showButton,
              child: new DropdownButton(
                hint: new Text('Rate tour guide'),
                onChanged: (String item) {
                  setState(() {
                    ratingChoice = item;
                  });
                },
                value: ratingChoice,
                items: ['1', '2', '3', '4', '5'].map((String value) {
                  return new DropdownMenuItem(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
              )
            )
          ],
        )
      )
    );
  }


  void saveReview(String rate) async {
    
    double result = ((double.parse(ratings) * totalRaters) + int.parse(rate)) / (totalRaters + 1); //4.3 e.g


    await Firestore.instance.collection('User').document(widget.tour.guideID).updateData({
      'ratings': result.toString(),
      'totalRaters': totalRaters + 1,

    });
   
  
  }
  void getProfile() async {
    var doc = await Firestore.instance.collection('User').document(widget.tour.guideID).get();
    setState((){
      name = doc['displayName'];
      ratings = doc['ratings'].toString();
      totalRaters = doc['totalRaters'];
    });
  }
}