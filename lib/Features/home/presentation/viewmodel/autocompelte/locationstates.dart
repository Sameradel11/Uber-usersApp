part of 'locationcubit.dart';

@immutable
sealed class Locationstate {}

final class LocationInitial extends Locationstate {}

final class LocationAutoCompleteSucces extends Locationstate {
  final List<AutoCompleteModel> locations;
  LocationAutoCompleteSucces({required this.locations});
}

final class Locationfiled extends Locationstate {
  final String errmessage;

  Locationfiled({required this.errmessage});
}

final class LocationLoading extends Locationstate {}

final class LocationLatLngUpdated extends Locationstate {
  final bool ispickup;

  LocationLatLngUpdated({required this.ispickup});
}

final class LocationAddressSuccess extends Locationstate {
  final String street;
  final String locality;
  final LatLng currentlatlang;

  LocationAddressSuccess(
      {required this.street,
      required this.locality,
      required this.currentlatlang});
}

final class LocationDirectionSuccess extends Locationstate {}
final class LocationDirectionCanceled extends Locationstate {}

