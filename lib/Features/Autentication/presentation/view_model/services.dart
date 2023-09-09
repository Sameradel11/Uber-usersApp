import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:user_app/core/const.dart';

class AuthUsingFirebase {
  signup(
      {required String email,
      required String password,
      required String name,
      required String phone}) async {
    final FirebaseAuth fAuth = FirebaseAuth.instance;
    final firebaseuser = await fAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    Map drivermap = {
      'id': firebaseuser.user!.uid,
      'name': name.trim(),
      "email": email.trim(),
      "phone": phone
    };
    DatabaseReference driversreference =
        FirebaseDatabase.instance.ref().child("users");
    driversreference.child(firebaseuser.user!.uid).set(drivermap);
    currentfirebaseuser = firebaseuser.user!;
  }
}
