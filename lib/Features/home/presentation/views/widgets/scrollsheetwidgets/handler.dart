import 'package:flutter/material.dart';

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
