import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(LocationInitial());

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
      CameraPosition currentcameraposition =
          CameraPosition(target: currentlatlang, zoom: 14);
      await controller
          .animateCamera(CameraUpdate.newCameraPosition(currentcameraposition));
      getaddress(currentlatlang);
    } catch (e) {
      emit(LocationFailure(errmessage: e.toString()));
    }
  }

  getaddress(LatLng currentlatlang) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        currentlatlang.latitude, currentlatlang.longitude);
    String street = placemarks[0].street!;
    String locality = placemarks[0].locality!;
    emit(LocationSuccess(
        street: street, locality: locality, currentlatlang: currentlatlang));
  }
}
