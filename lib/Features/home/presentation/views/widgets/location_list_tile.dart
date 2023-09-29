import 'package:flutter/material.dart';
import 'package:user_app/Features/home/models/autocompletelocation.dart';
import 'package:user_app/core/style.dart';
class LocationListTile extends StatelessWidget {
  const LocationListTile({
    super.key,
    required this.location,
  });

  final AutoCompleteModel location;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minVerticalPadding: 0,
      leading: Container(
        decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(20)),
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(
            Icons.pin_drop,
            color: Colors.lightGreen,
          ),
        ),
      ),
      title: Text(
        location.maintext,
        style: Style.textstyle18.copyWith(color: Colors.black),
        overflow: TextOverflow.ellipsis,
      ),
      contentPadding: const EdgeInsets.only(left: 5, bottom: 0),
      subtitle: Text(
        location.description,
        maxLines: 2,
        style: Style.textstyle18.copyWith(color: Colors.grey.shade500),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}