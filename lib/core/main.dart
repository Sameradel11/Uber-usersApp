import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/Features/Autentication/presentation/view_model/cubits/authcubit/auth_cubit.dart';
import 'package:user_app/Features/home/presentation/viewmodel/autocompelte/locationcubit.dart';
import 'package:user_app/core/app_routes.dart';
import 'package:user_app/core/bloc_observer.dart';
import 'package:user_app/firebase_options.dart';

void main() async {
  runApp(const DriverApp());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Bloc.observer = Observer();
}

class DriverApp extends StatelessWidget {
  const DriverApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => LocationCubit())
      ],
      child: MaterialApp.router(
        routerConfig: AppRoutes.routes,
        theme: ThemeData(brightness: Brightness.dark),
        debugShowCheckedModeBanner: false,
        title: "Users App",
      ),
    );
  }
}
