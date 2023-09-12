import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:user_app/Features/Autentication/presentation/view_model/cubits/authcubit/auth_cubit.dart';
import 'package:user_app/Features/home/presentation/viewmodel/cubits/fetchdata/fetchdata_cubit.dart';
import 'package:user_app/core/app_routes.dart';
import 'package:user_app/core/const.dart';
import 'package:user_app/core/functions.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  GoogleMapController? mapcontroller;
  final mycontroller = Completer();
  late FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FetchdataCubit()..fetchuserdata(),
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {},
          ),
          BlocListener<FetchdataCubit, FetchdataState>(
            listener: (context, state) {
              if (state is FetchdataSuccess) {
                showtoast("data fetched successfully", context);
                showtoast(state.user.email, context);
                showtoast(state.user.id, context);
                showtoast(state.user.name, context);
                showtoast(state.user.phone, context);
              } else if (state is FetchdataFailed) {
                print("*" * 50);
                print(state.errmeassge);
              }
            },
          ),
        ],
        child: Scaffold(
          floatingActionButton: IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              BlocProvider.of<AuthCubit>(context).signout();
              GoRouter.of(context).pushReplacement(AppRoutes.splashview);
            },
          ),
          body: Container(
            height: 700,
            child: GoogleMap(
              myLocationEnabled: true,
              mapType: MapType.normal,
              initialCameraPosition: kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                mycontroller.complete(controller);
                mapcontroller = controller;
              },
            ),
          ),
        ),
      ),
    );
  }
}
