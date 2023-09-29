import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:user_app/Features/home/models/autocompletelocation.dart';
import 'package:user_app/core/const.dart';

part 'autocomplete_state.dart';

class AutocompleteCubit extends Cubit<AutocompleteState> {
  AutocompleteCubit() : super(AutocompleteInitial());
  autocomplete(String value) async {
    emit(AutocompleteLoading());
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
        emit(AutocompleteSuccess(locations: locations));
      } else {
        emit(AutocompleFailed(
            errmessage: "There is a problem with API, status code isn't ok"));
      }
    } on DioException catch (e) {
      emit(AutocompleFailed(errmessage: e.message.toString()));
    } catch (e) {
      emit(AutocompleFailed(errmessage: e.toString()));
    }
  }
}
