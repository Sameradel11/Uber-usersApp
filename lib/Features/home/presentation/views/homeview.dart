import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:user_app/Features/Autentication/presentation/view_model/cubits/authcubit/auth_cubit.dart';
import 'package:user_app/Features/Autentication/presentation/views/widgets/custom_elevated_button.dart';
import 'package:user_app/Features/home/models/usermodel.dart';
import 'package:user_app/Features/home/presentation/viewmodel/cubits/fetchdata/fetchdata_cubit.dart';
import 'package:user_app/Features/home/presentation/views/widgets/custom_googlemap.dart';
import 'package:user_app/Features/home/presentation/views/widgets/drawer.dart';
import 'package:user_app/Features/home/presentation/views/widgets/opendrawer.dart';
import 'package:user_app/core/const.dart';
import 'package:user_app/core/custom_text_field.dart';
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
  UserModel? user;
  bool allview = true;
  GlobalKey<ScaffoldState> scfkey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  scrollToTop(ScrollController scrollController) {
    scrollController.animateTo(
      9999,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    print("tapped *" * 500);
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
                user = state.user;
              } else if (state is FetchdataFailed) {
                showtoast(state.errmeassge, context);
              }
            },
          ),
        ],
        child: BlocBuilder<FetchdataCubit, FetchdataState>(
          builder: (context, state) {
            return SafeArea(
              child: Scaffold(
                backgroundColor: Colors.grey.shade600,
                key: scfkey,
                drawer: MyDrawer(user: user),
                body: Stack(
                  children: [
                    CustomGoogleMap(
                        mycompleter: mycontroller,
                        mapcontroller: mapcontroller),
                    OpenDrawer(scfkey: scfkey),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Positioned(
                        top: 2,
                        child: DraggableScrollableSheet(
                          initialChildSize: 0.2,
                          minChildSize: 0.2,
                          maxChildSize: 1,
                          builder: (context, scrollcontroller) {
                            return Container(
                                height: MediaQuery.sizeOf(context).height * 0.9,
                                color: Colors.grey.shade600,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListView(
                                    controller: scrollcontroller,
                                    children: [
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Container(
                                        height: 4,
                                        width: 90,
                                        color: Colors.grey.shade400,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      CustomTextField(
                                          ontap: scrollToTop(scrollcontroller),
                                          prefix: Icon(Icons.location_on),
                                          label: Text("From\nSource location")),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const CustomTextField(
                                          prefix: Icon(Icons.location_on),
                                          label:
                                              Text("To\nDestination location"))
                                    ],
                                  ),
                                ));
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
