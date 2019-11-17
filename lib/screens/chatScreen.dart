

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/classes/tourBooking.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class chatScreen extends StatefulWidget{
  final TourBooking booking;
  chatScreen({Key key, @required this.booking});
  @override
  State<StatefulWidget> createState() => new chatScreenState();
}

class chatScreenState extends State<chatScreen>{

  String userID;
  String sendID;
  String bookingID;
  var listMessage;
  final TextEditingController textEditingController = new TextEditingController();
  final ScrollController listScrollController = new ScrollController();
  @override
  void initState(){
    super.initState();

    getUserID();
  }

  getUserID() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState((){
      this.userID = user.uid;
      this.sendID = widget.booking.guideID;
      this.bookingID = widget.booking.bookingID;
    });
    
  }

  void onSendMessage(String content, int index){
    if (content.trim() != ' '){
      textEditingController.clear();

      var documentReference = Firestore.instance.collection("TourBooking")
          .document(bookingID)
          .collection("Chat")
          .document(DateTime.now().millisecondsSinceEpoch.toString());
      
      Firestore.instance.runTransaction((transaction) async{
        await transaction.set(
          documentReference,{
            'idFrom': userID,
          'idTo': sendID,
          'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
          'content': content,
        },
        );
      });
      listScrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    }
    else{
      Fluttertoast.showToast(msg: 'nothing to send');
    }
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 && listMessage != null && listMessage[index - 1]['idFrom'] == userID) || index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 && listMessage != null && listMessage[index - 1]['idFrom'] != userID) || index == 0) {
      return true;
    } else {
      return false;
    }
  }

Widget buildListMessage(){
      return StreamBuilder(
        stream: Firestore.instance
            .collection('TourBooking')
            .document(bookingID)
            .collection('Chat')
            .orderBy('timestamp', descending: true)
            .limit(20)
            .snapshots(),
        builder: (context,snapshot){
          listMessage = snapshot.data.documents;
          return ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.all(10.0),
            itemBuilder: (context, index) => buildItem(index, snapshot.data.documents[index]),
            itemCount: snapshot.data.documents.length,
            reverse: true,
            controller: listScrollController,
          );
        }
    );
}

Widget buildItem(int index, DocumentSnapshot document){

    if(document['idFrom'] == userID){
      return Row(
        children:<Widget>[
          Container(
            child: Text(
              document['content'],
            ),
            padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
            width: 200.0,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0),color: Colors.grey),
            margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20.0 : 10.0, right: 10.0),
          )
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    }
    else{
      return Container(
        child: Column(
          children:<Widget>[
            Row(
              children: <Widget>[
                Container(
                  child: Text(
                    document['content'],
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0),color: Colors.grey),
                  margin: EdgeInsets.only(bottom: isLastMessageLeft(index) ? 20.0 : 10.0,left: 10.0),
                )
              ],
            ),

          ]
        )
      );
    }
}

  Widget buildInput() {
    return Container(
      
      child: Row(
        children: <Widget>[
          // Edit text
          Flexible(
            child: Container(
              child: TextField(
                style: TextStyle(fontSize: 15.0,color: Colors.black),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                ),
              ),
            ),
          ),

          // Button send message
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 8.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () => onSendMessage(textEditingController.text, 0),
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      decoration: new BoxDecoration(
          border: new Border(top: new BorderSide(width: 0.5)), color: Colors.white),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        centerTitle: true,
        title: Text("Chat"),

      ),
      body: new Container(
        child: Column(
          children:<Widget>[
            new Flexible(
              child:buildListMessage(),
              ),
            buildInput(),
          ]
        ),
      ),
    );
  }

}