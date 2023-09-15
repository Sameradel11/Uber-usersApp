import 'package:flutter/material.dart';
import 'package:user_app/core/custom_text_field.dart';

class CustomScrollSheet extends StatelessWidget {
  const CustomScrollSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      
        initialChildSize: 0.13,
        maxChildSize: 0.23,
        minChildSize: 0.13,
        builder: (context, scrollController) {
          return AnimatedSize(
            duration: const Duration(milliseconds: 120),
            child: Container(
              
              color: Colors.black54,
              child: ListView(
                physics: const ClampingScrollPhysics(),
                controller: scrollController,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        height: 5,
                        width: 5,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const CustomTextField(label: Text("Pickup")),
                  const SizedBox(height: 20),
                  const CustomTextField(label: Text("Destination")),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          );
        });
  }
}
