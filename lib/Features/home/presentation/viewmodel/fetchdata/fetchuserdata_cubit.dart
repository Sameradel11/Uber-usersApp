import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:user_app/Features/home/models/usermodel.dart';
import 'package:user_app/core/const.dart';
part 'fetchuserdata_state.dart';

class FetchdataCubit extends Cubit<FetchdataState> {
  static datacubit(context) {
    return BlocProvider.of<FetchdataCubit>(context);
  }

  FetchdataCubit() : super(FetchdataInitial());
  fetchuserdata() {
    try {
      DatabaseReference usersref = FirebaseDatabase.instance
          .ref()
          .child("users")
          .child(firebaseAuth.currentUser!.uid);
      usersref.once().then(
        (snap) {
          UserModel currentuser = UserModel.snapshot(snap.snapshot);
          emit(FetchdataSuccess(user: currentuser));
        },
      );
    } catch (e) {
      if (e is FirebaseException || e is FirebaseDatabase) {
        emit(FetchdataFailed(errmeassge: e.toString()));
      } else {
        emit(FetchdataFailed(
            errmeassge: "There is an error please try again alter"));
      }
    }
  }


}
