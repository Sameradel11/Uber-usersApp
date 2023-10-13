
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const Klogopath = 'Assets/images/userlogo.png';
User? currentfirebaseuser;
final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
const String androidkey = "AIzaSyB5NWG9fpjHO8ukBaXei7sCyEk1beGIPKE";
const CameraPosition kGooglePlex = CameraPosition(
  target: LatLng(37.42796133580664, -122.085749655962),
  zoom: 14.4746,
);

Color textfieldcolor = const Color(0xffF1F5F8);
