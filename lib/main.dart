import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'core/app_theme.dart';
import 'features/authentication/cubit/auth_methoed.dart';
import 'features/authentication/login_screen.dart';
import 'layout/layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/auction_event/cubit/cubit.dart';
import 'features/posts/di/posts_injector.dart' as di;
import 'package:firebase_core/firebase_core.dart';
import 'features/posts/presentation/blocs/posts_bloc.dart';
import 'firebase_options.dart';
import 'package:page_transition/page_transition.dart';
import 'layout/border/bording_screen.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
      overlays: [SystemUiOverlay.bottom]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool onBording = false;

  Future<void> getBorderCachedData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      onBording = prefs.getBool('onBordering') ?? false;
    });
  }

  @override
  void initState() {
    super.initState();
    getBorderCachedData();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => di.sl<PostsBloc>()..add(GetAllPostsEvent())),
        BlocProvider(create: (BuildContext context) => AuthCubit()),
        BlocProvider(create: (BuildContext context) => AuctionCubit()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: appTheme,
          home: AnimatedSplashScreen(
              duration: 1000,
              splash: Container(
                width: 200.0,
                height: 200.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    10.0,
                  ),
                  image: const DecorationImage(
                    image: AssetImage(
                      'asset/image/mazadat_1.png',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              splashIconSize: 200,
              nextScreen: StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      // return const SecondPage(page: ManagementLayout());
                      return const ManagementLayout();
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('${snapshot.error}'),
                      );
                    }
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return !onBording
                      // ? const  SecondPage(page: OnBorderingScreen())
                      ? const OnBorderingScreen()
                      // : const SecondPage(page: LoginScreen());
                      : const LoginScreen();
                  // return const LoginScreen();
                },
              ),
              splashTransition: SplashTransition.fadeTransition,
              pageTransitionType: PageTransitionType.theme,
              backgroundColor: const Color.fromARGB(255, 6, 101, 92))),
    );
  }
}


//npm install -g npm@8.19.2

//https://makeup-api.herokuapp.com/api/v1/products.json?brand=maybelline
 
   