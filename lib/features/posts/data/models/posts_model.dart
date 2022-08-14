import 'package:auction_clean_architecture/features/posts/domain/entities/posts_entity.dart';
import 'package:flutter/foundation.dart';

class PostModel extends PostsEntity {
  const PostModel({
    super.name,
    super.uid,
    super.image,
    super.postImage,
    super.postId,
    super.price,
    super.titel,
    super.startdate,
    super.enddate,
    super.postTime,
    super.category,
    super.description,
    super.winner,
    super.winnerID,
  });
  factory PostModel.fromMap(map) {
    return PostModel(
      uid: map['uid'],
      name: map['name'],
      image: map['image'],
      price: map['price'],
      postImage: map['postImage'],
      postId: map['postId'],
      category: map['category'],
      startdate: DateTime.parse(map['startdate'].toDate().toString()),
      enddate: DateTime.parse(map['enddate'].toDate().toString()),
      postTime: DateTime.parse(map['postTime'].toDate().toString()),
      titel: map['titel'],
      description: map['description'],
      winner: map['winner'],
      winnerID: map['winnerID'],
    );
  }

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'name': name,
        'image': image,
        'postImage': postImage,
        'postId': postId,
        'price': price,
        'category': category,
        'startdate': startdate,
        'enddate': enddate,
        'postTime': postTime,
        'titel': titel,
        'description': description,
        'winner': winner,
        'winnerID': winnerID,
      };
}
