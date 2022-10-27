import 'package:auction_clean_architecture/features/auction_event/cubit/cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  var currentUser;
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
    super.initState();

    currentUser = FirebaseAuth.instance.currentUser;
    getData();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: _widgetOptions.elementAt(currentIndex),
/*
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'AddPost',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'profile',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.yellow,
        onTap: onselect,
        type: BottomNavigationBarType.fixed,
        backgroundColor: primaryColor,
        unselectedItemColor: Colors.white,
      ),
  */
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(10),
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


 
 
// import 'package:flutter/services.dart';
 
//   var currentIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     return Scaffold(
//       bottomNavigationBar: Container(
//         margin: EdgeInsets.all(20),
//         height: screenWidth * .155,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(.15),
//               blurRadius: 30,
//               offset: Offset(0, 10),
//             ),
//           ],
//           borderRadius: BorderRadius.circular(50),
//         ),
//         child: ListView.builder(
//           itemCount: 4,
//           scrollDirection: Axis.horizontal,
//           padding: EdgeInsets.symmetric(horizontal: screenWidth * .024),
//           itemBuilder: (context, index) => InkWell(
//             onTap: () {
//               setState(() {
//                 currentIndex = index;
//                 HapticFeedback.lightImpact();
//               });
//             },
//             splashColor: Colors.transparent,
//             highlightColor: Colors.transparent,
//             child: Stack(
//               children: [
//                 SizedBox(
//                   width: screenWidth * .2125,
//                   child: Center(
//                     child: AnimatedContainer(
//                       duration: Duration(seconds: 1),
//                       curve: Curves.fastLinearToSlowEaseIn,
//                       height: index == currentIndex ? screenWidth * .12 : 0,
//                       width: index == currentIndex ? screenWidth * .2125 : 0,
//                       decoration: BoxDecoration(
//                         color: index == currentIndex
//                             ? Colors.blueAccent.withOpacity(.2)
//                             : Colors.transparent,
//                         borderRadius: BorderRadius.circular(50),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   width: screenWidth * .2125,
//                   alignment: Alignment.center,
//                   child: Icon(
//                     listOfIcons[index],
//                     size: screenWidth * .076,
//                     color: index == currentIndex
//                         ? Colors.blueAccent
//                         : Colors.black26,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//  
// }