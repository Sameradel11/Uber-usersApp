import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:user_app/Features/googlemap/presentation/viewmodel/location/location_cubit.dart';
import 'package:user_app/core/const.dart';

// ignore: must_be_immutable
class CustomGoogleMap extends StatefulWidget {
  CustomGoogleMap(
      {super.key, required this.mycompleter, required this.mapcontroller});
  final Completer mycompleter;
  GoogleMapController? mapcontroller;
  @override
  State<CustomGoogleMap> createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> {
  @override
  void initState() {
    super.initState();
    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    double bottompadding = MediaQuery.sizeOf(context).height * 0.2;
    return BlocBuilder<LocationCubit, LocationState>(
      builder: (context, state) {
        LocationCubit cubit = LocationCubit.get(context);
        return SizedBox(
          height: MediaQuery.sizeOf(context).height,
          child: GoogleMap(
            padding: EdgeInsets.only(bottom: bottompadding),
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            myLocationEnabled: true,
            mapType: MapType.normal,
            initialCameraPosition: kGooglePlex,
            onMapCreated: (GoogleMapController controller) async {
              widget.mycompleter.complete(controller);
              widget.mapcontroller = controller;
              await cubit.getcurrentlocation(controller);
            },
          ),
        );
      },
    );
  }
}
