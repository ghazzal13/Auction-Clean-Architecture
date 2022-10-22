import 'package:auction_clean_architecture/features/posts/presentation/pages/posts_pages/app_bar_screens/categories_screen.dart';
import 'package:auction_clean_architecture/features/posts/presentation/pages/posts_pages/app_bar_screens/search_screen.dart';
import 'package:auction_clean_architecture/features/posts/presentation/widget/post_card_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';

import '../../../../../core/strings/failures.dart';
import '../../../../authentication/cubit/auth_methoed.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({
    Key? key,
  }) : super(key: key);

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
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
    Net();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          '  Auctions',
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchPostScreen(),
                ),
              );
            },
            icon: const Icon(Icons.search),
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
      body: net
          ? StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .where('enddate', isGreaterThan: DateTime.now())
                  .orderBy('enddate', descending: false)
                  .snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (ctx, index) => Container(
                          child: Postcard(
                            snap: snapshot.data!.docs[index].data(),
                            userId: userId,
                          ),
                        ));
              })
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
                    SizedBox(
                      height: 100,
                    )
                  ]),
            ),
    );
  }
}
