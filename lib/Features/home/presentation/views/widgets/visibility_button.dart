import 'package:flutter/material.dart';
import 'package:user_app/Features/home/presentation/views/widgets/destination_custom_scroll_sheet.dart';

import '../../../../Autentication/presentation/views/widgets/custom_elevated_button.dart';

class VisibilityButton extends StatelessWidget {
  const VisibilityButton({
    super.key,
    required this.isvisible,
    required this.widget,
  });

  final bool isvisible;
  final CustomScrollSheetDestination widget;

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: isvisible,
        child: CustomElevatedButton(
            ontap: widget.onclicked,
            child: const Text("Hello")));
  }
}
