import 'package:flutter/material.dart';
import 'package:fluttertest/classes/tour.dart';
import 'package:fluttertest/screens/modifybookingpage.dart';
import 'package:fluttertest/screens/profilepage.dart';

import 'package:intl/intl.dart';
import 'package:fluttertest/widgets/stardisplay.dart';
import 'package:fluttertest/widgets/reviewdialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'loginpage.dart';
import 'package:fluttertest/util/state.dart';
import 'package:fluttertest/util/state_widget.dart';

import 'dart:math' as math;


class TourDetailsPage extends StatefulWidget {

  final Tour tour;
  TourDetailsPage({Key key, this.tour}) : super(key: key);

  @override
  TourDetailsPageState createState() => TourDetailsPageState();
}

class TourDetailsPageState extends State<TourDetailsPage> {
  bool hideBookButton = true;
  int _index = 0;
  double stars = 0;
  List ratings = new List();
  String userID;

  StateModel appState;

  @override
  void initState() {
    super.initState();
    buildRatingList();
    getUserID();
  }
  @override
  void dispose() {
    super.dispose();
  }
  

  Widget build (BuildContext context) {
    appState = StateWidget.of(context).state;

    if ((appState.firebaseUserAuth == null || appState.user == null)) {
      return LoginPage();
    }
    if (widget.tour.capacity == "0" || widget.tour.hide == true) {
      //hide the book button
      hideBookButton = false;
    }

    

    String imageLink = "assets/images/" + widget.tour.country.replaceAll(new RegExp(r"\s+\b|\b\s"), "").toLowerCase() + ".png";

    return new Scaffold (
      appBar: new AppBar(
        backgroundColor: Colors.transparent,
        
      ),
      body: new SingleChildScrollView(
        child: new Column(
          children: <Widget>[
            new Container(
              height: MediaQuery.of(context).size.height * .35,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imageLink),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            _buildDetails(context),
          ]
        ),
      ),
      
    );
  }

