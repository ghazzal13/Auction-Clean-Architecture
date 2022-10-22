import 'package:auction_clean_architecture/core/strings/failures.dart';
import 'package:auction_clean_architecture/features/posts/presentation/pages/profile_page/postcard_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';

import '../../../../authentication/cubit/auth_methoed.dart';

class ShoppingCartPage extends StatefulWidget {
  const ShoppingCartPage({super.key});

  @override
  State<ShoppingCartPage> createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
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
          ' Shopping Cart',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            net
                ? FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('posts')
                        .where('winner', isEqualTo: userModel.uid)
                        .where('enddate', isLessThan: DateTime.now())
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
                        height: (snapshot.data as dynamic).docs.length +
                            1.0 * 400.0,
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
