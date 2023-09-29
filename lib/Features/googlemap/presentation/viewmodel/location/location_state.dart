part of 'location_cubit.dart';

@immutable
sealed class LocationState {}

final class CurrentLocationInitial extends LocationState {}

final class LocationLoading extends LocationState {}

final class Currentlocationsuccess extends LocationState {
  final String street;
  final String locality;
  final LatLng currentlatlang;

  Currentlocationsuccess(
      {required this.street,
      required this.locality,
      required this.currentlatlang});
}

final class LocationFailure extends LocationState {
  final String errmessage;
  LocationFailure({required this.errmessage});
}

final class GetLatlanglocationSuccess extends LocationState {
  final LatLng latLng;

  GetLatlanglocationSuccess({required this.latLng});
}
