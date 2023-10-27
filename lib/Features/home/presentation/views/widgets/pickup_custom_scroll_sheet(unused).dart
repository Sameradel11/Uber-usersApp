import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/Features/home/models/autocompletelocation.dart';
import 'package:user_app/Features/home/presentation/viewmodel/autocompelte/locationcubit.dart';
import 'package:user_app/Features/home/presentation/views/widgets/default_scroll_sheet.dart';
import 'package:user_app/core/functions.dart';

class CustomScrollSheetPickUp extends StatefulWidget {
  const CustomScrollSheetPickUp({
    super.key,
    required this.pickupcontroller,
    required this.labeltext,
    required this.hinttext,
    required this.onclicked,
  });
  final TextEditingController pickupcontroller;
  final String labeltext;
  final String hinttext;
  final onclicked;

  @override
  State<CustomScrollSheetPickUp> createState() =>
      _CustomScrollSheetDestinationState();
}

class _CustomScrollSheetDestinationState
    extends State<CustomScrollSheetPickUp> {
  DraggableScrollableController sheetcontroller =
      DraggableScrollableController();
  List<AutoCompleteModel> locations = [];
  bool isvisible = true;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LocationCubit, Locationstate>(
        listener: (context, state) {
      if (state is Locationfiled) {
        showtoast(state.errmessage, context);
      } else if (state is LocationAutoCompleteSucces) {
        locations = state.locations;
      }
    }, builder: (context, state) {
      return DefaultScrollSheet(
        textcontroller: widget.pickupcontroller,
        labeltext: widget.labeltext,
        hinttext: widget.hinttext,
        onclicked: widget.onclicked,
        buttontext: const Text("Route"),
        sheetype: "origin",
      );
    });
  }
}
