import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:user_app/core/style.dart';

showsnackbar(String text, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(text),
    duration: const Duration(seconds: 2),
  ));
}

showtoast(String text, BuildContext context) {
  FToast fToast = FToast();
  fToast.init(context);
  fToast.showToast(
      child: Container(
        constraints: const BoxConstraints(minHeight: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            text,
            style: Style.textstyle16.copyWith(color: Colors.black),
          ),
        ),
      ),
      toastDuration: const Duration(seconds: 2));
}

void animateto(double size, controller) {
  controller.animateTo(size,
      duration: const Duration(milliseconds: 300), curve: Curves.linear);
}

void changeFocus(
    bool hasfocus, sheetcontroller, TextEditingController controller) {
  if (hasfocus) {
    animateto(1, sheetcontroller);
    controller.selection =
        TextSelection(baseOffset: 0, extentOffset: controller.text.length);
  }
}
