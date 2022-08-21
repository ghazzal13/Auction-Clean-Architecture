import 'package:auction_clean_architecture/features/authentication/cubit/states.dart';
import 'package:auction_clean_architecture/features/authentication/cubit/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitialState());

  static AuthCubit get(context) => BlocProvider.of(context);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future createUser({
    required String name,
    required String email,
    required String address,
  }) async {
    Map<String, dynamic> user = {
      'image': 'https://i.stack.imgur.com/l60Hf.png',
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
}
