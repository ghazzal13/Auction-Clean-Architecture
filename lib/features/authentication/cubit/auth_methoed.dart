import 'package:auction_clean_architecture/features/authentication/cubit/states.dart';
import 'package:auction_clean_architecture/features/authentication/cubit/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitialState());

  static AuthCubit get(context) => BlocProvider.of(context);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future createUser({
    String? image,
    required String name,
    required String email,
    required String address,
  }) async {
    Map<String, dynamic> user = {
      'image': image ?? 'https://i.stack.imgur.com/l60Hf.png',
      'uid': _auth.currentUser!.uid,
      'name': name,
      'email': email,
      'address': address,
    };
    await _firestore.collection("users").doc(_auth.currentUser!.uid).set(user);
  }

  UserModel userData = UserModel();
  void getUserData(id) {
    FirebaseFirestore.instance.collection("users").doc(id).get().then((value) {
      print(value.data());
      userData = UserModel.fromMap(value.data());
    }).catchError((error) {});
    // return userData;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        // logging in user with email and password
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    // Once signed in, return the UserCredential
    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    if (userCredential.additionalUserInfo?.isNewUser == true) {
      createUser(
          image: userCredential.additionalUserInfo?.profile!['picture'],
          name: userCredential.additionalUserInfo?.profile!['given_name'],
          email: userCredential.additionalUserInfo?.profile!['email'],
          address: 'undefine');
    }
    print(userCredential);
    return userCredential;
  }

  void prints(var s1) {
    String s = s1.toString();
    final pattern = RegExp('.{1,800}');
    pattern.allMatches(s).forEach((match) => print(match.group(0)));
  }

  void printss(var s1) {
    String s = s1.toString();
    debugPrint(" =======> $s", wrapWidth: 20000);
  }

  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    final UserCredential userfaceCredential = await FirebaseAuth.instance
        .signInWithCredential(facebookAuthCredential);

    if (userfaceCredential.additionalUserInfo?.isNewUser == true) {
      createUser(
          name: userfaceCredential.additionalUserInfo!.profile!['name'],
          email: userfaceCredential.additionalUserInfo!.profile!['email'],
          address: 'undefine');
    }
    print(userfaceCredential.additionalUserInfo!.profile!);
    return userfaceCredential;
  }
}
