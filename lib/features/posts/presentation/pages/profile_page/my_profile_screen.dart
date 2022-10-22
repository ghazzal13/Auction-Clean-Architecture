import 'package:auction_clean_architecture/core/strings/failures.dart';
import 'package:auction_clean_architecture/features/authentication/cubit/auth_methoed.dart';
import 'package:auction_clean_architecture/features/posts/presentation/pages/profile_page/postcard_widget.dart';
import 'package:auction_clean_architecture/features/posts/presentation/pages/profile_page/settings_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';

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

  late var userModel;
  @override
  void initState() {
    userModel = AuthCubit.get(context).userData;
    Net();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
            icon: const Icon(Icons.shopping_cart),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
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
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return SizedBox(
                        height: (snapshot.data! as dynamic).docs.length * 500.0,
                        child: ListView.builder(
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
                        ),
                      );
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

            //
          ],
        ),
      ),
    );
  }
}
