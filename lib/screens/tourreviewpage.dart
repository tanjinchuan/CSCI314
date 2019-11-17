import 'package:flutter/material.dart';
import 'package:fluttertest/classes/tour.dart';
import 'dart:math' as math;
import 'package:fluttertest/widgets/stardisplay.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class TourReviewPage extends StatefulWidget {
  final Tour tour;
  
  TourReviewPage({
    this.tour
  });

  @override
  TourReviewPageState createState() => TourReviewPageState();

}
class TourReviewPageState extends State<TourReviewPage> {
  
  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    return Container(
      color: Color(math.Random().nextInt(0xffffffff)),
      child: new ListTile(
        leading: Icon(Icons.people),
        title: new Text(document['Comment']),
        subtitle: StarDisplay(value: int.parse(document['Rating']))
      )
    );
  
  }

  Widget build (BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.grey[600],
        title: new Text('Reviews'),
       
      ),
      body: new StreamBuilder(
        stream: widget.tour.reviews.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Text('Loading...');
            return ListView.builder(
              itemExtent: 80.0,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) => _buildListItem(context, snapshot.data.documents[index]),
            );
        }
      )
      );      
  }
}
