import 'dart:developer';

import 'package:flutter/material.dart';

import 'core/dependency_injection.dart';
import 'features/authentication/services/authentication_service.dart';
import 'features/authentication/views/login_page.dart';
import 'features/home/views/home_page.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoading = true;
  late bool isLoggedIn;

  @override
  void initState() {
    super.initState;
    checkAuth();
  }

  void checkAuth() async {
    try {
      await authenticationService.init();
    } catch (e) {
      log(e.toString());
    }
    setState(() {
      isLoading = false;
    });
    if (authenticationService.userManager.currentUser == null) {
      setState(() {
        isLoggedIn = false;
      });
    } else {
      setState(() {
        isLoggedIn = true;
      });
    }
  }

  final AuthenticationService authenticationService =
      AppDependencyInjector.getIt.get();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: (isLoading)
          ? const Scaffold(
              body: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            )
          : (isLoggedIn)
              ? const Home()
              : LoginPage(),
    );
  }
}
