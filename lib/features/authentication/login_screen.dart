import 'package:auction_clean_architecture/features/authentication/behavior.dart';
import 'package:auction_clean_architecture/features/authentication/cubit/auth_methoed.dart';
import 'package:auction_clean_architecture/features/authentication/singup_screen.dart';
import 'package:auction_clean_architecture/layout/layout.dart';
import 'package:auction_clean_architecture/reuse/reuse_navigator_method.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_validator/form_validator.dart';

import '../../core/app_theme.dart';
import '../../core/widgets/reuse_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
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

  var formkey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _address = TextEditingController();
  bool _isLoading = false;
  bool isPassword = true;
  var sss;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _address.dispose();
  }

  String messageEmail = '/';
  String messagePassword = '/';
  Future<String> loginUser({email, password}) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return "done";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        messageEmail = 'No user found for that email.';

        return "No user found for that email.";
      } else if (e.code == 'wrong-password') {
        setState(() {
          messagePassword = 'Wrong password provided for that user.';
        });
        return "Wrong password provided for that user.";
      } else {
        return "Something is Wrong plase try later.";
      }
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
                    height: size.width * 1.3,
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
                                  image:
                                      AssetImage('asset/image/mazadat_1.png'),
                                  fit: BoxFit.cover,
                                )),
                            const SizedBox(),
                            reuseFormField(
                              controller: _email,
                              type: TextInputType.emailAddress,
                              validate: ValidationBuilder(
                                      requiredMessage: 'can not be emity')
                                  .email()
                                  .add((_) {
                                if (messageEmail != '/') {
                                  return messageEmail;
                                }
                                return null;
                              }).build(),
                              label: 'email',
                              prefix: Icons.email,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(),
                            reuseFormField(
                              isPassword: isPassword,
                              controller: _password,
                              type: TextInputType.text,
                              validate: ValidationBuilder(
                                      requiredMessage: 'can not be emity')
                                  .minLength(6)
                                  .add((_) {
                                if (messagePassword != '/') {
                                  return messagePassword;
                                }
                                return null;
                              }).build(),
                              prefix: Icons.password,
                              label: 'password',
                              textInputAction: TextInputAction.done,
                              suffix: isPassword != true
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
                            ),
                            const SizedBox(),
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
                            const SizedBox(),
                            Login(),
                            const SizedBox(),
                            RichText(
                              text: TextSpan(
                                text: 'Create a new Account',
                                style: const TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 15,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    navigateTo(context, const SingUpScreen());
                                  },
                              ),
                            ),
                            const SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  Widget Login() {
    return FloatingActionButton.extended(
      backgroundColor: primaryColor,
      onPressed: () async {
        messageEmail = '/';

        messagePassword = '/';
        if (formkey.currentState!.validate()) {
          setState(() {
            _isLoading = true;
          });
          sss = await loginUser(email: _email.text, password: _password.text);
          if (sss == "done") {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => const ManagementLayout()),
                (route) => false);
          } else if (sss == "No user found for that email.") {
            setState(() {
              messageEmail = "No user found for that email.";
              formkey.currentState!.validate();
            });
          } else if (sss == "Wrong password provided for that user.") {
            setState(() {
              messagePassword = "Wrong password provided for that user.";
              formkey.currentState!.validate();
            });
          } else {
            showSnackBar(context, 'Something is wrong plase try later');
          }
        }
        setState(() {
          _isLoading = false;
        });
      },
      label: !_isLoading
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Padding(
                padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
              ),
            )
          : const CircularProgressIndicator(
              color: (Colors.white),
            ),
    );
  }
}
