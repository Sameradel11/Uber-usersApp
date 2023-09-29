import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/Features/googlemap/presentation/viewmodel/location/location_cubit.dart';
import 'package:user_app/Features/home/models/autocompletelocation.dart';
import 'package:user_app/Features/home/presentation/viewmodel/autocompelte/autocomplete_cubit.dart';
import 'package:user_app/Features/home/presentation/views/widgets/location_list_tile.dart';
import 'package:user_app/Features/home/presentation/views/widgets/text_row.dart';
import 'package:user_app/core/functions.dart';
import 'package:user_app/core/style.dart';

class CustomScrollSheet extends StatefulWidget {
  const CustomScrollSheet({
    super.key,
    required this.pickupcontroller,
    required this.destinationcontroller,
  });
  final TextEditingController pickupcontroller;
  final TextEditingController destinationcontroller;

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
    return BlocProvider(
      create: (context) => AutocompleteCubit(),
      child: BlocConsumer<AutocompleteCubit, AutocompleteState>(
        listener: (context, state) {
          if (state is AutocompleFailed) {
            showtoast(state.errmessage, context);
          } else if (state is AutocompleteSuccess) {
            showtoast("data retreived successfully", context);
            locations = state.locations;
          }
        },
        builder: (context, state) {
          return DraggableScrollableActuator(
              child: DraggableScrollableSheet(
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
                        "From ?",
                        style: Style.textstyle22.copyWith(color: Colors.black),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Focus(
                        child: TextRow(
                          onchange: (value) async {
                            BlocProvider.of<AutocompleteCubit>(context)
                                .autocomplete(value);
                          },
                          controller: widget.pickupcontroller,
                          hint: "Pick Up",
                        ),
                        onFocusChange: (hasfocus) {
                          changeFocus(hasfocus);
                        },
                      ),
                      const SizedBox(height: 20),
                      state is AutocompleteLoading
                          ? const Center(child: CircularProgressIndicator())
                          : const SizedBox(),
                      state is AutocompleteLoading
                          ? const SizedBox()
                          : ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: ((context, index) => Container(
                                    child: GestureDetector(
                                      onTap: () {
                                        BlocProvider.of<LocationCubit>(context)
                                            .getlatlangfromplaceid(
                                                locations[index].placid);
                                      },
                                      child: LocationListTile(
                                          location: locations[index]),
                                    ),
                                  )),
                              separatorBuilder:
                                  (BuildContext context, int index) =>
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
          ));
        },
      ),
    );
  }

  void changeFocus(bool hasfocus) {
    if (hasfocus) {
      sheetcontroller.animateTo(1,
          duration: const Duration(milliseconds: 300), curve: Curves.linear);
      widget.pickupcontroller.selection = TextSelection(
          baseOffset: 0, extentOffset: widget.pickupcontroller.text.length);
    }
  }
}

class Handler extends StatelessWidget {
  const Handler({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 150.0, vertical: 8.0),
      child: Container(
        height: 5,
        width: 5,
        color: Colors.grey.shade500,
      ),
    );
  }
}
