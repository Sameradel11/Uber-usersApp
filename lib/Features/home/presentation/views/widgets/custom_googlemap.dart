import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:user_app/Features/home/presentation/viewmodel/autocompelte/locationcubit.dart';
import 'package:user_app/core/const.dart';
import 'package:user_app/core/functions.dart';

// ignore: must_be_immutable
class CustomGoogleMap extends StatefulWidget {
  CustomGoogleMap(
      {super.key, required this.mycompleter, required this.polylist});
  final Completer mycompleter;
  final List<LatLng> polylist;

  @override
  State<CustomGoogleMap> createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> {
  Set<Polyline> polylineset = {};
  Set<Marker> markerset = {};
  Set<Circle> circleset = {};
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double bottompadding = MediaQuery.sizeOf(context).height * 0.2;
    return BlocConsumer<LocationCubit, Locationstate>(
      listener: (BuildContext context, Locationstate state) async {
        LocationCubit locationcubit = LocationCubit.get(context);
        if (state is LocationLatLngUpdated) {
          // get current latlng
          LatLng latlng = locationcubit.latLng!;
          // Get the Address of current location and type it in text field
          locationcubit.getaddressfromlatlang(latlng);
          // animate the camera to current latlng
          if (!state.ispickup) {
            addMarker(latlng, false);
          } else {
            addMarker(latlng, true);
          }
          BlocProvider.of<LocationCubit>(context)
              .animatecamera(latlng, widget.mycompleter);

          //Empty the set and drop a point on the given latlnh
        } else if (state is LocationDirectionSuccess) {
          //GEt the destination location to put a marker on it
          LocationCubit locationcubit = LocationCubit.get(context);
          LatLng? pickup = locationcubit.pickuplatlng;
          LatLng? destination = locationcubit.destinationlatlng;
          addMarker(destination!, false);
          //get the polyline and insert it to the set
          addPolyLine();
          locationcubit.animateWithBoundries(
              pickup!, destination, widget.mycompleter);
        } else if (state is LocationDirectionCanceled) {
          LocationCubit cubit = LocationCubit.get(context);
          polylineset = {};
          cubit.getcurrentlocation(widget.mycompleter, 'origin');
          cubit.animatecamera(cubit.latLng!, widget.mycompleter);
        }
      },
      builder: (context, state) {
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
            polylines: polylineset,
            onMapCreated: (GoogleMapController controller) async {
              widget.mycompleter.complete(controller);
              LocationPermission permission =
                  await Geolocator.checkPermission();
              if (permission != LocationPermission.always &&
                  permission != LocationPermission.whileInUse) {
                permission = await Geolocator.requestPermission();
                if (permission != LocationPermission.always &&
                    permission != LocationPermission.whileInUse) {
                  showtoast(
                      "App Can't start without Location Permission", context);
                } else {
                  await BlocProvider.of<LocationCubit>(context)
                      .getcurrentlocation(widget.mycompleter, "dest");
                }
              } else {
                await BlocProvider.of<LocationCubit>(context)
                    .getcurrentlocation(widget.mycompleter, "dest");
              }
            },
          ),
        );
      },
    );
  }

  void addPolyLine() {
    polylineset = {};
    Polyline polyline = Polyline(
        polylineId: const PolylineId("Polyline1"),
        color: Colors.blue,
        jointType: JointType.mitered,
        points: widget.polylist,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true);
    polylineset.add(polyline);
  }

  void addMarker(LatLng latlng, bool ispickup) {
    markerset = {};
    if (ispickup) {
      markerset.add(Marker(
          markerId: const MarkerId('marker2'),
          position: latlng,
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan)));
    } else {
      markerset.add(Marker(
        markerId: const MarkerId('marker2'),
        position: latlng,
      ));
    }
  }
}
