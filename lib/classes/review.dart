import 'package:cloud_firestore/cloud_firestore.dart';


class Review {
  CollectionReference reviews;
  String rating;
  String comment;
  Review({
    this.reviews,
  });

  void setRating(String r) {
    this.rating = r;
  }

  void setComment(String c) {
    this.comment = c;
  }
  
}