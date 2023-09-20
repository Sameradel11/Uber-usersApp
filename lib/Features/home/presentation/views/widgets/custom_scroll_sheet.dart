import 'package:flutter/material.dart';
import 'package:user_app/core/custom_text_field.dart';

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
  bool tapped = false;
  DraggableScrollableController sheetcontroller =
      DraggableScrollableController();

  @override
  Widget build(BuildContext context) {
    sheetcontroller.addListener(
      () {
        print("sheet controller ${sheetcontroller.pixels}");
      },
    );
    return DraggableScrollableActuator(
        child: DraggableScrollableSheet(
      controller: sheetcontroller,
      initialChildSize: 0.22,
      minChildSize: 0.22,
      maxChildSize: 1,
      builder: (context, scrollController) {
        return Container(
          color: Colors.black54,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: AnimatedSize(
              duration: const Duration(seconds: 0),
              child: ListView(
                controller: scrollController,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 150.0, vertical: 8.0),
                    child: Container(
                      height: 5,
                      width: 5,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Focus(
                    child: CustomTextField(
                      controller: widget.pickupcontroller,
                      label: const Text("From\nPickup"),
                    ),
                    onFocusChange: (hasfocus) {
                      if (hasfocus) {
                        sheetcontroller.animateTo(1,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.linear);
                      } else {
                        sheetcontroller.reset();
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  const CustomTextField(label: Text("Destination")),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ),
        );
      },
    ));
  }
}
