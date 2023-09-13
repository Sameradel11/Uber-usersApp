import 'package:flutter/material.dart';
import 'package:user_app/core/style.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile(
      {super.key, required this.text, required this.ontap, required this.icon});
  final String text;
  final void Function()? ontap;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: ListTile(
        horizontalTitleGap: 2,
        leading: Icon(icon),
        title: Text(
          text,
          style: Style.textstyle18.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
