part of 'fetchdata_cubit.dart';

@immutable
sealed class FetchdataState {
  Object? get currentuser => null;
}

final class FetchdataInitial extends FetchdataState {}

final class FetchdataSuccess extends FetchdataState {
  final UserModel user;
  FetchdataSuccess({required this.user});
}

final class FetchdataLoading extends FetchdataState {}

final class FetchdataFailed extends FetchdataState {
  final String errmeassge;

  FetchdataFailed({required this.errmeassge});
}
