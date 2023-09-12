import 'package:bloc/bloc.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:user_app/Features/Autentication/presentation/view_model/services.dart';
import 'package:user_app/core/const.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  signUP(
      {required String email,
      required String password,
      required String name,
      required String phone}) async {
    emit(AuthLoading());
    try {
      await AuthUsingFirebase()
          .signup(email: email, password: password, name: name, phone: phone);
      emit(AuthSuccess());
    } catch (e) {
      if (e is FirebaseAuthException) {
        emit(AuthFailed(errmessage: e.code));
      } else {
        emit(AuthFailed(errmessage: "There is an error, Please try again "));
      }
    }
  }



  signout() {
    try {
      emit(AuthLoading());
      firebaseAuth.signOut();
      emit(AuthSuccess());
    } catch (e) {
      if (e is FirebaseException || e is FirebaseAuthException) {
        emit(AuthFailed(errmessage: e.toString()));
      } else {
        emit(AuthFailed(errmessage: "There is an error"));
      }
    }
  }

  signin({required String email, required String password}) async {
    try {
      emit(AuthLoading());
      final firebaseuser = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      currentfirebaseuser = firebaseuser.user!;
      print(currentfirebaseuser);
      DatabaseReference driversref =
          FirebaseDatabase.instance.ref().child("users");
      driversref.child(firebaseuser.user!.uid).once().then((value) {
        final snap = value.snapshot;
        if (snap.value != null) {
          currentfirebaseuser = firebaseuser.user;
          emit(AuthSuccess());
        } else {
          firebaseAuth.signOut();
          emit(AuthFailed(
              errmessage: 'This email is registered with drivers app'));
        }
      });
    } catch (e) {
      if (e is FirebaseException || e is FirebaseAuthException) {
        emit(AuthFailed(errmessage: e.toString()));
      } else {
        emit(AuthFailed(errmessage: "There is an error"));
      }
    }
  }
}
