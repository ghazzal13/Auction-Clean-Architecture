import 'package:auction_clean_architecture/features/authentication/cubit/auth_methoed.dart';
import 'package:auction_clean_architecture/features/authentication/cubit/user.dart';
import 'package:auction_clean_architecture/features/posts/presentation/blocs/posts_bloc.dart';
import 'package:auction_clean_architecture/features/posts/presentation/pages/profile_page/settings_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:timer_count_down/timer_count_down.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var net = true;
  Future Net() async {
    var x = await DataConnectionChecker().hasConnection;
    if (x == false) {
      setState(() {
        net = x;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostsBloc, PostsState>(
        listener: (context, state) {},
        builder: (context, state) {
          // var userModel = AuthCubit.get(context).userData;
          UserModel userModel = UserModel();
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.teal,
              title: const Text(
                '  Mazadat',
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.settings),
                ),
              ],
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Align(
                            alignment: AlignmentDirectional.topCenter,
                            child: Container(
                              height: 70.0,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(
                                    4.0,
                                  ),
                                  topRight: Radius.circular(
                                    4.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          CircleAvatar(
                            radius: 64.0,
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            child: CircleAvatar(
                              radius: 60.0,
                              backgroundImage: NetworkImage(
                                '${userModel.image}',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        '${userModel.name}',
                        style: const TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${userModel.email}',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  ),
                ),
                const Divider(),
                net
                    ? FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('posts')
                            .where('uid', isEqualTo: userModel.uid)
                            .get(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: (snapshot.data! as dynamic).docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot snap =
                                  (snapshot.data! as dynamic).docs[index];

                              return PostCard(
                                context: context,
                                snap: snap,
                              );
                            },
                          );
                        })
                    : Container(),
              ],
            ),
          );
        });
  }

  Widget PostCard({context, required dynamic snap}) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => OnlineEventScreen(
        //       duration: (snap['startdate'].toDate())!
        //           .difference(DateTime.now())
        //           .inSeconds,
        //       post1: PostsEntity(
        //         uid: snap['uid'].toString(),
        //         name: snap['name'].toString(),
        //         image: snap['image'].toString(),
        //         price: snap['price'],
        //         postImage: snap['postImage'].toString(),
        //         postId: snap['postId'].toString(),
        //         category: snap['category'].toString(),
        //         startdate:
        //             DateTime.parse(snap['startdate'].toDate().toString()),
        //         enddate: DateTime.parse(snap['enddate'].toDate().toString()),
        //         postTime: DateTime.parse(snap['postTime'].toDate().toString()),
        //         titel: snap['titel'].toString(),
        //         description: snap['description'].toString(),
        //         winner: snap['winner'].toString(),
        //         winnerID: snap['winnerID'].toString(),
        //       ),
        //       postId: snap['postId'].toString(),
        //     ),
        //   ),
        // );
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
                              (DateTime.now().isAfter(
                                          snap['startdate'].toDate()) &&
                                      DateTime.now()
                                          .isBefore(snap['enddate'].toDate()))
                                  ? CounterDownStarted(
                                      timeinSecond: (snap['enddate'].toDate())!
                                          .difference(DateTime.now())
                                          .inSeconds)
                                  : CounterDown(
                                      timeinSecond:
                                          (snap['startdate'].toDate())!
                                              .difference(DateTime.now())
                                              .inSeconds,
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
}
