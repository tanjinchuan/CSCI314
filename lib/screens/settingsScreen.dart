import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/util/state.dart';
import 'package:fluttertest/util/state_widget.dart';
import 'package:fluttertest/widgets/tourguidebottombar.dart';
import 'loginpage.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key key}) : super(key: key);

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  String newDisplayName;
  String newDescription;
  String newPassword;
  String olddisplayName;
  String confirmPassword;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List names = new List();
  StateModel appState;

  @override
  Widget build(BuildContext buildContext) {
    appState = StateWidget.of(context).state;

    if ((appState.firebaseUserAuth == null || appState.user == null)) {
      return LoginPage();
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
        ),
        body: new Form(
          key: _formKey,
        child: new Center(
            child: new Column(
          children: <Widget>[
            Divider(height: 30),
            //Change Display Name
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('Display Name: '),
                new SizedBox(
                    width: 200.0,
                    height: 50.0,
                    child: TextFormField(
                        validator: validateName,
                          
                        decoration: InputDecoration(
                          hintText: 'Choose Name',
                          filled: true,
                          enabledBorder: OutlineInputBorder (
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                        onChanged: (String value){
                          setState((){
                            newDisplayName = value;
                          });
                        },
                    )
                )
              ],

            ),
            Divider(height: 10.0),

            //Change Password
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('Change Password: '),
                new SizedBox(
                    width: 200.0,
                    height: 50.0,
                  child: TextFormField(
                      initialValue: '',
                      validator: (text){
                        if(text.length < 6){
                          return 'Password must be at least 6 characters';
                        }
                        else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Password',
                        filled: true,
                        enabledBorder: OutlineInputBorder (
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                      onChanged: (String value){
                        setState((){
                          newPassword = value;
                        });

                      },
                  )
                )
              ],

            ),
            Divider(height: 10),

            //Confirm Change Password
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('Confirm Password: '),
                new SizedBox(
                    width: 200.0,
                    height: 50.0,
                    child: TextFormField(
                        initialValue: '',
                        validator: (text){
                          if (text != newPassword) {
                            return ("Password match is incorrect");
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Confirm',
                          filled: true,
                          enabledBorder: OutlineInputBorder (
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                        onChanged: (String value){
                          setState((){
                            confirmPassword = value;
                          });
                        },
                    )
                )
              ],

            ),
            Divider(height:10.0),

            //New Description
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Change Description: '),
                new SizedBox(
                    width: 200.0,
                    height: 150.0,
                    child: TextFormField(
                      minLines: 3,
                        maxLines: 5,
                        initialValue: '',

                        decoration: InputDecoration(
                          hintText: StateWidget.of(context).state.user.email,
                            filled: true,
                            enabledBorder: OutlineInputBorder (
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                        ),
                        onChanged: (String value){
                          setState((){
                            newDescription = value;
                          });
                         
                        },
                        validator: (String value){
                          return value.contains('@') ? 'Please do not use @ char': null;
                        }
                    )
                )
              ],

            ),

            //Change Options
            FlatButton(
                child: Text('Commit Changes!'),
                shape:RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                color: Colors.pink,
                onPressed:(){
                  onChange(newDisplayName, newPassword, confirmPassword, newDescription);
                  
                }
            ),

            //Sign Out Button
            new Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:<Widget>[
                  FlatButton(
                    child: Text('Tour Guide Mode'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    color: Colors.pink,
                    onPressed:(){
                      showDialog(
                        context: context,
                        builder: (BuildContext context){
                          return new AlertDialog(
                              title: Text('Confirm Change'),
                              content: Text('Confirm change to Tour Guide Mode?'),
                              actions: <Widget>[
                                FlatButton(
                                    child:Text('OK'),
                                    onPressed:(){
                                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                        new tourguideBottomNavigationBar()));
                                    }
                                ),
                                FlatButton(
                                    child:Text('Cancel'),
                                    onPressed:(){
                                      Navigator.of(context).pop();
                                    }
                                )
                              ]
                          );
                        }
                      );
                  }
                  )
                ]
              )
            ),FlatButton(
              child: Text('SignOut'),
              shape:RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              color: Colors.pink,
              onPressed:(){
                StateWidget.of(context).logOutUser();
              }
            )
          ],
        )
        )
        )
    );
  }


  void getDisplayNames() async {
    List temp = new List();
    var docs = await Firestore.instance.collection('User').getDocuments();
    for (int i = 0; i < docs.documents.length; i++){
      temp.add(docs.documents[i]['displayName']);
    }
    setState((){
      this.names = temp;
    });
    
  }

  String validateName(String value){
    getDisplayNames();

    if (names.contains(value)){
      return 'Name taken';
    }
    else {
      return null;
    }
  }

  

  void onChange(String displayName, String password, String passCheck, String description) async{
   if (_formKey.currentState.validate()){
      _formKey.currentState.save(); 
     
      try {

        
        FirebaseUser user = await FirebaseAuth.instance.currentUser();  
        user.updatePassword(password);

        
        //change name in User database
        await Firestore.instance.collection('User').document(appState.user.userID).updateData({
          'displayName': displayName,
        });
        //changing the display name in TourLists
        var docs = await Firestore.instance.collection('TourLists').getDocuments();
        for (int i = 0; i < docs.documents.length; i++){
          if (docs.documents[i]['tourguideID'] == appState.user.userID){
            await Firestore.instance.collection('TourLists').document(docs.documents[i].documentID).updateData({
              'tourguideName': displayName,
              
            });
          }
        }
        //changing the display name of tour guide in TourBooking
        var docs2 = await Firestore.instance.collection('TourBooking').getDocuments();
        for (int i = 0 ; i < docs2.documents.length; i++){
          if(docs2.documents[i]['tourguideID'] == appState.user.userID){
            await Firestore.instance.collection('TourBooking').document(docs2.documents[i].documentID).updateData({
              'tourguideName': displayName,
            });

          }
          //change the name of the booked user in TourBooking
          if(docs2.documents[i]['userID'] == appState.user.userID){
            await Firestore.instance.collection('TourBooking').document(docs2.documents[i].documentID).updateData({
              'userName': displayName,
            });
          }
        }
        showDialog(
          context: context,
          builder: (context) {
            return new AlertDialog(
              title: new Text("Successfully updated name and password!"),
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
      }catch(e){
        showDialog(
          context: context,
          builder: (context) {
            return new AlertDialog(
              title: new Text("Server Error! Please re-login and try again"),
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
        print("Password can't be changed" + e.toString());
        
        //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
      
      }
    }
    
  }

  
}
