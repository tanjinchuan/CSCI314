import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Tour{

  String guideID;
  String guideName;
  String tourID;
  String country;
  String cityName;
  String description;
  String duration;
  String capacity;
  String price;
  CollectionReference reviews;
  String dateTime;
  bool hide;
  bool showModify;
  bool showLike;
  bool showUnlike;
  
  
  Tour ({
    this.guideName,
    this.guideID,
    this.tourID,
    this.country,
    this.cityName,
    this.description,
    this.duration,
    this.capacity,
    this.price,
    this.reviews,
    this.dateTime,
    this.hide,
    this.showModify,
    this.showLike,
    this.showUnlike,
    
  });

  DateTime convertStringtoDateTime(String datetime){
    var date = new DateFormat("yyyy-MM-dd HH:mm:ss.000").parse(datetime);
   return date;

  }




}