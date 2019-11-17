import 'package:flutter/material.dart';
import 'package:fluttertest/classes/validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class RegisterPage extends StatefulWidget {
  @override
  RegisterPageState createState() => RegisterPageState();
}
class RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String email;
  String password;
  String displayName;
  @override
  Widget build(BuildContext context) {
      return new Scaffold(
        backgroundColor: Colors.white,
        body: new SingleChildScrollView( 
          child: new Container(
            padding: EdgeInsets.only(top:MediaQuery.of(context).size.height * 0.15),
            child: new Form(
            key: _formKey,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text ("Email", style: TextStyle(fontSize: 20.0, color: Colors.black)),
                new Container(
                  height: 70.0,
                  child: new TextFormField(
                    validator: Validator.validateEmail,

                    controller: emailController,
                    onChanged: (text) {
                      email = text;
                    },
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: ("Enter email"),
                      hintStyle: TextStyle(color: Colors.black),
                    )
                  ),
                ),
                new Text ("Username", style: TextStyle(fontSize: 20.0, color: Colors.white)),
                new Container(
                  height: 70.0,
                  child: new TextFormField(
                    validator: (text){
                      if(text == null){
                        return ("Please enter display name");
                      }
                      else {
                        return null;
                      }
                      
                    },
                    onChanged: (text) {
                      displayName = text;
                    },
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: ("Enter display name"),
                      hintStyle: TextStyle(color: Colors.black),
                    )
                  ),
                ),

                new Padding(
                  padding: EdgeInsets.all(8.0),
                ),


                new Text ("Password", style: TextStyle(fontSize: 20.0, color: Colors.black)),
                new Container(
                  height: 70.0,
                  child: new TextFormField(
                    validator: (text){
                      if(text.length < 6) {
                        return ("Password must be at least 6 characters");
                      }
                      return null;
                    },
                    obscureText: true,
                    controller: passwordController,
                    onChanged: (text) {
                      password = text;
                    },
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: 'Enter password',
                      hintStyle: TextStyle(color: Colors.black),

                    )
                  ),
                ),
                new Padding(
                  padding: EdgeInsets.all(10.0),
                ),

                
                new Text ("Re-Enter Password", style: TextStyle(fontSize: 20.0, color: Colors.black)),
                new Container(
                  height: 70.0,
                  child: new TextFormField(
                    validator: (text){
                      if (text != password) {
                        return ("Password match is incorrect");
                      }
                      return null;
                    },
                    obscureText: true,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: 'Enter password',
                      hintStyle: TextStyle(color: Colors.black),

                    )
                  ),
                ),
                new Padding(
                  padding: EdgeInsets.all(10.0),
                ),

                new Container(
                  child: new Column(
                    children: <Widget> [
                      new FlatButton(
                        color: Colors.blue,
                        child: new Text("SIGN UP"),
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                          side: BorderSide(color: Colors.blue),
                        ),
                        onPressed: () {

                          signUp();
                          
                        },
                        
                      )
                    ]
                  )
                ),
                new Padding(padding: const EdgeInsets.all(10.0,)),
                new Container(
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Text("Already have an account? Login ",style: TextStyle(fontSize: 18.0, color: Colors.black)),
                      new GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: new Text("Here", style: TextStyle(decoration: TextDecoration.underline,fontSize: 18.0, color: Colors.black)),
                    
                      )
                    ],
                  )
                )
              ],
            )
          )
        )
        )
      );
  }


  Future<void> signUp() async {
    if (_formKey.currentState.validate()){
      _formKey.currentState.save();
      try{
        FirebaseUser user = (await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password)).user;
        user.sendEmailVerification();
        await Firestore.instance.collection('User').document(user.uid).setData({
          'userID': user.uid,
          'displayName': displayName,
          'email': user.email,
          'ratings': 5,
          'totalRaters': 1,
          
        });
        //create subcollection to save tours favourited
        await Firestore.instance.collection('User').document(user.uid).collection("ToursFavourited");
        Navigator.of(context).pop();
        showDialog(
          context: context,
          builder: (context) {
            return new AlertDialog(
              title: new Text("Register Successful"),
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

      } catch(e){
        showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              title: Text("Account already exist"),
              content: Text("Enter a different email"),
            
              actions: <Widget> [
                FlatButton(
                  child: Text('Close'),
                  onPressed:() {
                    Navigator.pop(context);
                  }
                )
              ]
            );
          }
        );
        print(e.message);
      }
    }
      
  }
}

