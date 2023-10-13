import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
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

  autocomplete(String value) async {
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

  Future<void> getcurrentlocation(controller) async {
    try {
      emit(LocationLoading());
      Position currentposition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      LatLng currentlatlang =
          LatLng(currentposition.latitude, currentposition.longitude);
      updatelatlang(currentlatlang,null);
    } catch (e) {
      emit(Locationfiled(errmessage: e.toString()));
    }
  }

  getlatlangfromplaceid(String placeid,String type) async {
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
      updatelatlang(locationlatlng,type);
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
        CameraPosition(target: latLng, zoom: 14);
    await newcontroller
        .animateCamera(CameraUpdate.newCameraPosition(currentcameraposition));
  }

  updatelatlang(LatLng newlatlang, String? type) {
    if (type == "origin") {
      pickuplatlng = newlatlang;
    } else if (type == "dest") {
      destinationlatlng = newlatlang;
    }
    latLng = newlatlang;
    emit(LocationLatLngUpdated());
  }

  direction() async {
    const LatLng origin = LatLng(31.265148, 29.992268);
    const LatLng destination = LatLng(31.234387, 29.9601701);
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?destination=31.234387,29.9601701&origin=31.265148,29.992268&key=AIzaSyB5NWG9fpjHO8ukBaXei7sCyEk1beGIPKE";
    Dio dio = Dio();
    var response = await dio.get(url);
    if (response.data['status'] == 'OK') {
      directionModel = DirectionModel.fromjson(response.data);
      emit(LocationDirectionSuccess());
    }
  }
}
