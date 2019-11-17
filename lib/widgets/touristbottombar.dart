import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/screens/loginpage.dart';
import 'package:fluttertest/screens/touristpage.dart';
import 'package:fluttertest/screens/tourpage.dart';

import 'package:fluttertest/screens/settingsScreen.dart';
import 'package:fluttertest/screens/favourites.dart';
import 'package:fluttertest/util/state.dart';
import 'package:fluttertest/util/state_widget.dart';

class bottomNavigationBar extends StatefulWidget{
  bottomNavigationBar({Key key}) : super(key: key);
  @override
  _bottomNavigationBarState createState() => _bottomNavigationBarState();

}

class _bottomNavigationBarState extends State<bottomNavigationBar> {

  int currentIndex = 0;
  StateModel appState;
  void initState() {
    super.initState();
  }

  Widget callPage(int current) {
    switch (current) {
      case 0:
        return new TouristPage();
        
      case 1: 
        return new TourPage();
      
      case 2:

        return new FavouritesPage();
      case 3:
        return new SettingsScreen();
      
      default:
        return TouristPage();
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
              title: Text('Book Tour'),
              
              
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                title: Text('Favourites')
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