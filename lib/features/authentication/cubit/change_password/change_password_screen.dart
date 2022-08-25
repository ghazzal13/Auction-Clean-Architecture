import 'package:auction_clean_architecture/features/auction_event/cubit/states.dart';
import 'package:auction_clean_architecture/features/authentication/cubit/change_password/widgets/text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_validator/form_validator.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/widgets/reuse_widget.dart';
import '../../../auction_event/cubit/cubit.dart';
import '../auth_methoed.dart';
import '../../login_screen.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  final TextEditingController oldpasswordController = TextEditingController();

  var isPassword = true;
  var isLogin = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // passwordController.dispose();
    // passwordconferimController.dispose();
    oldpasswordController.dispose();
  }

  Future<void> loginUser(String? email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email!,
        password: password,
      );
      setState(() {
        isLogin = true;
      });
      print(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        // print('Wrong password provided for that user.');
        showSnackBar(context, 'Wrong password provided for that user.');
      } else {
        showSnackBar(context, 'something is wrong ,Plase Try Later.');
      }
    }
  }

  final user = FirebaseAuth.instance.currentUser;
  changePassword(String yourPassword) async {
    await user!.updatePassword(yourPassword).then((_) {
      FirebaseAuth.instance.signOut().then((value) => Navigator.of(context)
          .pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false));
    }).catchError((error) {
      print("Error $error");
      showToast(text: error, state: ToastStates.ERROR);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuctionCubit, AuctionStates>(
      listener: (conttext, state) {},
      builder: (context, state) {
        var userModel = AuthCubit.get(context).userData;

        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: primaryColor,
            title: const Text('Change Password'),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      isLogin == true
                          ? const NewPassWord()
                          : Column(
                              children: [
                                const SizedBox(
                                  height: 30.0,
                                ),
                                TextFormField(
                                  controller: oldpasswordController,
                                  obscureText: isPassword,
                                  validator: ValidationBuilder(
                                          requiredMessage: 'can not be empty')
                                      .minLength(6)
                                      .maxLength(50)
                                      .build(),
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Colors.teal,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Colors.teal,
                                      ),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    suffixIcon: isPassword != true
                                        ? IconButton(
                                            onPressed: () {
                                              setState(() {
                                                isPassword = !isPassword;
                                              });
                                            },
                                            icon: const Icon(
                                                Icons.remove_red_eye_outlined))
                                        : IconButton(
                                            onPressed: () {
                                              setState(() {
                                                isPassword = !isPassword;
                                              });
                                            },
                                            icon: const Icon(
                                                Icons.remove_red_eye_rounded)),
                                    hintText: ' old password',
                                    contentPadding: const EdgeInsets.all(8),
                                  ),
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                ),
                                const SizedBox(
                                  height: 50.0,
                                ),
                                FloatingActionButton.extended(
                                  onPressed: () async {
                                    print(userModel.email.toString());
                                    if (formKey.currentState!.validate()) {
                                      await loginUser(userModel.email,
                                          oldpasswordController.text);
                                    }
                                  },
                                  backgroundColor: Colors.teal,
                                  icon: const Icon(Icons.save_outlined),
                                  label: const Text(
                                    'confirm',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0),
                                  ),
                                ),
                              ],
                            )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
