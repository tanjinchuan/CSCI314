import 'package:flutter/material.dart';
import 'package:fluttertest/classes/tour.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:fluttertest/screens/tourdetailspage.dart';
class FavouritesPage extends StatefulWidget {
  @override
  FavouritesPageState createState() => FavouritesPageState();
  
}
class FavouritesPageState extends State<FavouritesPage> {

  List favTours = new List();
  String userID;


  @override
  void initState() {
    super.initState();
    //initialize the tourlists
    this.getFavTours(); //for searching tours in the page  

  }


  Widget build (BuildContext context){

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        backgroundColor: Colors.pink,
        centerTitle: true,
        title: new Text("Favourites"),
      ),
      
      body: _buildStreamBuilder(),
    
      
    );
  }

  Widget _buildStreamBuilder() {
    
    return new StreamBuilder (
    
        stream: Firestore.instance.collection('TourLists').snapshots(),                                          
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Text('Loading...');
          return ListView.builder(
            itemExtent: 80.0,
            itemCount: favTours.length,
            itemBuilder: (context, index) => 
            
              _buildListItem(context, favTours[index])
          );
        }
      );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    
    return ListTile(
      leading: Icon(Icons.airport_shuttle),
      title: Text(document['tourguideName']),
      subtitle: Text(document['Country'] + ", " + document['cityName']),
      
      isThreeLine: true,
      onTap:(){

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
          hide: false,
          showModify: false,
          showLike: false,
          showUnlike: true,
        );
        Navigator.push(context, MaterialPageRoute(builder: (context) => TourDetailsPage(tour: tour)));

      }
     
    );
  }


  getUserID() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState((){
      userID = user.uid;
    });
  }


  void getFavTours() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    this.userID = user.uid;    
    var snaps= await Firestore.instance.collection("User").document(userID).collection('ToursFavourited').getDocuments();
    List docs = snaps.documents;
    List temp = new List();
    
    for (int i = 0; i < docs.length; i++) {
      temp.add(docs[i].documentID);
    }
    
    QuerySnapshot toursSnaps = await Firestore.instance.collection("TourLists").getDocuments();
    docs = toursSnaps.documents;
    List temp2 = new List();
    for (int i = 0; i < docs.length; i++){
      if(temp.contains(docs[i].documentID)){
       temp2.add(docs[i]);
      }
    }
    
    setState(() {
      favTours = temp2;
    });
  }



}