import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_app/Features/Autentication/presentation/view_model/cubits/authcubit/sign_up_cubit.dart';
import 'package:user_app/core/app_routes.dart';
import 'package:user_app/core/bloc_observer.dart';

void main() async {
  runApp(const DriverApp());
  Bloc.observer = Observer();
}

class DriverApp extends StatelessWidget {
  const DriverApp({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: MaterialApp.router(
        routerConfig: AppRoutes.routes,
        theme: ThemeData(brightness: Brightness.dark),
        debugShowCheckedModeBanner: false,
        title: "Users App",
      ),
    );
  }
}
