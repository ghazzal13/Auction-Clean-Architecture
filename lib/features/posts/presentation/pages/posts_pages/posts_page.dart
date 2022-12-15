import 'package:auction_clean_architecture/features/posts/presentation/pages/posts_pages/app_bar_screens/categories_screen.dart';
import 'package:auction_clean_architecture/features/posts/presentation/widget/post_card_widget.dart';
import 'package:auction_clean_architecture/features/posts/presentation/widget/search_post_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';

import '../../../../../core/strings/failures.dart';
import '../../../../auction_event/cubit/cubit.dart';
import '../../../../authentication/cubit/auth_methoed.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({
    Key? key,
  }) : super(key: key);

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  late TextEditingController searchController = TextEditingController();
  var userId;
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
  void initState() {
    userId = AuthCubit.get(context).userData.uid;
    AuctionCubit.get(context).getUserzData();
    Net();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  late bool searchBoolean = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: !searchBoolean
            ? const Text('  Auctions')
            : TextFormField(
                onChanged: (value) {
                  setState(() {
                    AuctionCubit.get(context).getSearch(value.toUpperCase());
                  });
                },
                controller: searchController,
                autofocus: true,
                cursorColor: Colors.white,
                style: const TextStyle(color: Colors.white, fontSize: 20),
                textInputAction: TextInputAction.search,
                decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    hintText: 'Search',
                    hintStyle: TextStyle(
                      color: Colors.white60,
                      fontSize: 20,
                    ))),
        actions: [
          !searchBoolean
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      searchController.text = '';
                      searchBoolean = true;
                    });
                  },
                  icon: const Icon(Icons.search),
                )
              : IconButton(
                  onPressed: () {
                    setState(() {
                      searchBoolean = false;
                      searchController.text = '';
                    });
                  },
                  icon: const Icon(Icons.clear),
                ),
          PopupMenuButton(
            onSelected: (value) {
              if (value.toString() == '/Category') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CategoriesScreen()),
                );
              }
            },
            itemBuilder: (BuildContext bc) {
              return const [
                PopupMenuItem(
                  value: '/Category',
                  child: Text("Category"),
                ),
              ];
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            height: size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("asset/image/222.jpg"),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          net
              ? !searchBoolean
                  ? StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('posts')
                          .where('enddate', isGreaterThan: DateTime.now())
                          .orderBy('enddate', descending: false)
                          .snapshots(),
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
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (ctx, index) => Postcard(
                            snap: snapshot.data!.docs[index].data(),
                          ),
                        );
                      })
                  : AuctionCubit.get(context).search.isNotEmpty
                      ? ListView.builder(
                          itemBuilder: (ctx, index) => SearchPostCard(
                              postModel:
                                  AuctionCubit.get(context).search[index]),
                          shrinkWrap: true,
                          itemCount: AuctionCubit.get(context).search.length,
                        )
                      : Container()
              : Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.wifi_off,
                          size: 50,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(OFFLINE_FAILURE_MESSAGE),
                        SizedBox(height: 100)
                      ]),
                ),
        ],
      ),
    );
  }
}
