part of 'location_cubit.dart';

@immutable
sealed class LocationState {}

final class LocationInitial extends LocationState {}

final class LocationLoading extends LocationState {}

final class LocationSuccess extends LocationState {
  final String street;
  final String locality;
  final LatLng currentlatlang;

  LocationSuccess(
      {required this.street,
      required this.locality,
      required this.currentlatlang});
}

final class LocationFailure extends LocationState {
  final String errmessage;
  LocationFailure({required this.errmessage});
}
