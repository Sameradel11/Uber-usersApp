import 'package:flutter/material.dart';
import 'package:user_app/core/style.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: Text(
        "hello mothe father",
        style: Style.textstyle18,
      )),
    );
  }
}
