import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../widget/post_card_widget.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  get color => Colors.black;
  final TextEditingController _reportController = TextEditingController();

  late bool select;
  var userId;
  @override
  void initState() {
    select = false;
    // userId = AuthCubit.get(context).userData.uid;
  }

  late String category;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text(
          'Categories',
          style: TextStyle(
              fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        child: select == false
            ? StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('category')
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return GridView.builder(
                    shrinkWrap: true,
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 1.5,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) {
                      DocumentSnapshot snap =
                          (snapshot.data! as dynamic).docs[index];

                      return Container(
                          child: CategoreCard(
                        context: context,
                        snap: snapshot.data!.docs[index].data(),
                      ));
                    },
                  );
                  /*ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (ctx, index) => Container(
                        child: CategoreCard(
                      context: context,
                      snap: snapshot.data!.docs[index].data(),
                    )),
                  );*/
                },
              )
            : StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .where('enddate', isGreaterThan: DateTime.now())
                    .where('category', isEqualTo: category)
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
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
                    )),
                  );
                },
              ),
      ),
    );
  }

  Widget CategoreCard({
    required dynamic snap,
    context,
  }) {
    return InkWell(
      onTap: () {
        setState(() {
          select = true;
        });
        category = snap['name'].toString();
        print(
          snap['name'].toString(),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        margin: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                  child: Image.network(
                    snap['image'].toString(),
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),

                ////
                ////
                ///
                ///

                ///
                ///
                ///
                Positioned(
                  bottom: 20,
                  right: 10,
                  child: Container(
                    color: Colors.black54,
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 20,
                    ),
                    child: Text(
                      snap['name'].toString(),
                      style: const TextStyle(
                        fontSize: 26,
                        color: Colors.white,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
