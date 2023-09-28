import 'package:flutter/material.dart';
import 'package:user_app/core/const.dart';
import 'package:user_app/core/custom_text_field.dart';

class TextRow extends StatelessWidget {
  const TextRow(
      {super.key, this.controller, this.hint, this.onsubmit, this.onchange});
  final TextEditingController? controller;
  final hint;
  final onsubmit;
  final onchange;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: textfieldcolor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            const Icon(
              Icons.search,
              size: 29,
              color: Colors.black,
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: CustomTextFieldLocation(
                onchange: onchange,
                onsubmitted: onsubmit,
                hint: hint,
                controller: controller,
              ),
            ),
            const SizedBox(
              width: 20,
            )
          ],
        ),
      ),
    );
  }
}
