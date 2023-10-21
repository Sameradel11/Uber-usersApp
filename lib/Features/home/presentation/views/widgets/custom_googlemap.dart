import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:user_app/Features/home/presentation/viewmodel/autocompelte/locationcubit.dart';
import 'package:user_app/core/const.dart';

// ignore: must_be_immutable
class CustomGoogleMap extends StatefulWidget {
  CustomGoogleMap(
      {super.key,
      required this.mycompleter,
      required this.mapcontroller,
      required this.polylist});
  final Completer mycompleter;
  GoogleMapController? mapcontroller;
  final List<LatLng> polylist;
  @override
  State<CustomGoogleMap> createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> {
  late Polyline polyline = const Polyline(polylineId: PolylineId("PolyLineID"));
  Set<Polyline> polylineset = {};
  Set<Marker> markerset = {};
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double bottompadding = MediaQuery.sizeOf(context).height * 0.2;
    return BlocConsumer<LocationCubit, Locationstate>(
      listener: (BuildContext context, Locationstate state) {
        if (state is LocationLatLngUpdated) {
          // get current latlng
          LatLng latlng = BlocProvider.of<LocationCubit>(context).latLng!;
          // Get the Address of current location and type it in text field
          BlocProvider.of<LocationCubit>(context).getaddressfromlatlang(latlng);
          // animate the camera to current latlng
          BlocProvider.of<LocationCubit>(context)
              .animatecamera(latlng, widget.mycompleter);
          markerset = {};
          markerset.add(
              Marker(markerId: const MarkerId('marker2'), position: latlng));
        } else if (state is LocationDirectionSuccess) {
          LatLng destination =
              BlocProvider.of<LocationCubit>(context).destinationlatlng!;
          markerset = {};
          markerset.add(
              Marker(markerId: const MarkerId('marker2'), position: destination));
          print("Direction is ready");
          polyline = Polyline(
              polylineId: const PolylineId(""),
              color: Colors.blue,
              jointType: JointType.mitered,
              points: widget.polylist,
              startCap: Cap.roundCap,
              endCap: Cap.roundCap,
              geodesic: true);
          polylineset.add(polyline);
          setState(() {});
        }
      },
      builder: (context, state) {
        LatLng latlng = BlocProvider.of<LocationCubit>(context).latLng ??
            const LatLng(0, 0);
        return SizedBox(
          height: MediaQuery.sizeOf(context).height,
          child: GoogleMap(
            padding: EdgeInsets.only(bottom: bottompadding),
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            myLocationEnabled: true,
            mapType: MapType.normal,
            initialCameraPosition: kGooglePlex,
            markers: markerset,
            polylines: {polyline},
            onMapCreated: (GoogleMapController controller) async {
              widget.mycompleter.complete(controller);
              await BlocProvider.of<LocationCubit>(context)
                  .getcurrentlocation(widget.mycompleter, "dest");
            },
          ),
        );
      },
    );
  }
}
