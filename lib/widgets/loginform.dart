import 'package:flutter/material.dart';
import 'package:fluttertest/classes/validator.dart';

import 'package:fluttertest/util/state_widget.dart';
import 'package:fluttertest/widgets/touristbottombar.dart';

class LoginForm extends StatefulWidget {
  @override
  LoginFormState createState() => new LoginFormState();
}
class LoginFormState extends State<LoginForm> {
  final TextEditingController usernameController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  String username;
  String password;

  @override
  Widget build (BuildContext context) {
    return Form(
      key: _formKey,
      child: new Column(
          children: <Widget>[

              //Username Field
              new Container(
                color: Colors.grey[600],
                width:300,
                child: TextFormField(  
                  controller: usernameController,
                  validator: Validator.validateEmail,
                  onChanged: (text){
                    username = text;
                  },
                  decoration: InputDecoration(
                    
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white,),
                    ),
                    hintText: 'Enter email',
                    hintStyle: TextStyle(color: Colors.white),

                  )
                  
                )
              ),

              //Password Field
              new Padding(padding: const EdgeInsets.all(10.0)),
              new Container(
                width:300.0,
                color: Colors.grey[600],
                child: TextFormField(
                  obscureText: true,
                  controller: passwordController,
                  onChanged: (text) {
                    password = text;
                  },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                    ),
                    hintText: 'Enter password',
                    hintStyle: TextStyle(color: Colors.white),
                  )
                )
              ),

            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            new Container(
              height: 50.0,
              width: 300.0,
              child: new FlatButton(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text("LOGIN"),
                  ],
                ),
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                ),
                color: Colors.pink,
                onPressed: () {

                  signIn();
                },
              )
            )
          ]
      )
      );
    }

    Future<void> signIn() async {
      final formState = _formKey.currentState;
      if(formState.validate()) {
        formState.save();
        try {
          await StateWidget.of(context).logInUser(username,password);
          Navigator.push(context, MaterialPageRoute(builder: (context) => bottomNavigationBar()));
        } catch(e){
//            print(e.message);

            showDialog(
            context: context,
            builder: (context){
              return AlertDialog(
                title: Text("Wrong email or password"),
              
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
        }
        
      }
    }
}
      
