import 'package:flutter/material.dart';
import 'package:fluttertest/screens/registerpage.dart';

class SignUpButton extends StatelessWidget {
  Widget build (BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: new Container(
        height: 50.0,
        width: 200.0,
        child: new FlatButton(
          child: new Text("SIGN UP"),
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0),
          ),
          color: Colors.pink,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
          },
        )   
        )
    );
  }
}
      
