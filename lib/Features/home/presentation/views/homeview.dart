import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:user_app/Features/home/models/usermodel.dart';
import 'package:user_app/Features/googlemap/presentation/views/custom_googlemap.dart';
import 'package:user_app/Features/home/presentation/viewmodel/autocompelte/locationcubit.dart';
import 'package:user_app/Features/home/presentation/viewmodel/fetchdata/fetchuserdata_cubit.dart';
import 'package:user_app/Features/home/presentation/views/widgets/custom_scroll_sheet.dart';
import 'package:user_app/Features/home/presentation/views/widgets/drawer.dart';
import 'package:user_app/Features/home/presentation/views/widgets/opendrawer.dart';
import 'package:user_app/core/functions.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  GoogleMapController? mapcontroller;
  final Completer<GoogleMapController> mycontroller =
      Completer<GoogleMapController>();

  late FToast fToast;

  UserModel? user;

  GlobalKey<ScaffoldState> scfkey = GlobalKey<ScaffoldState>();

  final DraggableScrollableController scrollController =
      DraggableScrollableController();

  final TextEditingController pickupcontroller = TextEditingController();
  final TextEditingController destinationcontroller = TextEditingController();

  bool locationisfrom = true;

  List<LatLng> triplatlang = [];
  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => FetchdataCubit()..fetchuserdata()),
        BlocProvider(create: (context) => LocationCubit())
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<FetchdataCubit, FetchdataState>(
              listener: (context, state) {
            if (state is FetchdataSuccess) {
              user = state.user;
            } else if (state is FetchdataFailed) {
              showtoast(state.errmeassge, context);
            }
          }),
          BlocListener<LocationCubit, Locationstate>(
            listener: (context, state) {
              if (state is LocationAddressSuccess) {
                showtoast("Location Get Successfully", context);
                pickupcontroller.text = "${state.street} ${state.locality}";
              } else if (state is Locationfiled) {
                showtoast(state.errmessage, context);
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
                body: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    CustomGoogleMap(
                        mycompleter: mycontroller,
                        mapcontroller: mapcontroller),
                    OpenDrawer(scfkey: scfkey),
                    locationisfrom
                        ? CustomScrollSheet(
                            textcontroller: pickupcontroller,
                            destinationcontroller: destinationcontroller,
                            labeltext: 'Destination',
                            hinttext: 'To',
                            onsubmit: (value) {
                              locationisfrom = false;
                              setState(() {});
                              pickupcontroller.clear();
                            },
                          )
                        : CustomScrollSheet(
                            textcontroller: destinationcontroller,
                            destinationcontroller: destinationcontroller,
                            labeltext: 'Pick up Location',
                            hinttext: 'From',
                            onsubmit: (value) {},
                          )
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
