import 'package:auction_clean_architecture/features/authentication/cubit/change_password/change_password_screen.dart';
import 'package:auction_clean_architecture/features/posts/presentation/pages/profile_page/edit_profile_screen.dart';
import 'package:auction_clean_architecture/features/posts/presentation/pages/profile_page/web_page.dart';
import 'package:auction_clean_architecture/reuse/reuse_navigator_method.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../authentication/login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '  Settings',
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
          Center(
            child: Padding(
              padding: const EdgeInsets.all(38.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.teal[200],
                    ),
                    child: TextButton(
                      onPressed: () {
                        navigateTo(context, const EditProfileScreen());
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Text(
                          'Edit Profile',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.teal[200],
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ChangePasswordScreen()),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Text(
                          'Change Password',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.teal[200],
                    ),
                    child: TextButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut().then(
                              (value) =>
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen(),
                                      ),
                                      (route) => false),
                            );
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Text(
                          'log out',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(),
                      IconButton(
                          onPressed: () {
                            navigateTo(context, const WebPage(url: 'github'));
                          },
                          icon: const FaIcon(
                            FontAwesomeIcons.github,
                            color: Colors.black,
                            size: 35,
                          )),
                      const SizedBox(
                        width: 10,
                      ),
                      IconButton(
                          onPressed: () {
                            navigateTo(context, const WebPage(url: 'linkedin'));
                          },
                          icon: const FaIcon(
                              size: 35,
                              FontAwesomeIcons.linkedin,
                              color: Colors.blue)),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
