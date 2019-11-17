import 'package:flutter/material.dart';
import 'package:fluttertest/screens/hosttourpage.dart';
import 'package:fluttertest/widgets/tourguidebottombar.dart';

class SectionPage2 extends StatefulWidget {
  final String username;
  SectionPage2({Key key, @required this.username}): super(key: key);
  @override
  SectionPage2State createState() => SectionPage2State();

}
class SectionPage2State extends State<SectionPage2>{
  State model;

  @override
  Widget build (BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.teal,
        title: new Text("Host a tour"),
        actions: <Widget>[
          new FlatButton(
            child: new Text("Switch to Tour guide"),

            onPressed: () {
              Navigator.pop(context);
            }
          )
        ],
      ),
      body:new Container(
      color: Colors.white,
      child: new Column(
        children: <Widget> [
          new Padding(
            padding: EdgeInsets.all(30.0),
          ),
        

          //tour guide
          new Container(
            height: 200.0,
            width: 300.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              image: DecorationImage(
                image: AssetImage('assets/images/chuansplore.png'),
                
              ),
            ),
            child: new FlatButton (
              child: Text("Host a tour", style: TextStyle(color: Colors.white,fontSize: 30.0,fontWeight: FontWeight.bold)),
              
              onPressed:() {
                Navigator.push(context, MaterialPageRoute(builder: (context) => HostTourPage()));
              }
            )
          ),
        ]
      )
      ),
    );
  }
}