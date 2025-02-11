import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zia_ali_project_api/models/user.dart';
import 'package:zia_ali_project_api/services/auth.dart';

class ProfileView extends StatelessWidget {
  final String token;

  const ProfileView({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: FutureProvider.value(
        value: AuthServices().getProfile(token),
        initialData: UserModel(),
        builder: (context, child) {
          UserModel userModel = context.watch<UserModel>();
          return userModel.user == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    Text(
                      "Name: ${userModel.user!.name.toString()}",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Email: ${userModel.user!.email.toString()}",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
