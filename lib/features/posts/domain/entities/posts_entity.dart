import 'package:equatable/equatable.dart';

class PostsEntity extends Equatable {
  final String? name;

  final String? uid;
  final String? image;
  final String? postImage;
  final String? postId;
  final int? price;
  final String? titel;
  final DateTime startdate;
  final DateTime enddate;
  final DateTime postTime;
  final String? category;
  final String? description;
  final String? winner;
  final String? winnerID;

  const PostsEntity({
    required this.name,
    required this.uid,
    required this.image,
    required this.postImage,
    this.postId,
    required this.price,
    required this.titel,
    required this.startdate,
    required this.enddate,
    required this.postTime,
    required this.category,
    required this.description,
    required this.winner,
    required this.winnerID,
  });

  @override
  List<Object?> get props => [
        name,
        uid,
        image,
        postImage,
        postId,
        price,
        titel,
        startdate,
        enddate,
        postTime,
        category,
        description,
        winner,
        winnerID,
      ];
}
