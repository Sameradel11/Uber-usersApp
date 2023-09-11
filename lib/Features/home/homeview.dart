import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:user_app/core/const.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  GoogleMapController? mapcontroller;
  final mycontroller = Completer();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: Container(
    height: 700,
    child: GoogleMap(
      myLocationEnabled: true,
      mapType: MapType.normal,
      initialCameraPosition: kGooglePlex,
      onMapCreated: (GoogleMapController controller) {
        mycontroller.complete(controller);
        mapcontroller = controller;
      },
    ),
      ),
    );
  }
}
