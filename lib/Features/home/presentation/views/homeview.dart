import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:user_app/Features/home/models/usermodel.dart';
import 'package:user_app/Features/home/presentation/views/widgets/custom_googlemap.dart';
import 'package:user_app/Features/home/presentation/viewmodel/autocompelte/locationcubit.dart';
import 'package:user_app/Features/home/presentation/viewmodel/fetchdata/fetchuserdata_cubit.dart';
import 'package:user_app/Features/home/presentation/views/widgets/default_scroll_sheet.dart';
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

  final TextEditingController textcontroller = TextEditingController();

  late List<Widget> scrollsheets;
  int sheetindex = 0;

  List<LatLng> pointlist = [];

  bool directionbegin = false;

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
                textcontroller.text = "${state.street} ${state.locality}";
              } else if (state is LocationDirectionSuccess) {
                showtoast("Direction method called", context);

                final m =
                    BlocProvider.of<LocationCubit>(context).directionModel;
                showtoast("Directionmodel printed", context);
                print(m!.distancetext);
                print(m.distancevalue);
                print(m.durationtext);
                print(m.durationvalue);
                print(m.epoints);
                PolylinePoints polylinePoints = PolylinePoints();
                List<PointLatLng> result =
                    polylinePoints.decodePolyline(m.epoints);
                for (int i = 0; i < result.length; i++) {
                  pointlist
                      .add(LatLng(result[i].latitude, result[i].longitude));
                }
                directionbegin = true;
                setState(() {});
              } else if (state is Locationfiled) {
                showtoast(state.errmessage, context);
              }
            },
          ),
        ],
        child: BlocBuilder<FetchdataCubit, FetchdataState>(
          builder: (context, state) {
            scrollsheets = [
              DefaultScrollSheet(
                  textcontroller: textcontroller,
                  labeltext: 'Destination',
                  hinttext: 'To Where',
                  onclicked: () {
                    sheetindex = 1;
                    setState(() {});
                    BlocProvider.of<LocationCubit>(context)
                        .getcurrentlocation(mycontroller, "origin");
                  },
                  buttontext: const Text("PickUp"),
                  sheetype: "dest"),
              DefaultScrollSheet(
                  textcontroller: textcontroller,
                  labeltext: 'Pick up Location',
                  hinttext: 'From',
                  onclicked: () {
                    BlocProvider.of<LocationCubit>(context).direction();
                  },
                  buttontext: const Text("Direction"),
                  sheetype: "origin"),
            ];
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
                        polylist: pointlist, mycompleter: mycontroller),
                    directionbegin
                        ? Positioned(
                            top: 20,
                            left: 10,
                            child: IconButton(
                                onPressed: closeontap,
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.black,
                                )),
                          )
                        : OpenDrawer(scfkey: scfkey),
                    scrollsheets[sheetindex]
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  closeontap() {
    pointlist = [];
    LocationCubit cubit = LocationCubit.get(context);
    cubit.cancelDirection();
  }
}
