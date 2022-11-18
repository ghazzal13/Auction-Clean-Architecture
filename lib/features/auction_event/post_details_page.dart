import 'dart:math';

import 'package:auction_clean_architecture/features/auction_event/cubit/states.dart';
import 'package:auction_clean_architecture/features/auction_event/post/post_dody.dart';
import 'package:auction_clean_architecture/features/auction_event/post/post_row_heder.dart';
import 'package:auction_clean_architecture/features/authentication/cubit/auth_methoed.dart';
import 'package:auction_clean_architecture/features/posts/domain/entities/posts_entity.dart';
import 'package:auction_clean_architecture/features/posts/presentation/pages/add_edit_post/edit_post.dart';
import 'package:auction_clean_architecture/reuse/reuse_navigator_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_validator/form_validator.dart';
import 'package:intl/intl.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../core/app_theme.dart';
import 'cubit/cubit.dart';
import 'models/comment_model.dart';
import 'models/event_model.dart';

class OnlineEventScreen extends StatefulWidget {
  final String postId;
  final PostsEntity post1;
  final int duration;

  const OnlineEventScreen({
    Key? key,
    required this.duration,
    required this.post1,
    required this.postId,
  }) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<OnlineEventScreen> createState() =>
      _OnlineEventScreenState(postId: postId, post1: post1, duration: duration);
}

