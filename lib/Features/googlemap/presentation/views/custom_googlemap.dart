import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:user_app/Features/home/presentation/viewmodel/autocompelte/locationcubit.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    double bottompadding = MediaQuery.sizeOf(context).height * 0.2;
    return BlocConsumer<LocationCubit, Locationstate>(
      listener: (BuildContext context, Locationstate state) {
        if (state is LocationLatLngUpdated) {
          LatLng latlng = BlocProvider.of<LocationCubit>(context).latLng!;
          BlocProvider.of<LocationCubit>(context)
              .animatecamera(latlng, widget.mycompleter);
          BlocProvider.of<LocationCubit>(context).getaddressfromlatlang(latlng);
        }
        else if (state is LocationAddressSuccess){
          
        }
      },
      builder: (context, state) {
        LatLng latlng =
            BlocProvider.of<LocationCubit>(context).latLng ?? LatLng(0, 0);
        return SizedBox(
          height: MediaQuery.sizeOf(context).height,
          child: GoogleMap(
            padding: EdgeInsets.only(bottom: bottompadding),
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            myLocationEnabled: true,
            mapType: MapType.normal,
            initialCameraPosition: kGooglePlex,
            markers: {
              Marker(markerId: const MarkerId('marker2'), position: latlng)
            },
            onMapCreated: (GoogleMapController controller) async {
              widget.mycompleter.complete(controller);
              await BlocProvider.of<LocationCubit>(context)
                  .getcurrentlocation(widget.mycompleter);
            },
          ),
        );
      },
    );
  }
}
