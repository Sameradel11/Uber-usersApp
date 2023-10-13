import 'package:flutter/material.dart';
import 'package:user_app/Features/home/models/autocompletelocation.dart';
import 'package:user_app/Features/home/presentation/views/widgets/scrollsheetwidgets/location_list_tile.dart';

class AutoCompleteListview extends StatelessWidget {
  const AutoCompleteListview({
    super.key,
    required this.locations,
    required this.sheetcontroller, required this.type,
  });

  final List<AutoCompleteModel> locations;
  final DraggableScrollableController sheetcontroller;
  final String type;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: ((context, index) => Container(
            child: LocationListTile(
              location: locations[index],
              sheetcontroller: sheetcontroller,
              type: type,
            ),
          )),
      separatorBuilder: (BuildContext context, int index) => const SizedBox(
        height: 10,
      ),
      itemCount: locations.length,
    );
  }
}
