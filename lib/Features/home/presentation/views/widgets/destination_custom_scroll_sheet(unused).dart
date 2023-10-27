import 'package:flutter/material.dart';
import 'package:user_app/Features/home/models/autocompletelocation.dart';
import 'package:user_app/Features/home/presentation/views/widgets/default_scroll_sheet.dart';

class CustomScrollSheetDestination extends StatefulWidget {
  const CustomScrollSheetDestination({
    super.key,
    required this.textcontroller,
    required this.labeltext,
    required this.hinttext,
    required this.onclicked,
  });
  final TextEditingController textcontroller;
  final String labeltext;
  final String hinttext;
  final onclicked;

  @override
  State<CustomScrollSheetDestination> createState() =>
      _CustomScrollSheetDestinationState();
}

class _CustomScrollSheetDestinationState
    extends State<CustomScrollSheetDestination> {
  DraggableScrollableController sheetcontroller =
      DraggableScrollableController();
  List<AutoCompleteModel> locations = [];

  @override
  Widget build(BuildContext context) {
    return DefaultScrollSheet(
      textcontroller: widget.textcontroller,
      labeltext: widget.labeltext,
      hinttext: widget.hinttext,
      onclicked: widget.onclicked,
      buttontext: const Text("PickUp"),
      sheetype: "dest",
    );
  }
}
