import 'package:auction_clean_architecture/features/auction_event/post_details_page.dart';
import 'package:auction_clean_architecture/features/posts/data/models/posts_model.dart';
import 'package:auction_clean_architecture/features/posts/domain/entities/posts_entity.dart';
import 'package:flutter/material.dart';
import 'package:timer_count_down/timer_count_down.dart';

class SearchPostCard extends StatefulWidget {
  final PostModel postModel;
  const SearchPostCard({super.key, required this.postModel});

  @override
  State<SearchPostCard> createState() =>
      _SearchPostCardState(postModel: postModel);
}

class _SearchPostCardState extends State<SearchPostCard> {
  PostModel postModel;
  _SearchPostCardState({required this.postModel});
  Widget counterDownStarted({
    required int timeinSecond,
  }) =>
      Container(
        alignment: Alignment.topLeft,
        child: Countdown(
          seconds: timeinSecond,
          build: (BuildContext context, double time) => Text(
            '${Duration(seconds: time.toInt()).inHours.remainder(24).toString()}:${Duration(seconds: time.toInt()).inMinutes.remainder(60).toString()}:${Duration(seconds: time.toInt()).inSeconds.remainder(60).toString().padLeft(2, '0')}',
            style: const TextStyle(
                fontSize: 15, color: Colors.red, fontWeight: FontWeight.bold),
          ),
          interval: const Duration(seconds: 1),
          onFinished: () {
            setState(() {});
          },
        ),
      );

  Widget counterDown({
    required int timeinSecond,
  }) =>
      Container(
        alignment: Alignment.topLeft,
        child: Countdown(
          seconds: timeinSecond,
          build: (BuildContext context, double time) => Text(
            '${Duration(seconds: time.toInt()).inDays.remainder(365).toString()}:${Duration(seconds: time.toInt()).inHours.remainder(24).toString()}:${Duration(seconds: time.toInt()).inMinutes.remainder(60).toString()}:${Duration(seconds: time.toInt()).inSeconds.remainder(60).toString().padLeft(2, '0')}',
            style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold),
          ),
          interval: const Duration(seconds: 1),
          onFinished: () {
            setState(() {});
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OnlineEventScreen(
              duration:
                  (postModel.startdate).difference(DateTime.now()).inSeconds,
              post1: postModel,
              postId: postModel.postId.toString(),
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.teal[50],
            borderRadius: BorderRadius.circular(
              10.0,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 150.0,
                height: 150.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    10.0,
                  ),
                  image: DecorationImage(
                    image: NetworkImage(postModel.postImage.toString()),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: SizedBox(
                  height: 150.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'from ',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            postModel.name.toString(),
                            style: Theme.of(context).textTheme.bodyText1,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            'titel ',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            postModel.titel.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            'category ',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            postModel.category.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            'description ',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            postModel.description.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            'starting Price',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            postModel.price.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      (DateTime.now().isAfter(postModel.startdate) &&
                              DateTime.now().isBefore(postModel.enddate))
                          ? Row(
                              children: [
                                const Text(
                                  'remaining time ',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                counterDownStarted(
                                    timeinSecond: (postModel.enddate)
                                        .difference(DateTime.now())
                                        .inSeconds),
                              ],
                            )
                          : DateTime.now().isAfter(postModel.enddate)
                              ? Row(
                                  children: [
                                    const Text(
                                      'Winner ',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      postModel.winner.toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    const Text(
                                      'remaining time ',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    counterDown(
                                      timeinSecond: (postModel.startdate)
                                          .difference(DateTime.now())
                                          .inSeconds,
                                    ),
                                  ],
                                ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 15.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
