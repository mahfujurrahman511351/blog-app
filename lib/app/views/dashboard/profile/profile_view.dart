// ignore_for_file: prefer_const_constructors

import 'package:blog/app/constants/helper_function.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text("Profile Page"),
            ),
            MaterialButton(
              onPressed: () {
                logout();
              },
              child: Text("Log Out"),
            )
          ],
        ),
      ),
    );
  }
}
