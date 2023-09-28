part of 'autocomplete_cubit.dart';

@immutable
sealed class AutocompleteState {}

final class AutocompleteInitial extends AutocompleteState {}

final class AutocompleteSuccess extends AutocompleteState {
  final List<AutoCompleteModel> locations;

  AutocompleteSuccess({required this.locations});
  
}

final class AutocompleFailed extends AutocompleteState {
  final String errmessage;

  AutocompleFailed({required this.errmessage});
}

final class AutocompleteLoading extends AutocompleteState {}
