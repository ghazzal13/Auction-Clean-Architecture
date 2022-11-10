import 'package:auction_clean_architecture/features/auction_event/cubit/cubit.dart';
import 'package:auction_clean_architecture/features/posts/data/models/posts_model.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:intl/intl.dart';
import 'package:timer_count_down/timer_count_down.dart';

class SearchPostScreen extends StatefulWidget {
  const SearchPostScreen({Key? key}) : super(key: key);

  @override
  State<SearchPostScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchPostScreen> {
  late final TextEditingController _searchController = TextEditingController();
  final TextEditingController _reportController = TextEditingController();
  late bool isTap;
  late double width;
  @override
  void initState() {
    isTap = false;
    width = 0.2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !isTap
            ? const Text(
                'Search',
              )
            : const SizedBox(),
        actions: [
          SizedBox(
            width: MediaQuery.of(context).size.width * width,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    AuctionCubit.get(context).getSearch(value);
                  });
                },
                controller: _searchController,
                keyboardType: TextInputType.text,
                cursorColor: Colors.white,
                onTap: (() => setState(() {
                      isTap = true;
                      width = 0.89;
                    })),
                decoration: InputDecoration(
                  suffixIcon: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.teal,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: TextFormField(
              //     onChanged: (value) {
              //       setState(() {
              //         AuctionCubit.get(context).getSearch(value);
              //       });
              //     },
              //     controller: _searchController,
              //     keyboardType: TextInputType.text,
              //     decoration: InputDecoration(
              //       suffixIcon: const Icon(Icons.search),
              //       enabledBorder: OutlineInputBorder(
              //         borderSide: const BorderSide(
              //           color: Colors.teal,
              //           width: 1,
              //         ),
              //         borderRadius: BorderRadius.circular(25),
              //       ),
              //       focusedBorder: OutlineInputBorder(
              //         borderSide: const BorderSide(
              //           color: Colors.teal,
              //         ),
              //         borderRadius: BorderRadius.circular(25),
              //       ),
              //     ),
              //   ),
              // ),
              AuctionCubit.get(context).search.isNotEmpty
                  ? ListView.builder(
                      itemBuilder: (context, index) => buildSearchCard(
                        AuctionCubit.get(context).search[index],
                        context,
                        index,
                      ),
                      shrinkWrap: true,
                      itemCount: AuctionCubit.get(context).search.length,
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  var doo;
  Widget buildSearchCard(
    PostModel postmodel,
    context,
    index,
  ) =>
      postmodel.enddate!.isAfter(DateTime.now())
          ? GestureDetector(
              onTap: () {},
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.teal,
                                      backgroundImage:
                                          NetworkImage('${postmodel.image}'),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${postmodel.name}',
                                      style: TextStyle(
                                        color: Colors.teal[600],
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                        '${DateFormat.yMd().add_jm().format(postmodel.postTime!)} '),
                                  ],
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.32,
                                ),
                                postmodel.uid == "dddd"
                                    ? PopupMenuButton(
                                        onSelected: (value) {
                                          if (value.toString() == '/Delete') {
                                            showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                title: const Text(
                                                    'AlertDialog Title'),
                                                content: const Text(
                                                    'AlertDialog description'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, 'Cancel'),
                                                    child: const Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      // AuctionCubit.get(context)
                                                      //     .deletDoc(
                                                      //         'posts',
                                                      //         postmodel.postId
                                                      //             .toString());
                                                      Navigator.pop(
                                                          context, 'OK');
                                                    },
                                                    child: const Text('OK'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          } else if (value.toString() ==
                                              '/Edit') {}
                                        },
                                        itemBuilder: (BuildContext bc) {
                                          return const [
                                            PopupMenuItem(
                                              value: '/Delete',
                                              child: Text("Delete"),
                                            ),
                                            PopupMenuItem(
                                              value: '/Edit',
                                              child: Text("Edit"),
                                            ),
                                          ];
                                        },
                                      )
                                    : PopupMenuButton(
                                        onSelected: (value) {
                                          if (value.toString() == '/Report') {
                                            showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                title:
                                                    const Text('Report Post'),
                                                content: SizedBox(
                                                  height: 160,
                                                  child: Column(
                                                    children: [
                                                      const Text(
                                                          ' What is the  problem on with this post?'),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      TextFormField(
                                                        maxLines: 5,
                                                        minLines: 4,
                                                        controller:
                                                            _reportController,
                                                        validator:
                                                            ValidationBuilder()
                                                                .minLength(50)
                                                                .maxLength(250)
                                                                .build(),
                                                        decoration:
                                                            InputDecoration(
                                                          hintText: '....',
                                                          border:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                        ),
                                                        keyboardType:
                                                            TextInputType.text,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, 'Cancel'),
                                                    child: const Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {},
                                                    child: const Text('Send'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                        },
                                        itemBuilder: (BuildContext bc) {
                                          return const [
                                            PopupMenuItem(
                                              value: '/Report',
                                              child: Text("Report"),
                                            ),
                                          ];
                                        },
                                      ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.40,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${postmodel.titel}',
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
                                            ' ${DateFormat.yMd().add_jm().format(postmodel.startdate!)}  '),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.40,
                                        child: Text(
                                          '${postmodel.description}',
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
                                      DateTime.now()
                                              .isAfter(postmodel.startdate!)
                                          ? Container(
                                              alignment: Alignment.topLeft,
                                              child: Countdown(
                                                seconds: (postmodel.enddate)!
                                                    .difference(DateTime.now())
                                                    .inSeconds,
                                                build: (BuildContext context,
                                                        double time) =>
                                                    Text(
                                                  '${Duration(seconds: time.toInt()).inHours.remainder(24).toString()}:${Duration(seconds: time.toInt()).inMinutes.remainder(60).toString()}:${Duration(seconds: time.toInt()).inSeconds.remainder(60).toString().padLeft(2, '0')}',
                                                  style: const TextStyle(
                                                    fontSize: 30,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                                interval:
                                                    const Duration(seconds: 1),
                                                onFinished: () {},
                                              ),
                                            )
                                          : Container(
                                              alignment: Alignment.topLeft,
                                              child: Countdown(
                                                seconds: (postmodel.enddate)!
                                                    .difference(DateTime.now())
                                                    .inSeconds,
                                                build: (BuildContext context,
                                                        double time) =>
                                                    Text(
                                                  '${Duration(seconds: time.toInt()).inDays.remainder(365).toString()}:${Duration(seconds: time.toInt()).inHours.remainder(24).toString()}:${Duration(seconds: time.toInt()).inMinutes.remainder(60).toString()}:${Duration(seconds: time.toInt()).inSeconds.remainder(60).toString().padLeft(2, '0')}',
                                                  style: TextStyle(
                                                    fontSize: 25,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                ),
                                                interval:
                                                    const Duration(seconds: 1),
                                                onFinished: () {},
                                              ),
                                            ),
                                      Text(
                                        '${postmodel.category}',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.teal,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.52,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                          '${postmodel.postImage}',
                                        ),
                                        fit: BoxFit.cover),
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
            )
          : Container();
}
