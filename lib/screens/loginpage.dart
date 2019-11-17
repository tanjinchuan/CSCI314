import 'package:flutter/material.dart';
import 'package:fluttertest/widgets/loginform.dart';
import 'package:fluttertest/widgets/signupbutton.dart';


class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:<Widget>[

            LoginForm(),
            new Padding(padding: const EdgeInsets.all(15.0)),
            SignUpButton(),
          ]
        )
      )
    );
  }
}
