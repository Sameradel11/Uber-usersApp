import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:user_app/Features/Autentication/presentation/view_model/cubits/authcubit/auth_cubit.dart';
import 'package:user_app/core/app_routes.dart';
import 'package:user_app/core/const.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  GoogleMapController? mapcontroller;
  final Completer<GoogleMapController> _controller =
      Completer();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: IconButton(
          icon: const Icon(Icons.logout, size: 40),
          onPressed: () {
            BlocProvider.of<AuthCubit>(context).signout();
            GoRouter.of(context).pushReplacement(AppRoutes.splashview);
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        body: Center(
          child: GoogleMap(
              myLocationEnabled: true,
              mapType: MapType.normal,
              initialCameraPosition: kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                mapcontroller = controller;
              }),
        ),
      ),
    );
  }
}
