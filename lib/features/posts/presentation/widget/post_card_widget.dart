import 'package:flutter/material.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../../../auction_event/post_details_page.dart';
import '../../domain/entities/posts_entity.dart';
import 'package:timeago/timeago.dart' as timeago;

class Postcard extends StatefulWidget {
  const Postcard({
    Key? key,
    required this.snap,
  }) : super(key: key);

  final dynamic snap;

  @override
  State<Postcard> createState() => _PostcardState();
}

class _PostcardState extends State<Postcard> {
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
              duration: (widget.snap['startdate'].toDate())!
                  .difference(DateTime.now())
                  .inSeconds,
              post1: PostsEntity(
                uid: widget.snap['uid'].toString(),
                name: widget.snap['name'].toString(),
                image: widget.snap['image'].toString(),
                price: widget.snap['price'],
                postImage: widget.snap['postImage'].toString(),
                postId: widget.snap['postId'].toString(),
                category: widget.snap['category'].toString(),
                startdate: DateTime.parse(
                    widget.snap['startdate'].toDate().toString()),
                enddate:
                    DateTime.parse(widget.snap['enddate'].toDate().toString()),
                postTime:
                    DateTime.parse(widget.snap['postTime'].toDate().toString()),
                titel: widget.snap['titel'].toString(),
                description: widget.snap['description'].toString(),
                winner: widget.snap['winner'].toString(),
                winnerID: widget.snap['winnerID'].toString(),
              ),
              postId: widget.snap['postId'].toString(),
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
                    image: NetworkImage(
                      widget.snap['postImage'].toString(),
                    ),
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
                          Flexible(
                            child: Text(
                              widget.snap['name'].toString(),
                              style: Theme.of(context).textTheme.bodyText1,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            ',${timeago.format(widget.snap['postTime'].toDate(), locale: 'en_short')} ',
                            style: const TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Flexible(
                            child: Text(
                              'titel ',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          Text(
                            widget.snap['titel'].toString(),
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
                            widget.snap['category'].toString(),
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
                          Flexible(
                            child: Text(
                              widget.snap['description'].toString(),
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            'starting Price',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Flexible(
                            child: Text(
                              ' ${widget.snap['price'].toString()} \$',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      (DateTime.now()
                                  .isAfter(widget.snap['startdate'].toDate()) &&
                              DateTime.now()
                                  .isBefore(widget.snap['enddate'].toDate()))
                          ? Row(
                              children: [
                                const Text(
                                  'remaining time ',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                counterDownStarted(
                                    timeinSecond:
                                        (widget.snap['enddate'].toDate())!
                                            .difference(DateTime.now())
                                            .inSeconds),
                              ],
                            )
                          : DateTime.now()
                                  .isAfter(widget.snap['enddate'].toDate())
                              ? Row(
                                  children: [
                                    const Text(
                                      'Winner ',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      ' ${widget.snap['winner'].toString()}',
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
                                      timeinSecond:
                                          (widget.snap['startdate'].toDate())!
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
