import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertest/classes/tour.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertest/widgets/datetimepicker.dart';

class HostTourPage extends StatefulWidget{

  @override
  HostTourPageState createState() => new HostTourPageState();
}

class HostTourPageState extends State<HostTourPage> {
  Tour tour = new Tour();
  BasicDateTimeField datetimefield = new BasicDateTimeField();
  String datetime;
  final db = Firestore.instance;
  final _formKey = GlobalKey<FormState>();
  

  @override
  void initState(){
    getUserID();
    super.initState();

  }
  Widget build (BuildContext context) {
    return new Scaffold (
      backgroundColor: Colors.white,
      appBar: new AppBar(
        title: new Text("Host a tour"),
        backgroundColor: Colors.black,
      ),
      body: new SingleChildScrollView(
          child: new Form(
          key: _formKey,
          child: buildHostTourField()
          ),
      )
    );
  }

  Container buildHostTourField() {
    return Container(
        alignment: Alignment.center,
        child: new Column (
          children: <Widget>[

            new Padding (
              padding: EdgeInsets.all(10.0),
            ),
            new Container (
              height:450.0,
              width: 400.0,
              child: new Column(
                children: <Widget>[
                  new Row(
                    children:<Widget>[
                      new StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance.collection('Country').snapshots(),
                      builder: (context, snapshot){
                        if(!snapshot.hasData){
                          const Text("Loading");
                        }
                        else {
                          List<DropdownMenuItem> countryItems = [];
                          for (int i = 0; i < snapshot.data.documents.length; i++) {
                            DocumentSnapshot snap = snapshot.data.documents[i];
                            countryItems.add(
                              new DropdownMenuItem(
                                child: new Text(snap.documentID),
                                value: "${snap.documentID}",
                              
                              ),
                            );
                          }
                          return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new DropdownButton(
                                  items: countryItems,
                                  onChanged:(countryValue){
                                    setState(() {
                                      tour.country = countryValue;
                                      tour.cityName = null;
                                    });
                                  },
                                  value: tour.country,
                                  isExpanded: false,
                                  hint: new Text("Choose country"),
                                ),
                              ],
                            );
                          }
                        }
                      ),
                      new Padding(padding: const EdgeInsets.all(10.0)),
                      new StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance.collection('Country').document(tour.country).collection('City').snapshots(),
                        builder: (context, snapshot) {
                          if(!snapshot.hasData){
                            const Text("Loading");
                          }
                          else {
                            List<DropdownMenuItem> cityItems = [];
                            for (int i = 0; i < snapshot.data.documents.length; i++) {
                              DocumentSnapshot snap = snapshot.data.documents[i];
                              cityItems.add(
                                new DropdownMenuItem(
                                  child: new Text(snap.documentID),
                                  value: "${snap.documentID}",
                                
                                ),
                              );
                            }
                            return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new DropdownButton(
                                    items: cityItems,
                                    onChanged:(cityValue){
                                      setState(() {
                                        tour.cityName = cityValue;
                                      });
                                    },
                                    value: tour.cityName,
                                    isExpanded: false,
                                    hint: new Text("Choose city"),
                                  ),
                                ],
                              );
                            }
                          }
                      ),
                    ]
                  ),
                  new Padding (
                    padding: EdgeInsets.all(10.0),
                  ),
                  
                  new Padding (
                    padding: EdgeInsets.all(10.0),
                  ),
                  new Container(
                    
                    child: new Row(
                      
                      children: <Widget>[
                        new Container(
                          width: 150.0,
                          child: new TextFormField(
                            keyboardType: TextInputType.number,
                            inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                            validator: (text){
                              
                              if (text.isEmpty) {
                                return 'Empty';
                              }
                              return null;
                            },
                            onSaved: (text) => tour.duration = text,

                            decoration: InputDecoration (
                              
                              fillColor: Colors.white, filled: true,
                              labelText: "Duration (hours)",
                              border: OutlineInputBorder (
                                borderRadius: BorderRadius.circular(25.0),
                              )
                            )
                          ),
                        ),
                        new Padding(padding: const EdgeInsets.all(10.0,)),
                        new Container(
                          width:100.0,
                          child: new TextFormField(
                            keyboardType: TextInputType.number,
                            inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],

                            validator: (text){
                              if (text.isEmpty) {
                                return 'Empty';
                              }
                              return null;
                            },
                            onSaved: (text) => tour.capacity = text,

                            decoration: InputDecoration (
                              fillColor: Colors.white, filled: true,
                              labelText: "Capacity",
                              border: OutlineInputBorder (
                                borderRadius: BorderRadius.circular(25.0),
                              )
                            )
                          ),
                        ),
                        new Padding(padding: const EdgeInsets.all(10.0,)),
                        new Container(
                    width:100.0,
                    child: new TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],

                      validator: (text){
                        if (text.isEmpty) {
                          return 'Empty';
                        }
                        return null;
                      },
                      onSaved: (text) => tour.price = text,

                      decoration: InputDecoration (
                        fillColor: Colors.white, filled: true,
                        labelText: "Price",
                        border: OutlineInputBorder (
                          borderRadius: BorderRadius.circular(25.0),
                        )
                      )
                    ),
                  ),
                      ],
                      
                    )
                  ),
                  
                  new Padding(padding: const EdgeInsets.all(10.0)),
                  new Container(
                    height:100.0,
                    child: datetimefield,

                  ),
                
                  
                  new Container(
                    height:100.0,
                    child: Padding (
                      padding: const EdgeInsets.all(10.0),
                      child: new TextFormField(
                        validator: (text) {
                          if (text.isEmpty) {
                            return 'Please enter some description of the tour';
                          }
                          return null;
                        },
                        onSaved: (text){

                          tour.description = text;
                          },
                        minLines: 5,
                        maxLines:15,
                        decoration: InputDecoration(
                          hintText: 'Write your description here',
                          filled: true,
                          enabledBorder: OutlineInputBorder (
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        )
                      )
                    )
                  ),
                ],
              )
                
            ),
            
            
            new FlatButton(
                child: new Text("HOST IT!"),
                onPressed: () { 
                  createData();

                },
                color: Colors.teal,
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                )
            )
          ] 
        )
      );
  }

  void setDateTime() {
    this.datetime = datetimefield.returndatetime();
  }

  

  void createData() async {
    setDateTime();
    

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      DocumentReference ref = await db.collection('TourLists').add({'dateTime': datetime,'tourguideName': tour.guideName, 'tourguideID': tour.guideID, 'Country': tour.country, 'cityName': tour.cityName, 'description': tour.description, 'duration': tour.duration, 'capacity': tour.capacity, 'price': tour.price});
      await db.collection('TourLists').document(ref.documentID).collection('Reviews').document(tour.guideID).setData({
        'Comment': "",
        'Rating' : "",
      });
      
      
      setState(()=> tour.tourID = ref.documentID);
      showDialog(
          context: context,
          builder: (context) {
            return new AlertDialog(
              title: new Text("Tour hosted!"),
              actions: <Widget>[
                new FlatButton (
                  child: new Text('Close'),
                  onPressed: () {
                    Navigator.pop(context);
                  }
                )
              ],
            );
          }
        );
    }
  }

  getUserID() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    tour.guideID = user.uid;
    var doc = await Firestore.instance.collection('User').document(user.uid);
    doc.get().then((DocumentSnapshot snap)=>
      tour.guideName = snap.data['displayName']);
    
  }

  

}

