// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:user_app/core/style.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      this.controller,
      this.label,
      this.prefix,
      this.onchange,
      this.onsubmitted,
      this.ontap,
      this.type = TextInputType.text,
      this.readonly = false,
      this.hidetext = false,
      this.action = TextInputAction.next,
      this.ontapoutside,
      this.hint,
      this.textcolor = Colors.white});
  final hidetext;
  final onchange;
  final onsubmitted;
  final TextEditingController? controller;
  final label;
  final prefix;
  final ontap;
  final ontapoutside;
  final TextInputType type;
  final bool readonly;
  final TextInputAction action;
  final hint;
  final Color textcolor;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTapOutside: ontapoutside,
      textInputAction: action,
      obscureText: hidetext,
      readOnly: readonly,
      keyboardType: type,
      onTap: ontap,
      onChanged: onchange,
      onFieldSubmitted: onsubmitted,
      controller: controller,
      style: TextStyle(fontSize: 18, color: textcolor),
      decoration: InputDecoration(
          hintText: hint,
          label: label,
          prefix: prefix,
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: BorderSide(color: Colors.red.shade800)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: BorderSide(color: Colors.blue.shade800)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: const BorderSide(color: Colors.white))),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '${label.data} is required';
        }
        return null;
      },
    );
  }
}

class CustomTextFieldLocation extends StatelessWidget {
  const CustomTextFieldLocation(
      {super.key,
      this.controller,
      this.label,
      this.prefix,
      this.onchange,
      this.onsubmitted,
      this.ontap,
      this.type = TextInputType.text,
      this.readonly = false,
      this.hidetext = false,
      this.action = TextInputAction.next,
      this.ontapoutside,
      this.hint});
  final hidetext;
  final onchange;
  final onsubmitted;
  final TextEditingController? controller;
  final label;
  final prefix;
  final ontap;
  final ontapoutside;
  final TextInputType type;
  final bool readonly;
  final TextInputAction action;
  final hint;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTapOutside: ontapoutside,
      textInputAction: action,
      obscureText: hidetext,
      readOnly: readonly,
      keyboardType: type,
      onTap: ontap,
      onChanged: onchange,
      onFieldSubmitted: onsubmitted,
      controller: controller,
      style: const TextStyle(fontSize: 18, color: Colors.black),
      decoration: InputDecoration(
          hintStyle: Style.textstyle18.copyWith(color: Colors.black),
          hintText: hint,
          label: label,
          prefix: prefix,
          disabledBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          border: InputBorder.none),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '${label.data} is required';
        }
        return null;
      },
    );
  }
}
