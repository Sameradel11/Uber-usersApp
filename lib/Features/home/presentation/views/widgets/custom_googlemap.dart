import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:user_app/core/const.dart';
import 'package:user_app/core/functions.dart';

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
    getlocationpermission();
  }

  @override
  Widget build(BuildContext context) {
    double bottompadding = MediaQuery.sizeOf(context).height * 0.2;
    return Container(
      height: MediaQuery.sizeOf(context).height,
      child: GoogleMap(
        padding: EdgeInsets.only(bottom: bottompadding),
        zoomControlsEnabled: true,
        zoomGesturesEnabled: true,
        myLocationEnabled: true,
        mapType: MapType.normal,
        initialCameraPosition: kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          widget.mycompleter.complete(controller);
          widget.mapcontroller = controller;
          getcurrentlocation(widget.mapcontroller);
        },
      ),
    );
  }

  Future<void> getcurrentlocation(controller) async {
    Position currentlocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    LatLng currentlatlang =
        LatLng(currentlocation.latitude, currentlocation.longitude);

    CameraPosition currentcameraposition =
        CameraPosition(target: currentlatlang, zoom: 14);

    controller
        .animateCamera(CameraUpdate.newCameraPosition(currentcameraposition));
  }

  getlocationpermission() async {
    if (Geolocator.checkPermission() != LocationPermission.always ||
        Geolocator.checkPermission() != LocationPermission.whileInUse) {
      LocationPermission _locationpremission =
          await Geolocator.requestPermission();
      if (_locationpremission == LocationPermission.denied) {
        showtoast("App won't work without location permisiion", context);
      }
    }
  }
}
