import 'package:flutter/material.dart';
import 'package:fluttertest/screens/loginpage.dart';
import 'package:fluttertest/screens/registerpage.dart';
import 'package:fluttertest/util/state.dart';
import 'package:fluttertest/util/state_widget.dart';
import 'package:fluttertest/widgets/touristbottombar.dart';

class MyApp extends StatelessWidget {
  MyApp() {
    //Navigation.initPaths();
  }
  @override
  Widget build(BuildContext context) {

    StateModel appState;

    appState = StateWidget.of(context).state;


    return MaterialApp(
        title: 'Toppa',
        //onGenerateRoute: Navigation.router.generator,
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => bottomNavigationBar(),
          '/login': (context) => LoginPage(),
          '/register': (context) => RegisterPage(),

        }
    );
  }
}



void main(){
  StateWidget stateWidget = new StateWidget(
      child: new MyApp(),
  );
  runApp(stateWidget);
}



