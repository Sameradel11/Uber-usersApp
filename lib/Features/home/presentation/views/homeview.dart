import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:user_app/Features/Autentication/presentation/view_model/cubits/authcubit/auth_cubit.dart';
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
  GlobalKey<ScaffoldState> scfkey = GlobalKey<ScaffoldState>();
  final DraggableScrollableController scrollController =
      DraggableScrollableController();
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
                key: scfkey,
                drawer: MyDrawer(
                  user: user,
                ),
                body: Stack(children: [
                  CustomGoogleMap(
                      mycompleter: mycontroller, mapcontroller: mapcontroller),
                  OpenDrawer(scfkey: scfkey),
                  DraggableScrollableSheet(
                    initialChildSize: 0.3,
                    minChildSize: 0.2,
                    maxChildSize: 0.9,
                    builder: (BuildContext context,
                        ScrollController scrollController) {
                      return ListView(controller: scrollController, children: [
                        MaterialButton(
                          color: Colors.blue,
                          onPressed: () {},
                        ),
                      ]);
                    },
                  )
                ]),
              ),
            );
          },
        ),
      ),
    );
  }
}
