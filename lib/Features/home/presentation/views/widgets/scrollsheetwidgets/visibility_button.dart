import 'package:flutter/material.dart';

import '../../../../../Autentication/presentation/views/widgets/custom_elevated_button.dart';

class VisibilityButton extends StatelessWidget {
  const VisibilityButton({
    super.key,
    required this.isvisible,
    required this.onclicked,
    required this.text,
  });

  final bool isvisible;
  final onclicked;
  final Text text;

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: isvisible,
        child:
            CustomElevatedButton(ontap: onclicked, child: text));
  }
}
