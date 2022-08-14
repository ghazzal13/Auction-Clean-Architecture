import 'package:auction_clean_architecture/core/error/exceptions.dart';
import 'package:auction_clean_architecture/core/error/failures.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';

import '../models/posts_model.dart';

abstract class PostsRemoteDataSource {
  Future<List<PostModel>> getAllPosts();

  Future<Unit> addPost(PostModel postModel);
  Future<Unit> updatePost(PostModel postModel);
  Future<Unit> deletePost(String postId);
}

class PostsRemoteDataSourceImpl implements PostsRemoteDataSource {
  PostsRemoteDataSourceImpl();
  @override
  Future<List<PostModel>> getAllPosts() async {
    List<PostModel> Posts = [];

    FirebaseFirestore.instance.collection('posts').snapshots().listen((event) {
      for (var element in event.docs) {
        Posts.add(PostModel.fromMap(
          element.data(),
        ));
        print(element.data());
      }
    });
    return Posts;
  }

  @override
  Future<Unit> addPost(PostModel postModel) async {
    String postId = const Uuid().v1();
    PostModel pmodel = PostModel(
      name: postModel.name,
      image: postModel.image,
      uid: postModel.uid,
      postId: postId,
      postImage: postModel.postImage,
      titel: postModel.titel,
      description: postModel.description,
      category: postModel.category,
      price: postModel.price,
      startdate: postModel.startdate,
      postTime: DateTime.now(),
      enddate: postModel.startdate!.add(const Duration(hours: 3)),
      winner: 'no one',
      winnerID: 'no one',
    );
    try {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .set(pmodel.toMap());
      return Future.value(unit);
    } on ServerFailure {
      throw ServerException();
    }
  }

  @override
  Future<Unit> deletePost(String postId) async {
    try {
      FirebaseFirestore.instance.collection('posts').doc(postId).delete();
      return Future.value(unit);
    } on ServerFailure {
      throw ServerException();
    }
  }

  @override
  Future<Unit> updatePost(PostModel postModel) async {
    try {
      FirebaseFirestore.instance.collection('posts').doc(postModel.postId).set({
        'name': postModel.name,
        'image': postModel.image,
        'postImage': postModel.postImage,
        'titel': postModel.titel,
        'description': postModel.description,
        'category': postModel.category,
        'price': postModel.price,
      }, SetOptions(merge: true));
      return Future.value(unit);
    } on ServerFailure {
      throw ServerException();
    }
  }
}