  Widget _buildDetails(BuildContext context){

    return new Container(
  
      height: MediaQuery.of(context).size.height * .85,
        color: Colors.white,
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.all(20.0), 
              child: new Text(widget.tour.cityName + ", " + widget.tour.country, style: TextStyle(fontFamily: 'helvetica', fontSize: 30, fontWeight: FontWeight.bold )),
            ),
            new Row(
              children: <Widget>[
                new Padding(
                  padding: const EdgeInsets.only(left:50.0),
                  child: StarDisplay(value: stars.floor()),
                ),

                new Padding(
                  padding: const EdgeInsets.only(left:10.0),
                  child: new Text(stars.toStringAsFixed(1)),
                ),
                new Padding(
                  padding: const EdgeInsets.only(left:40.0),
                  child: new IconButton(
                    icon: Icon(Icons.face, size: 40.0),
                    
                    onPressed:(){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(showButton: showRateTourGuide(),tour: widget.tour)));
                    }
                  )
                ),
              ]
            ),
            

            new Padding(
              padding: const EdgeInsets.all(25.0),
              child: new Text(widget.tour.description, style: TextStyle(fontStyle: FontStyle.italic,fontFamily: 'sans-serif', fontSize: 20)),
            ),
            
            new Container(
              child: new Center(
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                                        new Padding(padding: const EdgeInsets.only(right: 20.0)),

                    new Column(
                      children: <Widget>[
                        new Icon(
                          Icons.people,
                          size: 40.0,
                        ),
                        new Text(widget.tour.capacity + " spots left"),
                      ],
                    ),
                    new Padding(padding: const EdgeInsets.only(left: 20.0, right: 20.0)),
                    new Column(
                      children: <Widget>[
                        new Icon(
                          Icons.timer,
                          size: 40.0,
                        ),
                        new Text(
                          widget.tour.duration + " hours"
                        )
                      ],
                    ),
                    new Padding(padding: const EdgeInsets.only(left: 20.0, right: 20.0)),

                    new Column(
                      children: <Widget>[
                        new Icon(
                          Icons.attach_money,
                          size: 40.0,
                        ),
                        new Text(
                          widget.tour.price + " per pax"
                        )
                      ],
                    )
                  ],
                )
              )
            ),
            //end of container for duration and capacity
            //start container for button
            new Padding(padding: const EdgeInsets.all(10.0)),
            
            ///////////////////datetime
            new Center(
              child: new Text("Tour Date: " + parseDateTime(widget.tour.dateTime),
                              style: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic)
              )
            ),
            ////////////////////
            
            new Padding(padding: const EdgeInsets.all(10.0)),

            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new FlatButton(
                  child: new Text("Give Reviews"),
                  onPressed:(){
                    openReviewDialog();
                  },
                  color: Colors.blue,
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    )
                ),

                new Visibility(
                  visible: widget.tour.showModify,
                  child: new FlatButton(
                   child: new Text("Modify"),
                   onPressed:() {
                     Navigator.push(context, MaterialPageRoute(builder: (context) => ModifyBookingPage(tour: widget.tour)));

                   },
                   color: Colors.red,
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    )
                  )
                ),
                
                
                new Visibility(
                  visible: hideBookButton,
                  child: new FlatButton(
                    onPressed: () {
                      minusCapacity();

                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (context) {
                          return new AlertDialog(
                            title: new Text("Tour Booked!"),
                            actions: <Widget>[
                              new FlatButton (
                                child: new Text('Close'),
                                onPressed: () {

                                  addBooking();
                                  Navigator.pop(context);
                                }
                              )
                            ],
                          );
                        }
                      );
                    },
                    child: new Text("BOOK IT!"),
                    color: Colors.teal,
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    )
                    )
                  ),
                  new Visibility(
                    visible: widget.tour.showLike,
                    child: new FlatButton(
                    child: new Text("Like"),
                    onPressed:() {
                      likeTour();
                      Navigator.pop(context);
                    },
                    color: Colors.pink,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      )
                    )
                  ),
                  new Visibility(
                    visible: widget.tour.showUnlike,
                    child: new FlatButton(
                    child: new Text("Unlike"),
                    onPressed:() {
                      unlikeTour();
                      Navigator.pop(context);
                    },
                    color: Colors.red,
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      )
                    )
                  )
                    
                
                ],
              ),
              new Flexible(
                child:new StreamBuilder(
                  stream: widget.tour.reviews.snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const Text('Loading...');
                    
                      return ListView.builder(
                        itemExtent: 80.0,
                        itemCount: ratings.length,
                        itemBuilder: (context, index) => _buildReviewItem(context, ratings[index]),
                      );
                  }
                )
              )
            ]
          )
        );
  }


  bool showRateTourGuide() {
      if (widget.tour.guideID == userID){
        return false;      
      }
      else {
        return true;
      }
  }
  void addBooking() async {
    //add the tour to user's TourBookings
    await Firestore.instance.collection('User').document(userID).collection('ToursBooked').document(widget.tour.tourID).setData({});
    
    
    var doc = await Firestore.instance.collection('TourBooking').add({
      'tourguideName': widget.tour.guideName,
      'Country': widget.tour.country,
      'cityName': widget.tour.cityName,
      'dateTime': widget.tour.dateTime,
      'tourID': widget.tour.tourID,
      'tourguideID': widget.tour.guideID, 
      'userID': userID,
      'userName': appState.user.displayName,
      });
    //add booking id as documentid of the document
    
    await Firestore.instance.collection('TourBooking').document(doc.documentID).updateData({'bookingID': doc.documentID});
    await Firestore.instance.collection('TourBooking').document(doc.documentID).collection('Chat').add({
      'idFrom': "",
      'idTo:': "",
      'timestamp': "",
      'content': "",
    });
  }

  void buildRatingList() async{
    List list = new List();
    double total = 0;
    int count = 0;
    var docs = await widget.tour.reviews.getDocuments();
    for(int i = 0; i < docs.documents.length; i++){
      if(docs.documents[i]['Rating'] != ""){
        count++;
        list.add(docs.documents[i]);
        total = total + double.parse(docs.documents[i]['Rating']);
      }
    }
    setState((){
      this.ratings = list;
      if (total != 0){
        this.stars = total / count;

      }
      else {
        this.stars = 0;
      }
    });
  }

  Widget _buildReviewItem(BuildContext context, DocumentSnapshot document) {
    
    return Container(
      child: new ListTile(
        leading: Icon(Icons.people),
        title: new Text(document['Comment']),
        subtitle: StarDisplay(value: int.parse(document['Rating']))
      )
    );
  }

  void openReviewDialog(){
    Navigator.of(context).push(new MaterialPageRoute<Null>(
      builder:(BuildContext context){
        return new ReviewDialog(tour: widget.tour);
      },
      fullscreenDialog: true,
    ));
  }
  
  
  void minusCapacity() async{
    await Firestore.instance.collection("TourLists").document(widget.tour.tourID).updateData({
      'capacity': (int.parse(widget.tour.capacity) - 1).toString()
    });
  }

  String parseDateTime(String datetime){
    var date = new DateFormat("yyyy-MM-dd HH:mm:ss.000").parse(datetime);
    var result = "${date.year}/${date.month}/${date.day} ${date.hour}:${date.minute}${date.second}";
    return result;
  }

  void likeTour() async {
    await Firestore.instance.collection('User').document(userID).collection('ToursFavourited').document(widget.tour.tourID).setData({});

  }
  
  void unlikeTour() async {
    await Firestore.instance.collection('User').document(userID).collection('ToursFavourited').document(widget.tour.tourID).delete();
  }

  getUserID() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState((){
      this.userID = user.uid;
    });
  }
}
