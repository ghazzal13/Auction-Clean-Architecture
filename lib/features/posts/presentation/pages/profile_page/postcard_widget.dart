import 'package:auction_clean_architecture/features/auction_event/post_details_page.dart';
import 'package:auction_clean_architecture/features/posts/domain/entities/posts_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timer_count_down/timer_count_down.dart';

Widget PostCard({context, required dynamic snap}) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OnlineEventScreen(
            duration: (snap['startdate'].toDate())!
                .difference(DateTime.now())
                .inSeconds,
            post1: PostsEntity(
              uid: snap['uid'].toString(),
              name: snap['name'].toString(),
              image: snap['image'].toString(),
              price: snap['price'],
              postImage: snap['postImage'].toString(),
              postId: snap['postId'].toString(),
              category: snap['category'].toString(),
              startdate: DateTime.parse(snap['startdate'].toDate().toString()),
              enddate: DateTime.parse(snap['enddate'].toDate().toString()),
              postTime: DateTime.parse(snap['postTime'].toDate().toString()),
              titel: snap['titel'].toString(),
              description: snap['description'].toString(),
              winner: snap['winner'].toString(),
              winnerID: snap['winnerID'].toString(),
            ),
            postId: snap['postId'].toString(),
          ),
        ),
      );
    },
    child: Padding(
      padding: const EdgeInsets.only(
        left: 5,
        right: 5,
        top: 5,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.teal.withOpacity(0.2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                            snap['postImage'].toString(),
                          ),
                          fit: BoxFit.cover),
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            Column(
                              children: [
                                Text(
                                  snap['titel'].toString(),
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.teal[600],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                  ' ${DateFormat.yMd().add_jm().format(snap['startdate'].toDate())}  '),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.40,
                              child: Text(
                                snap['description'].toString(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.teal[600],
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            (DateTime.now()
                                        .isAfter(snap['startdate'].toDate()) &&
                                    DateTime.now()
                                        .isBefore(snap['enddate'].toDate()))
                                ? CounterDownStarted(
                                    timeinSecond: (snap['enddate'].toDate())!
                                        .difference(DateTime.now())
                                        .inSeconds)
                                : (DateTime.now().isBefore(
                                            snap['startdate'].toDate()) &&
                                        DateTime.now()
                                            .isBefore(snap['enddate'].toDate()))
                                    ? CounterDown(
                                        timeinSecond:
                                            (snap['startdate'].toDate())!
                                                .difference(DateTime.now())
                                                .inSeconds,
                                      )
                                    : Container(
                                        child: const Text(
                                          'the Auction is ended',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                            Text(
                              snap['category'].toString(),
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.teal,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget CounterDownStarted({
  required int timeinSecond,
}) =>
    Container(
      alignment: Alignment.topLeft,
      child: Countdown(
        seconds: timeinSecond,
        build: (BuildContext context, double time) => Text(
          '${Duration(seconds: time.toInt()).inHours.remainder(24).toString()}:${Duration(seconds: time.toInt()).inMinutes.remainder(60).toString()}:${Duration(seconds: time.toInt()).inSeconds.remainder(60).toString().padLeft(2, '0')}',
          style: const TextStyle(
            fontSize: 30,
            color: Colors.red,
          ),
        ),
        interval: const Duration(seconds: 1),
        onFinished: () {},
      ),
    );

Widget CounterDown({
  required int timeinSecond,
}) =>
    Container(
      alignment: Alignment.topLeft,
      child: Countdown(
        seconds: timeinSecond,
        build: (BuildContext context, double time) => Text(
          '${Duration(seconds: time.toInt()).inDays.remainder(365).toString()}:${Duration(seconds: time.toInt()).inHours.remainder(24).toString()}:${Duration(seconds: time.toInt()).inMinutes.remainder(60).toString()}:${Duration(seconds: time.toInt()).inSeconds.remainder(60).toString().padLeft(2, '0')}',
          style: TextStyle(
            fontSize: 25,
            color: Theme.of(context).primaryColor,
          ),
        ),
        interval: const Duration(seconds: 1),
        onFinished: () {},
      ),
    );
