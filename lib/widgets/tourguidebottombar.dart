import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/screens/loginpage.dart';
import 'package:fluttertest/screens/tourguideSettingsScreen.dart';
import 'package:fluttertest/screens/tourguidepage.dart';
import 'package:fluttertest/screens/hosttourpage.dart';


import 'package:fluttertest/screens/settingsScreen.dart';
import 'package:fluttertest/util/state.dart';
import 'package:fluttertest/util/state_widget.dart';

class tourguideBottomNavigationBar extends StatefulWidget{
  tourguideBottomNavigationBar({Key key}) : super(key: key);
  @override
  _tourguideBottomNavigationBarState createState() => _tourguideBottomNavigationBarState();

}

class _tourguideBottomNavigationBarState extends State<tourguideBottomNavigationBar> {

  int currentIndex = 0;
  StateModel appState;
  void initState() {
    super.initState();
  }

  Widget callPage(int current) {
    switch (current) {
      case 0:
        return new TourGuidePage();
        
      case 1: 
        return new HostTourPage();
      
      case 2:
        return new tourguideSettingsScreen();
      
      default:
        return TourGuidePage();
    }
  }


  @override
  Widget build(BuildContext context) {
    appState = StateWidget
        .of(context)
        .state;

    if ((appState.firebaseUserAuth == null ||
            appState.user == null)) {
      return LoginPage();
    }

      return Scaffold(
        body: Center(
          child: callPage(currentIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.airport_shuttle),
              title: Text('My Tours'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.flight_takeoff),
              title: Text('Host Tour'),
              
              
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              title: Text('Settings'),
            )
          ],
          currentIndex: currentIndex,
          selectedItemColor: Colors.amber[800],
          unselectedItemColor: Colors.grey[600],
          onTap: (value) {
            currentIndex = value;
            setState(() {});
          },

        ),
      );
    }
  }