import 'package:flutter/material.dart';

showsnackbar(String text, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(text),
    duration: const Duration(seconds: 2),
  ));
}
