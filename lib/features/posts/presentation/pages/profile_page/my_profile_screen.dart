import 'package:auction_clean_architecture/features/posts/presentation/pages/profile_page/pay_page.dart';
import 'package:auction_clean_architecture/features/posts/presentation/widget/offline_widget.dart';
import 'package:auction_clean_architecture/reuse/reuse_navigator_method.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';

import 'package:auction_clean_architecture/features/auction_event/cubit/cubit.dart';
import 'package:auction_clean_architecture/features/posts/presentation/pages/profile_page/shopping_cart_page.dart';

import '../../../../../core/strings/failures.dart';
import '../../widget/post_card_widget.dart';
import '../../widget/profile_header.dart';

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
  late var userModel;
  @override
  void initState() {
    userModel = AuctionCubit.get(context).userData;
    Net();
    super.initState();
  }

  late double h;
  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    print(h);
    print('bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb');
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          '  Mazadat',
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PaymentPage(),
                ),
              );
            },
            icon: const Icon(Icons.settings),
          ),
          IconButton(
            onPressed: () {
              navigateTo(context, const ShoppingCartPage());
            },
            icon: const Icon(Icons.shopping_cart),
          ),
        ],
      ),
      body: Column(
        children: [
          profileHeader(
            context,
            image: '${userModel.image}',
            name: '${userModel.name}',
            email: '${userModel.email}',
          ),
          const Divider(),
          SingleChildScrollView(
              child: net
                  ? SizedBox(
                      height: h - 234 - 155,
                      child: FutureBuilder(
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

                              return Postcard(
                                snap: snap,
                              );
                            },
                          );
                        },
                      ),
                    )
                  : offlineWidget()),
        ],
      ),
    );
  }
}
