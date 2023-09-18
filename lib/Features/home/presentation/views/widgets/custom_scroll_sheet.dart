import 'package:flutter/material.dart';
import 'package:user_app/core/custom_text_field.dart';

class CustomScrollSheet extends StatefulWidget {
  const CustomScrollSheet({
    super.key,
  });

  @override
  State<CustomScrollSheet> createState() => _CustomScrollSheetState();
}

class _CustomScrollSheetState extends State<CustomScrollSheet> {
  bool tapped = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: tapped
          ? MediaQuery.sizeOf(context).height * 0.9
          : MediaQuery.sizeOf(context).height * 0.2,
      color: Colors.black54,
      child: ListView(
        physics: const ClampingScrollPhysics(),
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 150.0, vertical: 8.0),
            child: Container(
              height: 5,
              width: 5,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          CustomTextField(
            label: const Text("Pickup"),
            ontap: () {
              tapped = true;
              setState(() {});
            },
            onsubmitted: (value) {
              tapped = false;
              setState(() {});
            },
          ),
          const SizedBox(height: 20),
          const CustomTextField(label: Text("Destination")),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
