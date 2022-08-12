import 'package:auction_clean_architecture/core/app_theme.dart';
import 'package:auction_clean_architecture/features/authentication/cubit/auth_methoed.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ManagementLayout extends StatefulWidget {
  const ManagementLayout({Key? key}) : super(key: key);

  @override
  State<ManagementLayout> createState() => _ManagementLayoutState();
}

class _ManagementLayoutState extends State<ManagementLayout> {
  int selectedIndex = 0;
  var currentUser;
  static const List<Widget> _widgetOptions = <Widget>[
    // PostsPage(),
    // AddPostPage(),
    // ProfileScreen()
  ];

  void onselect(int x) {
    setState(() {
      selectedIndex = x;
    });
  }

  void getData() {
    AuthCubit.get(context).getUserData(currentUser!.uid);
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
    return Scaffold(
      body: _widgetOptions.elementAt(selectedIndex),
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
    );
  }
}