class _OnlineEventScreenState extends State<OnlineEventScreen>
    with TickerProviderStateMixin {
  // late AnimationController _controller;

  late DateTime v;
  late DateTime b;
  late int newPrice;
  var duration;

  final TextEditingController _cccController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  String postId;
  PostsEntity post1;
  _OnlineEventScreenState({
    required this.postId,
    required this.duration,
    required this.post1,
  });
  late var _expandedComment;
  late var _expandedPrices;
  @override
  void initState() {
    _expandedComment = (duration > 0) ? true : false;
    _expandedPrices = (duration < 0) ? true : false;

    AuctionCubit.get(context).getPostById(id: postId);
    AuctionCubit.get(context).getComments(postId, 'posts');
    AuctionCubit.get(context).getprice(postId, 'posts');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuctionCubit, AuctionStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var userModel = AuthCubit.get(context).userData;
          var postmmm = AuctionCubit.get(context).postByID;

          return Scaffold(
            appBar: AppBar(
              backgroundColor: primaryColor,
              // title: Text('${postmmm.titel}'),
              title: Text('${post1.titel}'),
              actions: [
                IconButton(
                    onPressed: () {
                      navigateAndremove(context, EditPostScreen(post: post1));
                    },
                    icon: const Icon(Icons.mode_edit_outlined))
              ],
            ),
            body: Container(
                child: Form(
              key: formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(
                      child: GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => UserProfileScreen(
                          //       name: post1['name'],
                          //       id: post1['uid'],
                          //     ),
                          //   ),
                          // );
                        },
                        child: PostRowHeder(
                          post: post1,
                          userId: '${userModel.uid}',
                          date:
                              '${DateFormat.yMd().add_jm().format(post1.postTime)} ',
                          image: '${post1.image}',
                          name: '${post1.name}',
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    PostBody(post1: post1),
                    const SizedBox(
                      height: 10,
                    ),
                    remaningTime(duration, context),
                    ListTile(
                      title: const Text('Comments'),
                      subtitle: (AuctionCubit.get(context).comments1.isNotEmpty)
                          ? Text(
                              'There is ${AuctionCubit.get(context).comments1.length} comments')
                          : const Text('There is no comments'),
                      trailing: IconButton(
                        icon: Icon(_expandedComment
                            ? Icons.expand_less
                            : Icons.expand_more),
                        onPressed: () {
                          setState(() {
                            _expandedComment = !_expandedComment;
                          });
                        },
                      ),
                    ),
                    if (_expandedComment)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 4),
                        height: min(
                            AuctionCubit.get(context).comments1.length * 50.0 +
                                10,
                            200),
                        child: ListView.builder(
                          itemBuilder: (context, index) => buildCommentItem(
                              AuctionCubit.get(context).comments1[index],
                              index),
                          itemCount: AuctionCubit.get(context).comments1.length,
                        ),
                      ),
                    ListTile(
                      title: const Text('Bids'),
                      subtitle: (AuctionCubit.get(context)
                              .encreasePrices
                              .isNotEmpty)
                          ? Text(
                              'There is ${AuctionCubit.get(context).encreasePrices.length} bids')
                          : const Text('There is no bids'),
                      trailing: IconButton(
                        icon: Icon(_expandedPrices
                            ? Icons.expand_less
                            : Icons.expand_more),
                        onPressed: () {
                          setState(() {
                            _expandedPrices = !_expandedPrices;
                          });
                        },
                      ),
                    ),
                    if (_expandedPrices)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 4),
                        height: min(
                            AuctionCubit.get(context).encreasePrices.length *
                                    50.0 +
                                10,
                            200),
                        child: ListView.builder(
                          padding: const EdgeInsets.all(15.0),
                          itemBuilder: (context, x) => buildPricesItem(
                              AuctionCubit.get(context).encreasePrices[x]),
                          itemCount:
                              AuctionCubit.get(context).encreasePrices.length,
                        ),
                      ),
                    (post1.uid != userModel.uid &&
                            duration < 0 &&
                            duration + 60 * 3 * 60 > 0)
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.39,
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: TextFormField(
                                    controller: _priceController,
                                    validator: ValidationBuilder(
                                            requiredMessage: 'cant be empty')
                                        .maxLength(50)
                                        .add((value) {
                                      if (int.parse(value!) <
                                          AuctionCubit.get(context)
                                              .encreasePrices[0]
                                              .price!) {
                                        return "can't be less";
                                      }
                                      return null;
                                    }).build(),
                                    decoration: InputDecoration(
                                      labelText: 'Price... ',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      contentPadding: const EdgeInsets.all(12),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            var temp = _priceController;
                                            if (formKey.currentState!
                                                .validate()) {
                                              AuctionCubit.get(context)
                                                  .encreasePrice(
                                                    'posts',
                                                    postId,
                                                    price: int.parse(
                                                        _priceController.text),
                                                  )
                                                  .then((value) =>
                                                      _priceController.clear());
                                              if (AuctionCubit.get(context)
                                                  .encreasePrices
                                                  .isNotEmpty) {
                                                AuctionCubit.get(context)
                                                    .updatePostPrice(
                                                        price: int.parse(
                                                            temp.text),
                                                        winner: userModel.name,
                                                        winnerID:
                                                            userModel.uid);
                                              } else {
                                                AuctionCubit.get(context)
                                                    .updatePostPrice(
                                                        price: int.parse(
                                                            temp.text),
                                                        winnerID: userModel.uid,
                                                        winner: userModel.name);
                                              }
                                            }
                                          });
                                          // AuctionCubit.get(context)
                                          //     .followPost(postId,
                                          //         userModel.uid.toString());
                                        },
                                        icon: const Icon(Icons.send),
                                      ),
                                    ),
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.done,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    if (AuctionCubit.get(context)
                                        .encreasePrices
                                        .isNotEmpty) {
                                      newPrice = AuctionCubit.get(context)
                                              .encreasePrices[0]
                                              .price! +
                                          100;
                                    } else {
                                      newPrice = postmmm.price!;
                                    }
                                    AuctionCubit.get(context).encreasePrice(
                                        'posts', postId,
                                        price: newPrice);
                                    if (AuctionCubit.get(context)
                                        .encreasePrices
                                        .isNotEmpty) {
                                      AuctionCubit.get(context).updatePostPrice(
                                          price: AuctionCubit.get(context)
                                                  .encreasePrices[0]
                                                  .price! +
                                              100,
                                          winner: userModel.name,
                                          winnerID: userModel.uid);
                                    } else {
                                      AuctionCubit.get(context).updatePostPrice(
                                          price: postmmm.price,
                                          winnerID: userModel.uid,
                                          winner: userModel.name);
                                    }
                                  });
                                  // AuctionCubit.get(context).followPost(
                                  //     postId, userModel.uid.toString());
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: Colors.teal,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text(
                                          'add 100',
                                          style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Icon(Icons.add, size: 30),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Container(),
                    (duration > 1)
                        ? Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: TextFormField(
                              controller: _cccController,
                              validator: ValidationBuilder(
                                      requiredMessage: 'cant be empty')
                                  .maxLength(50)
                                  .build(),
                              decoration: InputDecoration(
                                  hintText: '  write comment... ',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  contentPadding: const EdgeInsets.all(5),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        AuctionCubit.get(context)
                                            .writeComment(
                                          'posts',
                                          postId,
                                          comment: _cccController.text,
                                        )
                                            .then((value) {
                                          _cccController.clear();
                                        });
                                        if (post1.uid != userModel.uid) {}
                                      }
                                    },
                                    icon: const Icon(Icons.send),
                                  )),
                              keyboardType: TextInputType.text,
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            )),
          );
        });
  }
}

