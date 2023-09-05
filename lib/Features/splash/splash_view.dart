import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/core/app_routes.dart';
import 'package:user_app/core/const.dart';
import 'package:user_app/core/style.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      GoRouter.of(context).push(AppRoutes.signin);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Welcome to users App",
            style: Style.textstyle20,
          ),
          Image.asset(Klogopath),
        ],
      ),
    );
  }
}
