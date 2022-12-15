import 'dart:io';

import 'package:auction_clean_architecture/features/auction_event/cubit/states.dart';
import 'package:auction_clean_architecture/features/auction_event/models/comment_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../authentication/cubit/user.dart';
import '../../posts/data/models/posts_model.dart';
import '../models/event_model.dart';

class AuctionCubit extends Cubit<AuctionStates> {
  AuctionCubit() : super(AuctionInitialState());

  static AuctionCubit get(context) => BlocProvider.of(context);

  UserModel userData = UserModel();
  void getUserzData() {
    var currentUser = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser!.uid)
        .get()
        .then((value) {
      print(value.data());
      userData = UserModel.fromMap(value.data());
    }).catchError((error) {});
    // return userData;
  }

  UserModel usermodel = UserModel();
  Future<UserModel> getUserProfile(id) async {
    emit(AuctionGetUserLoadingState());
    String? uid;
    User? user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .get()
        .then((value) {
      print(value.data());

      usermodel = UserModel.fromMap(value.data());

      emit(AuctionGetUserSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(AuctionGetUserErrorState(error.toString()));
    });
    return usermodel;
  }

  File? profileImage;
  String? profileImageUrl;
  void upLoadProfileImage() {
    emit(AuctionUserUpdateLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('user/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((p0) {
      p0.ref.getDownloadURL().then((value) {
        emit(AuctionUploadProfileImageSuccessState());
        print(value);
        profileImageUrl = value;
        updateUser(image: profileImageUrl);
      }).catchError((error) {
        emit(AuctionUploadProfileImageErrorState());
      });
    }).catchError((error) {
      emit(AuctionUploadProfileImageErrorState());
    });
  }

  void removeProfileImage() {
    profileImage = null;
    emit(AuctionRemovePostImageState());
  }

  void updateUser({
    String? image,
  }) {
    UserModel usermodel = UserModel(
      name: userData.name,
      email: userData.email,
      image: image,
      uid: userData.uid,
      address: userData.address,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(userData.uid)
        .update(usermodel.toMap())
        .then((value) {
      getUserzData();
    }).catchError((error) {
      emit(AuctionUserUpdateErrorState());
    });
  }

  var picker = ImagePicker();
  Future<void> getProfileImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      print(pickedFile.path);
      emit(AuctionProfileImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(AuctionProfileImagePickedErrorState());
    }
  }

  void updatePostState({
    bool? isStarted,
    bool? isFinish,
    String? winner,
  }) {
    PostModel updatemodel = PostModel(
      name: postByID.name,
      image: userData.image,
      uid: postByID.uid,
      startdate: postByID.startdate,
      enddate: postByID.enddate,
      postTime: postByID.postTime,
      description: postByID.description,
      postImage: postByID.postImage,
      postId: postByID.postId,
      category: postByID.category,
      titel: postByID.titel,
      price: postByID.price,
      winner: winner ?? postByID.winner,
    );

    FirebaseFirestore.instance
        .collection('posts')
        .doc(postByID.postId)
        .update(updatemodel.toMap())
        .then((value) {})
        .catchError((error) {
      emit(AuctionStartPostUpdateUpdateErrorState());
    });
  }

  PostModel postByID = PostModel(
    enddate: DateTime(10),
    postTime: DateTime(10),
    startdate: DateTime(10),
  );
  Future<dynamic> getPostById({required String id}) async {
    emit(AuctionGetPostLoadingState());
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(id)
        .get()
        .then((value) {
      print(value.data()!['uid']);
      postByID = PostModel.fromMap(value.data());

      emit(AuctionGetPostSuccessState());
    }).catchError((error) {
      emit(AuctionGetPostErrorState(error.toString()));
    });
    return postByID;
  }

  void deletDoc(String colection, String postId) {
    FirebaseFirestore.instance.collection(colection).doc(postId).delete();
  }

  Future writeComment(
    String collection,
    String postId, {
    String? dateTime,
    required String? comment,
  }) async {
    emit(AuctionWriteCommentLoadingState());

    String commentId = const Uuid().v1();
    CommentModel cmodel = CommentModel(
        name: userData.name,
        image: userData.image,
        uid: userData.uid,
        dateTime: DateTime.now(),
        comment: comment,
        commentId: commentId,
        postId: postId);
    print(cmodel);
    FirebaseFirestore.instance
        .collection(collection)
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .set(cmodel.toMap())
        .then((value) {
      emit(AuctionWriteCommentSuccessState());
    }).catchError((error) {
      emit(AuctionWriteCommentErrorState());
    });
  }

  List<CommentModel> comments1 = [];
  // List<String> commentId = [];
  List<String> commentsID = [];
  void getComments(postId, String collection) {
    emit(AuctionGetCommentLoadingState());
    FirebaseFirestore.instance
        .collection(collection)
        .doc(postId)
        .collection('comments')
        .snapshots()
        .listen((event) {
      comments1 = [];
      for (var element in event.docs) {
        commentsID.add(element.data()['uid']);
        comments1.add(CommentModel.fromMap(
          element.data(),
        ));
      }
      emit(AuctionGetCommentSuccessState());
    });
  }

  List<PostModel> search = [];
  late String searchKey;
  void getSearch(
    String s,
  ) {
    search.clear();
    searchKey = s;
    FirebaseFirestore.instance
        .collection('posts')
        .where('titel', isGreaterThanOrEqualTo: searchKey)
        .where('titel', isLessThan: '${searchKey}z')
        .snapshots()
        .listen((event) {
      search.clear();
      for (var element in event.docs) {
        search.add(PostModel.fromMap(
          element.data(),
        ));

        print(element.data()['name']);
      }
      emit(AuctionGetCommentSuccessState());
    });
  }

  Future encreasePrice(
    String collection,
    String postId, {
    String? name,
    String? image,
    required int? price,
  }) async {
    emit(AuctionWritePricesLoadingState());
    String encreasePriceId = const Uuid().v1();
    EventModel emodel = EventModel(
        name: userData.name,
        image: userData.image,
        uid: userData.uid,
        dateTime: DateTime.now(),
        price: price,
        encreasePriceId: encreasePriceId,
        postId: postId);
    FirebaseFirestore.instance
        .collection(collection)
        .doc(postId)
        .collection('prices')
        .doc(encreasePriceId)
        .set(emodel.toMap())
        .then((value) {
      emit(AuctionWritePricesSuccessState());
    }).catchError((error) {
      emit(AuctionWritePricesErrorState());
    });
  }

  List<EventModel> encreasePrices = [];
  // List<String> commentId = [];
  // List<int> comments = [];
  void getprice(postId, String collection, {String? id}) {
    emit(AuctionGetPricesLoadingState());

    FirebaseFirestore.instance
        .collection(collection)
        .doc(postId)
        .collection('prices')
        .orderBy('price', descending: true)
        .snapshots()
        .listen((event) {
      encreasePrices = [];
      for (var element in event.docs) {
        encreasePrices.add(EventModel.fromMap(
          element.data(),
        ));
      }
      emit(AuctionGetPricesSuccessState());
    });
  }

  void updatePostPrice({
    required int? price,
    required String? winner,
    required String? winnerID,
  }) {
    FirebaseFirestore.instance.collection('posts').doc(postByID.postId).set({
      'winner': winner,
      'price': price,
      'winnerID': winnerID,
    }, SetOptions(merge: true))

        //   .update(updatemodel.toMap())
        // .then((value) {})
        .catchError((error) {
      emit(AuctionStartPostUpdateUpdateErrorState());
    });
  }

  //
}
