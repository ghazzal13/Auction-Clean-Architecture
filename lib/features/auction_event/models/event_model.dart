import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  String? uid;
  String? postId;
  String? name;
  String? image;
  DateTime? dateTime;
  int? price;
  String? encreasePriceId;

  EventModel({
    this.uid,
    this.name,
    this.image,
    this.dateTime,
    this.postId,
    this.price,
    this.encreasePriceId,
  });

  factory EventModel.fromMap(map) {
    return EventModel(
      uid: map['uid'],
      name: map['name'],
      image: map['image'],
      dateTime: map['dateTime'].toDate(),
      postId: map['postId'],
      price: map['price'],
      encreasePriceId: map['encreasePriceId'],
    );
  }

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'name': name,
        'image': image,
        'dateTime': dateTime,
        'postId': postId,
        'price': price,
        'encreasePriceId': encreasePriceId,
      };
}
