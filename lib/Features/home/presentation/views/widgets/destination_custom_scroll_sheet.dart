import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/Features/home/models/autocompletelocation.dart';
import 'package:user_app/Features/home/presentation/viewmodel/autocompelte/locationcubit.dart';
import 'package:user_app/Features/home/presentation/views/widgets/scrollsheetwidgets/auto_complete_listview.dart';
import 'package:user_app/Features/home/presentation/views/widgets/scrollsheetwidgets/handler.dart';
import 'package:user_app/Features/home/presentation/views/widgets/scrollsheetwidgets/text_row.dart';
import 'package:user_app/core/functions.dart';
import 'package:user_app/core/style.dart';

import 'scrollsheetwidgets/visibility_button.dart';

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
      },
      builder: (context, state) {
        return NotificationListener<DraggableScrollableNotification>(
          onNotification: buttonListener,
          child: DraggableScrollableSheet(
            snapSizes: const [0.2, 0.94],
            snap: true,
            controller: sheetcontroller,
            initialChildSize: 0.2,
            minChildSize: 0.2,
            maxChildSize: 1,
            builder: (context, scrollController) {
              return Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ListView(
                    controller: scrollController,
                    children: [
                      const Handler(),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.labeltext,
                        style: Style.textstyle22.copyWith(color: Colors.black),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Focus(
                        child: TextRow(
                          onchange: (value) async {
                            BlocProvider.of<LocationCubit>(context)
                                .autocomplete(value);
                          },
                          controller: widget.textcontroller,
                          hint: widget.hinttext,
                        ),
                        onFocusChange: (hasfocus) {
                          changeFocus(
                              hasfocus, sheetcontroller, widget.textcontroller);
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      VisibilityButton(isvisible: isvisible, onclicked: widget.onclicked),
                      const SizedBox(height: 20),
                      state is LocationLoading
                          ? const Center(child: CircularProgressIndicator())
                          : const SizedBox(),
                      AutoCompleteListview(
                          locations: locations,
                          sheetcontroller: sheetcontroller, type: 'dest',),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  bool buttonListener(notification) {
      print(notification.extent);
      if (notification.extent < 0.3) {
        if (isvisible != true) {
          print("Entered");
          setState(() {
            isvisible = true;
          });
        }
      } else {
        if (isvisible != false) {
          print("Entered");
          setState(() {
            isvisible = false;
          });
        }
      }
      return true;
    }
}

