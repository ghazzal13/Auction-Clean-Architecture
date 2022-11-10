import 'package:auction_clean_architecture/core/app_theme.dart';
import 'package:auction_clean_architecture/features/authentication/cubit/auth_methoed.dart';
import 'package:auction_clean_architecture/features/authentication/login_screen.dart';
import 'package:auction_clean_architecture/layout/layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/auction_event/cubit/cubit.dart';
import 'features/posts/di/posts_injector.dart' as di;
import 'package:firebase_core/firebase_core.dart';
import 'features/posts/presentation/blocs/posts_bloc.dart';
import 'firebase_options.dart';
import 'layout/border/bording_screen.dart';
import 'dart:async';

import 'layout/start_page_animation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const SecondPage(page: ManagementLayout());
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
                ? const SecondPage(page: OnBorderingScreen())
                : const SecondPage(page: LoginScreen());
            // return const LoginScreen();
          },
        ),
      ),
    );
  }
}


//npm install -g npm@8.19.2

//https://makeup-api.herokuapp.com/api/v1/products.json?brand=maybelline