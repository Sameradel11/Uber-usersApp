import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';
import 'package:user_app/Features/home/models/autocompletelocation.dart';
import 'package:user_app/Features/home/models/directonmodel.dart';
import 'package:user_app/core/const.dart';

part 'locationstates.dart';

class LocationCubit extends Cubit<Locationstate> {
  LatLng? latLng;
  LatLng? destinationlatlng;
  LatLng? pickuplatlng;
  DirectionModel? directionModel;

  LocationCubit() : super(LocationInitial());

  static get(context) {
    return BlocProvider.of<LocationCubit>(context);
  }

  autocomplete(String value) async {
    print("*" * 50);
    print("Auto Complete Called");
    emit(LocationLoading());
    String key = androidkey;
    String url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$value&key=$key&components=country:eg";
    print(url);
    Dio dio = Dio();
    try {
      var response = await dio.get(url);
      if (response.data['status'] == 'OK') {
        List<dynamic> places = response.data["predictions"];
        List<AutoCompleteModel> locations = [];
        for (int i = 0; i < places.length; i++) {
          locations.add(AutoCompleteModel.fromjson(places[i]));
        }

        print(locations);
        emit(LocationAutoCompleteSucces(locations: locations));
      } else {
        emit(Locationfiled(
            errmessage: "There is a problem with API, status code isn't ok"));
      }
    } on DioException catch (e) {
      emit(Locationfiled(errmessage: e.message.toString()));
    } catch (e) {
      emit(Locationfiled(errmessage: e.toString()));
    }
  }

  Future<void> getcurrentlocation(controller, String scrollsheetype) async {
    try {
      emit(LocationLoading());
      Position currentposition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      LatLng currentlatlang =
          LatLng(currentposition.latitude, currentposition.longitude);
      updatelatlang(currentlatlang, scrollsheetype);
    } catch (e) {
      emit(Locationfiled(errmessage: e.toString()));
    }
  }

  getlatlangfromplaceid(String placeid, String type) async {
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
      updatelatlang(locationlatlng, type);
    } on Exception catch (e) {
      emit(Locationfiled(errmessage: e.toString()));
    }
  }

  getaddressfromlatlang(LatLng currentlatlang) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          currentlatlang.latitude, currentlatlang.longitude);
      String street = placemarks[0].street!;
      String locality = placemarks[0].locality!;
      emit(LocationAddressSuccess(
          street: street, locality: locality, currentlatlang: currentlatlang));
    } catch (e) {
      emit(Locationfiled(errmessage: e.toString()));
    }
  }

  animatecamera(LatLng latLng, Completer controller) async {
    final GoogleMapController newcontroller = await controller.future;
    CameraPosition currentcameraposition =
        CameraPosition(target: latLng, zoom: 18);
    await newcontroller
        .animateCamera(CameraUpdate.newCameraPosition(currentcameraposition));
  }

  updatelatlang(LatLng? newlatlang, String? type) {
    if (type == "origin") {
      print("PickUp location update");
      pickuplatlng = newlatlang;
      emit(LocationLatLngUpdated(ispickup: true));
    } else if (type == "dest") {
      emit(LocationLatLngUpdated(ispickup: false));
      print("destination location update");
      destinationlatlng = newlatlang;
    }
    latLng = newlatlang;
  }

  direction() async {
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?destination=${pickuplatlng!.latitude},${pickuplatlng!.longitude}&origin=${destinationlatlng!.latitude},${destinationlatlng!.longitude}&key=AIzaSyB5NWG9fpjHO8ukBaXei7sCyEk1beGIPKE";
    Dio dio = Dio();
    var response = await dio.get(url);
    if (response.data['status'] == 'OK') {
      directionModel = DirectionModel.fromjson(response.data);
      emit(LocationDirectionSuccess());
    }
  }

  void animateWithBoundries(
      LatLng pickup, LatLng destination, Completer controller) async {
    final GoogleMapController newcontroller = await controller.future;

    await newcontroller.animateCamera(
        CameraUpdate.newLatLngBounds(getboudries(pickup, destination), 50));
  }

  getboudries(LatLng? pickup, LatLng? destination) {
    if (pickup != null && destination != null) {
      print("Entered");
      LatLng south = LatLng(min(pickup.latitude, destination.latitude),
          min(pickup.longitude, destination.longitude));

      LatLng north = LatLng(max(pickup.latitude, destination.latitude),
          max(pickup.longitude, destination.longitude));
      return LatLngBounds(southwest: south, northeast: north);
    }
  }

  cancelDirection() {
    pickuplatlng = null;
    emit(LocationDirectionCanceled());
  }
}
