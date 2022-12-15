import 'package:auction_clean_architecture/features/auction_event/cubit/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../features/posts/presentation/pages/add_edit_post/add_post_screen.dart';
import '../features/posts/presentation/pages/posts_pages/posts_page.dart';
import '../features/posts/presentation/pages/profile_page/my_profile_screen.dart';

class ManagementLayout extends StatefulWidget {
  const ManagementLayout({Key? key}) : super(key: key);

  @override
  State<ManagementLayout> createState() => _ManagementLayoutState();
}

class _ManagementLayoutState extends State<ManagementLayout> {
  int currentIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    PostsPage(),
    AddPostPage(),
    ProfileScreen()
  ];

  void onselect(int x) {
    setState(() {
      currentIndex = x;
    });
  }

  void getData() {
    AuctionCubit.get(context).getUserzData();
    // AuctionCubit.get(context).getUserData();
  }

  @override
  void initState() {
    getData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: _widgetOptions.elementAt(currentIndex),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
        height: screenWidth * .155,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.15),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
          borderRadius: BorderRadius.circular(50),
        ),
        child: ListView.builder(
          itemCount: 3,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: screenWidth * .024),
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              setState(() {
                currentIndex = index;
                HapticFeedback.lightImpact();
              });
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Stack(
              children: [
                SizedBox(
                  width: screenWidth * .2993,
                  child: Center(
                    child: AnimatedContainer(
                      duration: const Duration(seconds: 1),
                      curve: Curves.fastLinearToSlowEaseIn,
                      height: index == currentIndex ? screenWidth * .12 : 0,
                      width: index == currentIndex ? screenWidth * .2800 : 0,
                      decoration: BoxDecoration(
                        color: index == currentIndex
                            ? Colors.teal[100]
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: screenWidth * .2993,
                  alignment: Alignment.center,
                  child: Icon(
                    listOfIcons[index],
                    size: screenWidth * .076,
                    color: index == currentIndex ? Colors.teal : Colors.black26,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<IconData> listOfIcons = [
    Icons.home_rounded,
    Icons.add_photo_alternate_outlined,
    Icons.person_rounded,
  ];
}
