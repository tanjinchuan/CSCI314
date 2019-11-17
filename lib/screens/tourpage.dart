import 'package:flutter/material.dart';
import 'package:fluttertest/classes/tour.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:fluttertest/screens/tourdetailspage.dart';
class TourPage extends StatefulWidget {
  @override
  TourPageState createState() => TourPageState();
  
}
class TourPageState extends State<TourPage> {

  String tourguideID;
  String _searchText = "";
  Icon _searchIcon = new Icon(Icons.search);

  final TextEditingController _filter = new TextEditingController();
  Widget _appBarTitle = new Text( 'Book Tours' );
  List filteredTours = new List();
  List tours = new List();
  
  TourPageState() {
    //get the user id
    getUserID();

    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredTours = tours;
        });
      } else {
          setState(() {
            _searchText = _filter.text;
            
          });
        }
    });
  }

  @override
  void initState() {
    super.initState();
    //initialize the tourlists
    
    this._getTourNames(); //for searching tours in the page  
  }


  Widget build (BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildBar(),
      
      body: _buildStreamBuilder(),
    
      
    );
  }

  Widget _buildStreamBuilder() {
    if (!(_searchText.isEmpty)) {
      List tempList = new List();
      for (int i = 0; i < filteredTours.length; i++) {
        if (filteredTours[i]['Country'].toLowerCase().contains(_searchText.toLowerCase())) {
          tempList.add(filteredTours[i]);
        }
      }
      filteredTours = tempList;

    }
    return new StreamBuilder (
    
        stream: Firestore.instance.collection('TourLists').snapshots(),                                          
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Text('Loading...');
          return ListView.builder(
            itemExtent: 80.0,
            itemCount: filteredTours.length,
            itemBuilder: (context, index) => 
            
              _buildListItem(context, filteredTours[index])
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
          showLike: true,
          showUnlike: false,
        );
        Navigator.push(context, MaterialPageRoute(builder: (context) => TourDetailsPage(tour: tour)));

      }
     
    );
  }

  Widget _buildBar() {
    return new AppBar(
      centerTitle: true,
      title: _appBarTitle,
      
      actions: <Widget>[
        new IconButton(
          icon: _searchIcon,
          onPressed: _searchPressed,

        ),
      ], 
    );

  }

  getUserID() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    this.tourguideID = user.uid;
  }

  //function to search tours, creates a list to store the tour names
  //then search the tours through that list
  //display tours where search field equals tour name
  void _getTourNames() async {
    QuerySnapshot querySnapshot = await Firestore.instance.collection("TourLists").orderBy('Country').getDocuments();
    List docs = querySnapshot.documents;
    List tempList = new List();
    for (int i = 0; i < docs.length; i++) {
      //to display only the tours that are not created by the user
      //so that the user can only book the tours he did not created
      if(docs[i]['tourguideID'] != tourguideID){
        tempList.add(docs[i]);

      }
    }
    setState(() {
      tours = tempList;
      filteredTours = tours;
    });
  }

  //to change the appbar on top into a search bar when the search icon is clicked
  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          decoration: new InputDecoration(
            prefixIcon: new Icon(Icons.search),
            hintText: 'Search Tours...'
          ),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text( 'Book Tours' );
        filteredTours = tours;
        _filter.clear();
      }
    });
  }
}