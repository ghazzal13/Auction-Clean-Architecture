import 'package:auction_clean_architecture/features/authentication/cubit/auth_methoed.dart';
import 'package:auction_clean_architecture/layout/layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';

import '../../core/widgets/reuse_widget.dart';
import 'login_screen.dart';

class SingUpScreen extends StatefulWidget {
  const SingUpScreen({Key? key}) : super(key: key);

  @override
  State<SingUpScreen> createState() => _SingUpScreenState();
}

class _SingUpScreenState extends State<SingUpScreen> {
  var formkey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final bool _isLoading = false;
  var isPassword = true;

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _address.dispose();
  }

  String messageEmail = '/';

  void signUpUser({email, password}) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) {
        AuthCubit().createUser(
          name: _name.text,
          email: _email.text,
          address: _address.text,
        );
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const ManagementLayout()),
            (route) => false);
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        setState(() {
          messageEmail = 'The account already exists for that email.';
        });
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formkey,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
          child: Column(
            children: [
              Flexible(
                flex: 3,
                child: Container(),
              ),
              reuseFormField(
                controller: _name,
                type: TextInputType.text,
                validate: ValidationBuilder(requiredMessage: 'can not be emity')
                    .build(),
                label: 'name',
                prefix: Icons.person,
                textInputAction: TextInputAction.next,
              ),
              Flexible(
                flex: 2,
                child: Container(),
              ),
              reuseFormField(
                controller: _email,
                type: TextInputType.emailAddress,
                validate: ValidationBuilder(requiredMessage: 'can not be emity')
                    .email()
                    .build(),
                label: 'email',
                prefix: Icons.email,
                textInputAction: TextInputAction.next,
              ),
              Flexible(
                flex: 2,
                child: Container(),
              ),
              reuseFormField(
                controller: _password,
                type: TextInputType.text,
                validate: ValidationBuilder(requiredMessage: 'can not be emity')
                    .minLength(6)
                    .build(),
                label: 'password',
                prefix: Icons.password,
                textInputAction: TextInputAction.next,
              ),
              Flexible(
                flex: 2,
                child: Container(),
              ),
              reuseFormField(
                controller: _address,
                type: TextInputType.text,
                validate: ValidationBuilder(requiredMessage: 'can not be emity')
                    .build(),
                label: 'address',
                prefix: Icons.location_city,
                textInputAction: TextInputAction.done,
              ),
              Flexible(
                flex: 2,
                child: Container(),
              ),
              FloatingActionButton.extended(
                onPressed: () {
                  if (formkey.currentState!.validate()) {
                    signUpUser(email: _email.text, password: _password.text);
                  }
                },
                label: !_isLoading
                    ? Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                          child: Text('Sign Up'),
                        ),
                      )
                    : const CircularProgressIndicator(
                        color: (Colors.white),
                      ),
              ),
              Flexible(
                flex: 2,
                child: Container(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text(
                      'I have an account?',
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        ' Login.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
