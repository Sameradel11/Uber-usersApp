import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:user_app/Features/Autentication/presentation/view_model/cubits/authcubit/auth_cubit.dart';
import 'package:user_app/Features/Autentication/presentation/views/widgets/progress_dialog.dart';
import 'package:user_app/Features/home/models/usermodel.dart';
import 'package:user_app/Features/home/presentation/views/widgets/custom_list_tile.dart';
import 'package:user_app/core/app_routes.dart';
import 'package:user_app/core/functions.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key, required this.user});
  final UserModel? user;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          showDialog(
              context: context,
              builder: (context) => const CustomProgressDialog(
                    text: 'Signing out',
                  ));
        } else if (state is AuthSuccess) {
          GoRouter.of(context).pushReplacement(AppRoutes.splashview);
          showtoast("Signed Out", context);
        } else if (state is AuthFailed) {
          showtoast(state.errmessage, context);
        }
      },
      builder: (context, state) {
        return Drawer(
          child: user == null
              ? const Center(child: Text("There is an error "))
              : Container(
                  color: Colors.grey.shade700,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.sizeOf(context).height * 0.04,
                            ),
                            const CircleAvatar(
                              radius: 90,
                              backgroundImage:
                                  AssetImage('Assets/images/profile.jpg'),
                            ),
                            UserInfoListTile(
                              text: user!.name,
                              ontap: () {},
                              icon: Icons.person,
                            ),
                            UserInfoListTile(
                              text: user!.email,
                              ontap: () {},
                              icon: Icons.email,
                            ),
                            UserInfoListTile(
                              text: user!.phone,
                              ontap: () {},
                              icon: Icons.phone,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 5,
                              color: Colors.white,
                            )
                          ],
                        ),
                        Column(
                          children: [
                            UserInfoListTile(
                                text: 'History',
                                ontap: () {},
                                icon: Icons.history),
                            UserInfoListTile(
                                text: 'Profile',
                                ontap: () {},
                                icon: Icons.person),
                            UserInfoListTile(
                                text: 'About', ontap: () {}, icon: Icons.info),
                            UserInfoListTile(
                                text: 'SignOut',
                                ontap: () {
                                  BlocProvider.of<AuthCubit>(context).signout();
                                },
                                icon: Icons.logout)
                          ],
                        )
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }
}
