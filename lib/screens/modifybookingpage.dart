import 'package:flutter/material.dart';
import 'package:fluttertest/classes/tour.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:fluttertest/widgets/datetimepicker.dart';

class ModifyBookingPage extends StatefulWidget{

  final Tour tour;
  ModifyBookingPage({
    this.tour,
  });
  @override
  ModifyBookingState createState() => ModifyBookingState();
}


class ModifyBookingState extends State<ModifyBookingPage>{

  String newCountry;
  String newcityName;
  String newPrice;
  String newDuration;
  String newCapacity;
  String newDescription;
  String newdateTime;
  BasicDateTimeField datetimefield = new BasicDateTimeField();

  
  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Modify booking"),
      ),
      body: new SingleChildScrollView(
        child: new Form(
          child: buildField(),
      )
    )
    );

  }

  Container buildField() {
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
                                      newCountry = countryValue;
                                      newcityName = null;
                                    });
                                  },
                                  value: newCountry,
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
                        stream: Firestore.instance.collection('Country').document(newCountry).collection('City').snapshots(),
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
                                        newcityName = cityValue;
                                      });
                                    },
                                    value: newcityName,
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
                            onChanged: (text) => setState(() {
                                        newDuration = text;
                            }),

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
                            onChanged: (text) => setState((){newCapacity = text;}),

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
                      onChanged: (text) => setState((){newPrice = text;}),

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
                        onChanged: (text){

                          setState((){newDescription = text;}) ;
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
                  new Container(
                    child: modifyButton(),
                  )
                ],  
              )
            )
          ]
        )
      );

  }

  FlatButton modifyButton() {
    setDateTime();
    return new FlatButton(
      child: new Text("Modify"),
      onPressed: (){
        showDialog(
          context: context,
          builder: (context) {
            return new AlertDialog(
              title: new Text("Tour Modified!"),
              actions: <Widget>[
                new FlatButton (
                  child: new Text('Close'),
                  onPressed: () {
                    modifyData();
                    Navigator.pop(context);

                  }
                )
              ],
            );
          }
        );

      },
      color: Colors.red,
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(30.0),
      )
      
    );
  }
        

  void modifyData() async {
    await Firestore.instance.collection('TourLists').document(widget.tour.tourID).updateData({
      'Country': newCountry,
      'cityName': newcityName,
      'capacity': newCapacity,
      'description': newDescription,
      'duration': newDuration,
      'dateTime': newdateTime,
      'price': newPrice,
    });


  }

  void setDateTime() {
    this.newdateTime = datetimefield.returndatetime();
  }
}