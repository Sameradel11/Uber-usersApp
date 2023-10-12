import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scroll_to_hide/scroll_to_hide.dart';
import 'package:user_app/Features/Autentication/presentation/views/widgets/custom_elevated_button.dart';
import 'package:user_app/Features/home/models/autocompletelocation.dart';
import 'package:user_app/Features/home/presentation/viewmodel/autocompelte/locationcubit.dart';
import 'package:user_app/Features/home/presentation/views/widgets/handler.dart';
import 'package:user_app/Features/home/presentation/views/widgets/location_list_tile.dart';
import 'package:user_app/Features/home/presentation/views/widgets/text_row.dart';
import 'package:user_app/core/functions.dart';
import 'package:user_app/core/style.dart';

class CustomScrollSheet extends StatefulWidget {
  const CustomScrollSheet({
    super.key,
    required this.textcontroller,
    required this.destinationcontroller,
    required this.labeltext,
    required this.hinttext,
    required this.onsubmit,
  });
  final TextEditingController textcontroller;
  final TextEditingController destinationcontroller;
  final String labeltext;
  final String hinttext;
  final onsubmit;

  @override
  State<CustomScrollSheet> createState() => _CustomScrollSheetState();
}

class _CustomScrollSheetState extends State<CustomScrollSheet> {
  DraggableScrollableController sheetcontroller =
      DraggableScrollableController();
  List<AutoCompleteModel> locations = [];
  @override
  Widget build(BuildContext context) {
    sheetcontroller.addListener(
      () {
        print("sheet controller ${sheetcontroller.pixels}");
      },
    );
    return BlocConsumer<LocationCubit, Locationstate>(
      listener: (context, state) {
        if (state is Locationfiled) {
          showtoast(state.errmessage, context);
        } else if (state is LocationAutoCompleteSucces) {
          locations = state.locations;
        }
      },
      builder: (context, state) {
        return DraggableScrollableSheet(
          snapSizes: const [0.15, 0.94],
          snap: true,
          controller: sheetcontroller,
          initialChildSize: 0.15,
          minChildSize: 0.15,
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
                        onsubmit: widget.onsubmit,
                        controller: widget.textcontroller,
                        hint: widget.hinttext,
                      ),
                      onFocusChange: (hasfocus) {
                        changeFocus(
                            hasfocus, sheetcontroller, widget.textcontroller);
                      },
                    ),
                    CustomElevatedButton(
                        ontap: null, child: Text("Hello")),
                    const SizedBox(height: 20),
                    state is LocationLoading
                        ? const Center(child: CircularProgressIndicator())
                        : const SizedBox(),
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: ((context, index) => Container(
                            child: LocationListTile(
                              location: locations[index],
                              sheetcontroller: sheetcontroller,
                            ),
                          )),
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(
                        height: 10,
                      ),
                      itemCount: locations.length,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
