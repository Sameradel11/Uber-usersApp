import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/Features/home/models/autocompletelocation.dart';
import 'package:user_app/Features/home/presentation/viewmodel/autocompelte/locationcubit.dart';
import 'package:user_app/Features/home/presentation/views/widgets/scrollsheetwidgets/auto_complete_listview.dart';
import 'package:user_app/Features/home/presentation/views/widgets/scrollsheetwidgets/handler.dart';
import 'package:user_app/Features/home/presentation/views/widgets/scrollsheetwidgets/text_row.dart';
import 'package:user_app/core/functions.dart';
import 'package:user_app/core/style.dart';
import 'dart:async';
import 'scrollsheetwidgets/visibility_button.dart';

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
  Timer? _debounce;

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
            snapSizes: const [0.23, 0.94],
            snap: true,
            controller: sheetcontroller,
            initialChildSize: 0.23,
            minChildSize: 0.23,
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
                            _debounce =
                                Timer(const Duration(milliseconds: 500), () {
                              BlocProvider.of<LocationCubit>(context)
                                  .autocomplete(value);
                            });
                            if (_debounce?.isActive ?? false) {
                              _debounce!.cancel();
                            }
                          },
                          controller: widget.pickupcontroller,
                          hint: widget.hinttext,
                        ),
                        onFocusChange: (hasfocus) {
                          changeFocus(hasfocus, sheetcontroller,
                              widget.pickupcontroller);
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      VisibilityButton(
                          isvisible: isvisible, onclicked: widget.onclicked),
                      const SizedBox(height: 20),
                      state is LocationLoading
                          ? const Center(child: CircularProgressIndicator())
                          : const SizedBox(),
                      AutoCompleteListview(
                        locations: locations,
                        sheetcontroller: sheetcontroller,
                        type: 'origin',
                      ),
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
