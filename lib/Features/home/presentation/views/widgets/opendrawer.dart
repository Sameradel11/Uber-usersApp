import 'package:flutter/material.dart';

class OpenDrawer extends StatelessWidget {
  const OpenDrawer({super.key, required this.scfkey});
  final GlobalKey<ScaffoldState> scfkey;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      left: 20,
      child: IconButton(
        onPressed: () {
          scfkey.currentState!.openDrawer();
        },
        icon: const Icon(
          Icons.menu,
          color: Colors.black,
        ),
        iconSize: 30,
      ),
    );
  }
}