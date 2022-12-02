import 'package:auction_clean_architecture/core/app_theme.dart';
import 'package:auction_clean_architecture/features/authentication/behavior.dart';
import 'package:auction_clean_architecture/features/authentication/cubit/auth_methoed.dart';
import 'package:auction_clean_architecture/layout/layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_validator/form_validator.dart';

import '../../core/widgets/reuse_widget.dart';
import 'login_screen.dart';

class SingUpScreen extends StatefulWidget {
  const SingUpScreen({Key? key}) : super(key: key);

  @override
  State<SingUpScreen> createState() => _SingUpScreenState();
}

class _SingUpScreenState extends State<SingUpScreen>
    with SingleTickerProviderStateMixin {
  var formkey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final bool _isLoading = false;
  bool isPassword = true;
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _transform;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.ease,
      ),
    )..addListener(() {
        setState(() {});
      });

    _transform = Tween<double>(begin: 2, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.fastLinearToSlowEaseIn,
      ),
    );

    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _address.dispose();
    _controller.dispose();
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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SizedBox(
          height: size.height,
          child: Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.fromARGB(255, 94, 133, 143),
                  Color.fromARGB(255, 6, 101, 92)
                ],
              ),
            ),
            child: Opacity(
              opacity: _opacity.value,
              child: Transform.scale(
                scale: _transform.value,
                child: Container(
                  width: size.width * .9,
                  height: size.width * 1.7,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.1),
                        blurRadius: 90,
                      ),
                    ],
                  ),
                  child: Form(
                    key: formkey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const SizedBox(
                              height: 100,
                              child: Image(
                                image: AssetImage('asset/image/mazadat_1.png'),
                                fit: BoxFit.cover,
                              )),
                          reuseFormField(
                            controller: _name,
                            type: TextInputType.text,
                            validate: ValidationBuilder(
                                    requiredMessage: 'can not be emity')
                                .build(),
                            label: 'name',
                            prefix: Icons.person,
                            textInputAction: TextInputAction.next,
                          ),
                          reuseFormField(
                            controller: _email,
                            type: TextInputType.emailAddress,
                            validate: ValidationBuilder(
                                    requiredMessage: 'can not be emity')
                                .email()
                                .build(),
                            label: 'email',
                            prefix: Icons.email,
                            textInputAction: TextInputAction.next,
                          ),
                          reuseFormField(
                            controller: _password,
                            type: TextInputType.text,
                            validate: ValidationBuilder(
                                    requiredMessage: 'can not be emity')
                                .minLength(6)
                                .build(),
                            label: 'password',
                            prefix: Icons.password,
                            textInputAction: TextInputAction.next,
                            isPassword: isPassword,
                            suffix: isPassword != true
                                ? IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isPassword = !isPassword;
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.remove_red_eye_outlined,
                                    ),
                                  )
                                : IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isPassword = !isPassword;
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.remove_red_eye_rounded,
                                    ),
                                  ),
                          ),
                          reuseFormField(
                            controller: _address,
                            type: TextInputType.text,
                            validate: ValidationBuilder(
                                    requiredMessage: 'can not be emity')
                                .build(),
                            label: 'address',
                            prefix: Icons.location_city,
                            textInputAction: TextInputAction.done,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const SizedBox(),
                              Text(
                                'Sign In With ',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black.withOpacity(.7),
                                ),
                              ),
                              const SizedBox(),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(20)),
                                child: IconButton(
                                    onPressed: () {
                                      AuthCubit.get(context)
                                          .signInWithGoogle()
                                          .then(
                                            (_) => Navigator.of(context)
                                                .pushAndRemoveUntil(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const ManagementLayout()),
                                              (route) => false,
                                            ),
                                          );
                                    },
                                    icon: const FaIcon(
                                      FontAwesomeIcons.google,
                                      color: Colors.red,
                                      size: 28,
                                    )),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(20)),
                                child: IconButton(
                                    onPressed: () {
                                      AuthCubit.get(context)
                                          .signInWithFacebook()
                                          .then(
                                            (_) => Navigator.of(context)
                                                .pushAndRemoveUntil(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const ManagementLayout()),
                                              (route) => false,
                                            ),
                                          );
                                    },
                                    icon: const FaIcon(
                                        size: 28,
                                        FontAwesomeIcons.facebook,
                                        color: Colors.blue)),
                              ),
                              const SizedBox(),
                            ],
                          ),
                          FloatingActionButton.extended(
                            backgroundColor: primaryColor,
                            onPressed: () {
                              if (formkey.currentState!.validate()) {
                                signUpUser(
                                    email: _email.text,
                                    password: _password.text);
                              }
                            },
                            label: !_isLoading
                                ? Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: const Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(30, 10, 30, 10),
                                      child: Text(
                                        'Sign Up',
                                        style: TextStyle(
                                            fontSize: 25, color: Colors.white),
                                      ),
                                    ),
                                  )
                                : const CircularProgressIndicator(
                                    color: (Colors.white),
                                  ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
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
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
