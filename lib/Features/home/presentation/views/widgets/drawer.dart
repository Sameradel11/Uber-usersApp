import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:user_app/Features/home/models/usermodel.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key, required this.user});
  final UserModel? user;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
          child: user == null
              ? const Center(child: Text("There is an error "))
              : Column(
                  children: [
                    Container(
                      height: MediaQuery.sizeOf(context).height * 0.3,
                      color: Colors.grey,
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.06,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Column(
                                children: [
                                  Icon(Icons.person),
                                  SizedBox(height: 20),
                                  Icon(Icons.email),
                                  SizedBox(height: 20),
                                  Icon(Icons.phone)
                                ],
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Text(user!.name)),
                                  const SizedBox(height: 30),
                                  Text(user!.email),
                                  const SizedBox(height: 32),
                                  Text(user!.phone)
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                )),
    );
  }
}
