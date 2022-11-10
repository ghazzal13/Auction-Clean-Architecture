import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';

import '../../../../../core/widgets/reuse_widget.dart';
import '../../../login_screen.dart';

class NewPassWord extends StatefulWidget {
  const NewPassWord({Key? key}) : super(key: key);

  @override
  State<NewPassWord> createState() => _NewPassWordState();
}

class _NewPassWordState extends State<NewPassWord> {
  final TextEditingController passwordController = TextEditingController();

  final TextEditingController passwordconferimController =
      TextEditingController();

  var scaffoldKey = GlobalKey<ScaffoldState>();

  var formKey = GlobalKey<FormState>();

  var isPassword = true;

  @override
  void dispose() {
    super.dispose();
    passwordController.dispose();
    passwordconferimController.dispose();
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
    return Form(
        key: formKey,
        child: SingleChildScrollView(
            child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(
              height: 30.0,
            ),
            TextFormField(
              controller: passwordController,
              obscureText: isPassword,
              validator: ValidationBuilder(requiredMessage: 'can not be empty')
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
                        icon: const Icon(Icons.remove_red_eye_outlined))
                    : IconButton(
                        onPressed: () {
                          setState(() {
                            isPassword = !isPassword;
                          });
                        },
                        icon: const Icon(Icons.remove_red_eye_rounded)),
                hintText: 'New password',
                contentPadding: const EdgeInsets.all(8),
              ),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(
              height: 30.0,
            ),
            TextFormField(
              controller: passwordconferimController,
              obscureText: isPassword,
              validator: ValidationBuilder(requiredMessage: 'can not be empty')
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
                        icon: const Icon(Icons.remove_red_eye_outlined))
                    : IconButton(
                        onPressed: () {
                          setState(() {
                            isPassword = !isPassword;
                          });
                        },
                        icon: const Icon(Icons.remove_red_eye_rounded)),
                hintText: ' confirm password',
                contentPadding: const EdgeInsets.all(8),
              ),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(
              height: 50.0,
            ),
            FloatingActionButton.extended(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  if (passwordController.text !=
                      passwordconferimController.text) {
                    showToast(
                        text: 'Is Not The Same', state: ToastStates.ERROR);
                  } else {
                    changePassword(passwordController.text);
                  }
                }
              },
              backgroundColor: Colors.teal,
              icon: const Icon(Icons.save_outlined),
              label: const Text(
                'save',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0),
              ),
            ),
          ],
        )));
  }
}
