import 'package:flutter/material.dart';
import 'package:fluttertest/classes/tour.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReviewDialog extends StatefulWidget {
  final Tour tour;
  ReviewDialog({this.tour});

  @override
  ReviewDialogState createState() => new ReviewDialogState();
}

class ReviewDialogState extends State<ReviewDialog> {
  @override
  String userID;
  String comment;
  String rating;
  final List<DropdownMenuItem> rate = [];

  void initState(){
    getUserID();
    super.initState();
  }
  Widget build (BuildContext context){
    

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Give review"),
        actions: [
          new FlatButton(
            onPressed:(){
              addReview(comment,rating);
              Navigator.pop(context);
            },
            child: new Text('Save'),
          )
        ]
      ),
      body: new Column(
        children: <Widget>[
          new Container(
            
            child: new TextFormField(
              
              onChanged: (text) {
                setState(() {
                  comment = text;
                  
                });
              },
              decoration: InputDecoration(
                hintText: 'Write your description here',
                filled: true,
                enabledBorder: OutlineInputBorder (
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.grey),
                ),
              )
            )
          ),
          new DropdownButton(
            hint: new Text("Choose Rating"),
            onChanged: (String item) {
              setState(() {
                rating = item;
              });
            },
            value: rating,
            items: ['1', '2', '3', '4', '5'].map((String value) {
              return new DropdownMenuItem(
                value: value,
                child: new Text(value),
              );
            }).toList(),
          )
        ],
      
      )
    );

  }
  void addReview(String comment, String rating) async {
    if(rating == null) {
      rating = "0";
    }
    if(comment == null){
      comment = "";
    }    
    await widget.tour.reviews.document(userID).setData({
        'Comment': comment,
        'Rating' : rating,
      });
      showDialog(
          context: context,
          builder: (context) {
            return new AlertDialog(
              title: new Text("Review saved!"),
              actions: <Widget>[
                new FlatButton (
                  child: new Text('Close'),
                  onPressed: () {
                    Navigator.pop(context);
                  }
                )
              ],
            );
          }
        );
        
  }
  getUserID() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState((){
      userID = user.uid;
    });
  }
}