Widget remaningTime(duration, context) {
  return (duration > 0)
      ? Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'remaning time:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            (duration < 60 * 60 * 24 + 1)
                ? Countdown(
                    seconds: duration,
                    build: (BuildContext context, double time) => Text(
                      '${Duration(seconds: time.toInt()).inHours.remainder(24).toString()}:${Duration(seconds: time.toInt()).inMinutes.remainder(60).toString()}:${Duration(seconds: time.toInt()).inSeconds.remainder(60).toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        fontSize: 30,
                        color: Colors.teal,
                      ),
                    ),
                    interval: const Duration(seconds: 1),
                    onFinished: () {
                      Navigator.pop(context);
                    },
                  )
                : Countdown(
                    seconds: duration,
                    build: (BuildContext context, double time) => Text(
                      '${Duration(seconds: time.toInt()).inDays.remainder(365).toString()}:${Duration(seconds: time.toInt()).inHours.remainder(24).toString()}:${Duration(seconds: time.toInt()).inMinutes.remainder(60).toString()}:${Duration(seconds: time.toInt()).inSeconds.remainder(60).toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        fontSize: 30,
                        color: Colors.teal,
                      ),
                    ),
                    interval: const Duration(seconds: 1),
                    onFinished: () {
                      Navigator.pop(context);
                    },
                  )
          ],
        )
      : (duration + 60 * 3 * 60 > 1 && duration < 0)
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'remaning time:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Countdown(
                  seconds: duration + 60 * 3 * 60,
                  build: (BuildContext context, double time) => Text(
                    '${Duration(seconds: time.toInt()).inHours.remainder(24).toString()}:${Duration(seconds: time.toInt()).inMinutes.remainder(60).toString()}:${Duration(seconds: time.toInt()).inSeconds.remainder(60).toString().padLeft(2, '0')}',
                    style: const TextStyle(
                      fontSize: 30,
                      color: Colors.red,
                    ),
                  ),
                  interval: const Duration(seconds: 1),
                  onFinished: () {
                    Navigator.pop(context);
                  },
                )
              ],
            )
          : Container();
}

Widget buildCommentItem(CommentModel commentModel, index) => Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.teal.withOpacity(0.2),
        ),
        height: 50,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.teal,
                backgroundImage: NetworkImage('${commentModel.image}'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${commentModel.name}',
                        style: TextStyle(
                          color: Colors.teal[600],
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        ', ${timeago.format(commentModel.dateTime as DateTime)}',
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                  Text(
                    '  ${commentModel.comment}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );

Widget buildPricesItem(EventModel eventModel) => Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.teal.withOpacity(0.2),
        ),
        height: 50,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.teal,
                backgroundImage: NetworkImage('${eventModel.image}'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${eventModel.name}',
                        style: TextStyle(
                          color: Colors.teal[600],
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        ', ${timeago.format(eventModel.dateTime as DateTime)}',
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                  Text('${eventModel.price}')
                ],
              ),
            ),
          ],
        ),
      ),
    );
