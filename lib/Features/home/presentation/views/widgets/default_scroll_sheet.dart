import 'dart:async';
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

class DefaultScrollSheet extends StatefulWidget {
  const DefaultScrollSheet({
    super.key,
    required this.textcontroller,
    required this.labeltext,
    required this.hinttext,
    required this.onclicked,
    required this.buttontext,
    required this.sheetype,
  });
  final TextEditingController textcontroller;
  final String labeltext;
  final String hinttext;
  final onclicked;
  final Text buttontext;
  final String sheetype;

  @override
  State<DefaultScrollSheet> createState() => _DefaultScrollSheetState();
}

class _DefaultScrollSheetState extends State<DefaultScrollSheet> {
  DraggableScrollableController sheetcontroller =
      DraggableScrollableController();
  bool isvisible = true;
  Timer? _debounce;
  List<AutoCompleteModel> locations = [];

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
                            if (_debounce?.isActive ?? false) {
                              _debounce!.cancel();
                            }
                            _debounce =
                                Timer(const Duration(milliseconds: 500), () {
                              BlocProvider.of<LocationCubit>(context)
                                  .autocomplete(value);
                            });
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
                      VisibilityButton(
                        isvisible: isvisible,
                        onclicked: widget.onclicked,
                        text: widget.buttontext,
                      ),
                      const SizedBox(height: 20),
                      AutoCompleteListview(
                        locations: locations,
                        sheetcontroller: sheetcontroller,
                        type: widget.sheetype,
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
