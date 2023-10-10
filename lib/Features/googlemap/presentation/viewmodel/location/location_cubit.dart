import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';
import 'package:user_app/core/const.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(CurrentLocationInitial());

  static get(context) {
    return BlocProvider.of<LocationCubit>(context);
  }

  Future<void> getcurrentlocation(controller) async {
    
    try {
      emit(LocationLoading());
      Position currentposition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      LatLng currentlatlang =
          LatLng(currentposition.latitude, currentposition.longitude);
      animatecamera(currentlatlang, controller);
      getaddress(currentlatlang);
    } catch (e) {
      emit(LocationFailure(errmessage: e.toString()));
    }
  }

  getaddress(LatLng currentlatlang) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          currentlatlang.latitude, currentlatlang.longitude);
      String street = placemarks[0].street!;
      String locality = placemarks[0].locality!;
      emit(Currentlocationsuccess(
          street: street, locality: locality, currentlatlang: currentlatlang));
    } catch (e) {
      emit(LocationFailure(errmessage: e.toString()));
    }
  }

  getlatlangfromplaceid(String placeid) async {
    try {
      String key = androidkey;
      String url =
          "https://maps.googleapis.com/maps/api/place/details/json?placeid=$placeid&key=$key";
      Dio dio = Dio();
      print(url);
      var response = await dio.get(url);
      LatLng locationlatlng = LatLng(
          response.data["result"]['geometry']['location']['lat'],
          response.data["result"]['geometry']['location']['lng']);
      emit(GetLatlanglocationSuccess(latLng: locationlatlng));
    } on Exception catch (e) {
      emit(LocationFailure(errmessage: e.toString()));
    }
  }

  animatecamera(LatLng latLng, Completer controller) async {
    final GoogleMapController newcontroller = await controller.future;
    CameraPosition currentcameraposition =
        CameraPosition(target: latLng, zoom: 14);
    await newcontroller
        .animateCamera(CameraUpdate.newCameraPosition(currentcameraposition));
  }
}
