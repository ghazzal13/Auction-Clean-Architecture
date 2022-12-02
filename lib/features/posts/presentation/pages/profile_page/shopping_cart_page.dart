import 'package:auction_clean_architecture/core/strings/failures.dart';
import 'package:auction_clean_architecture/features/auction_event/cubit/cubit.dart';
import 'package:auction_clean_architecture/features/posts/presentation/widget/post_card_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';

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
    userModel = AuctionCubit.get(context).userData;
    Net();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(userModel.uid);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Shopping Cart',
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("asset/image/222.jpg"),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                net
                    ? StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('posts')
                            .where('winnerID', isEqualTo: userModel.uid)
                            .where('enddate', isLessThan: DateTime.now())
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
                          if (!snapshot.hasData) {
                            return Center(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    SizedBox(height: 30),
                                    Icon(Icons.remove_shopping_cart_outlined,
                                        size: 100),
                                    SizedBox(height: 30),
                                    Text(
                                      "you don't have any items in shopping cart",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 100)
                                  ]),
                            );
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: (snapshot.data! as dynamic).docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot snap =
                                  (snapshot.data! as dynamic).docs[index];
                              return Postcard(snap: snap);
                            },
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
        ],
      ),
    );
  }
}
