import 'package:auction_clean_architecture/features/auction_event/cubit/states.dart';
import 'package:auction_clean_architecture/features/posts/presentation/pages/profile_page/settings_screen.dart';
import 'package:auction_clean_architecture/features/posts/presentation/widget/offline_widget.dart';
import 'package:auction_clean_architecture/reuse/reuse_navigator_method.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';

import 'package:auction_clean_architecture/features/auction_event/cubit/cubit.dart';
import 'package:auction_clean_architecture/features/posts/presentation/pages/profile_page/shopping_cart_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    AuctionCubit.get(context).getUserzData();
    userModel = AuctionCubit.get(context).userData;
    Net();
    super.initState();
  }

  late double h;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuctionCubit, AuctionStates>(
        listener: (conttext, state) {},
        builder: (context, state) {
          Size size = MediaQuery.of(context).size;
          userModel = AuctionCubit.get(context).userData;
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
                        builder: (context) => const SettingsScreen(),
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
                Column(
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
                                height: size.height - 234 - 155,
                                child: FutureBuilder(
                                  future: FirebaseFirestore.instance
                                      .collection('posts')
                                      .where('uid', isEqualTo: userModel.uid)
                                      .get(),
                                  builder: (context,
                                      AsyncSnapshot<
                                              QuerySnapshot<
                                                  Map<String, dynamic>>>
                                          snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }

                                    return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: (snapshot.data! as dynamic)
                                          .docs
                                          .length,
                                      itemBuilder: (context, index) {
                                        DocumentSnapshot snap =
                                            (snapshot.data! as dynamic)
                                                .docs[index];

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
              ],
            ),
          );
        });
  }
}
