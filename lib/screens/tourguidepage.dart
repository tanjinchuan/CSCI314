import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertest/classes/tourBooking.dart';
import 'package:fluttertest/classes/tour.dart';
import 'package:intl/intl.dart';

import 'package:fluttertest/screens/chatScreen.dart';
import 'package:fluttertest/screens/tourdetailspage.dart';
import 'package:fluttertest/util/state.dart';
import 'package:fluttertest/util/state_widget.dart';
import 'loginpage.dart';


class TourGuidePage extends StatefulWidget {
  TourGuidePage({Key key}) : super(key: key);

  @override
  TourGuidePageState createState() => TourGuidePageState();
}


class TourGuidePageState extends State<TourGuidePage> {
  StateModel appState;

  String userID;
  List toursBooked = new List();
  List toursCreated = new List();
  List toursChats = new List();

  List toursList = new List();
  TourBooking tourbooking = new TourBooking();
  @override
  void initState(){
    super.initState(); 
    getChats();
    getCreatedTours();

  }
  

  @override
  Widget build (BuildContext context){

    appState = StateWidget
        .of(context)
        .state;

    if ((appState.firebaseUserAuth == null ||
            appState.user == null)) {
      return LoginPage();
    }
    return new DefaultTabController(
      length: 2,
      child: new Scaffold (
        appBar: new AppBar(
          backgroundColor: Colors.red,
          centerTitle: true,
          title: new Text("My Tours"),
          bottom: new TabBar(
            tabs: [
              Tab(icon: Icon(Icons.chat), child: new Text("Hosted")),
              Tab(icon: Icon(Icons.book), child: new Text("Chats for hosts")),
              
            ],
          )
        ),
        body: new TabBarView(
          children: <Widget>[
            _buildCreatedStream(toursCreated),
            _buildChatBuilder(toursChats),

          ],
        )
       )
    );
  }

  

 
  ///////////////////////////////////////////////////////////////////////////////
  Widget _buildChatBuilder(List toursList) {
    
    return new StreamBuilder (
    
        stream: Firestore.instance.collection('TourBooking').snapshots(),
                                                                    
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Text('Loading...');
          return ListView.builder(
            itemExtent: 80.0,
            itemCount: toursList.length,
            itemBuilder: (context, index) => 
              
              _buildChatItem(context, toursList[index])
          );
        }
      );
  }

  Widget _buildChatItem(BuildContext context, DocumentSnapshot document) {

      return ListTile(
        leading: Icon(Icons.airport_shuttle),
        title: Text(document['userName']),
        subtitle: Text(document['Country'] + ", " + document['cityName']),
        trailing: IconButton(
          icon: new Text("Chat"),
          onPressed: (){   
            TourBooking tourbooking = TourBooking(
              date: convertStringtoDateTime(document['dateTime']),
              tourID: document.documentID,
              userID: userID,
              guideID: document['tourGuide'],
              bookingID: document['bookingID'],
            );
            Navigator.push(context, MaterialPageRoute(builder: (context) => chatScreen(booking: tourbooking)));
          },
          
        ),
        onTap: (){
          gotoDetails(document['tourID']);
        },
        isThreeLine: true,
      );
   
    
  }
//////////////////////////////////////////////////////////////////////////////
  //for showing created tours
  Widget _buildCreatedStream(List toursList) {
    
    return new StreamBuilder (
    
        stream: Firestore.instance.collection('TourLists').snapshots(),                               
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Text('Loading...');
          return ListView.builder(
            itemExtent: 80.0,
            itemCount: toursList.length,
            itemBuilder: (context, index) => _buildCreatedItem(context, toursList[index])
          );
            
        }, 
      );
  }

  Widget _buildCreatedItem(BuildContext context, DocumentSnapshot document) {
      return ListTile(
        leading: Icon(Icons.airport_shuttle),
        title: Text(document['tourguideName']),
        subtitle: Text(document['Country'] + ", " + document['cityName']),
        
        onTap: (){
          gotoDetails(document.documentID);
        },
        isThreeLine: true,
      );
   
    
  }

  DateTime convertStringtoDateTime(String datetime){
    var date = new DateFormat("yyyy-MM-dd HH:mm:ss.000").parse(datetime);
   return date;

  }
  void gotoDetails(String tourID) async{
    var documents = await Firestore.instance.collection('TourLists').getDocuments();
    var document;
    for (int i = 0; i < documents.documents.length; i++){
      if ((documents.documents[i].documentID == tourID)){
        document = documents.documents[i];
      }
    }
    Tour tour = new Tour(
      guideName: document['tourguideName'],
      guideID: document['tourguideID'],
      tourID: document.documentID, 
      country: document['Country'], 
      cityName: document['cityName'], 
      description: document['description'], 
      duration: document['duration'], 
      capacity: document['capacity'], 
      price: document['price'],
      reviews: document.reference.collection('Reviews'),
      dateTime: document['dateTime'],
      hide: true,
      showModify: showModify(document['tourguideID']),
      showLike: true,
      showUnlike: false,

    );
    Navigator.push(context, MaterialPageRoute(builder: (context) => TourDetailsPage(tour: tour)));

  }

  bool showModify(String tourguideID){
    if (tourguideID == userID){
      return true;
    }
    else {
      return false;
    }
  }
 

  void getCreatedTours() async{
    List temp = new List();
    
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    this.userID = user.uid;
    QuerySnapshot doc = await Firestore.instance.collection('TourLists').getDocuments();
    for (int i = 0; i < doc.documents.length; i++){
      if(doc.documents[i]['tourguideID'] == userID){
        var tour = doc.documents[i];
        temp.add(tour);
      }
        
    }

    setState((){
      toursCreated = temp;
    });

  }

  
  void getChats() async{
    List temp = new List();
    
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    this.userID = user.uid;
    QuerySnapshot doc = await Firestore.instance.collection('TourBooking').where('tourguideID',isEqualTo:userID).getDocuments();
    for (int i = 0; i < doc.documents.length; i++){
        var tour = doc.documents[i];
        temp.add(tour);
    }

    //get the tour list data according to created tours
    QuerySnapshot tours = await Firestore.instance.collection('TourLists').getDocuments();
    List temp2 = new List();
    for(int i = 0; i < tours.documents.length; i++){
      for (int j = 0; j < toursBooked.length; j++){
        if(tours.documents[i].documentID == toursBooked[i]['tourID']) {
          temp2.add(tours.documents[i]);
        }

      }
    }
    setState((){
      toursChats = temp;
      toursList = temp2;
    });
  }    
}

