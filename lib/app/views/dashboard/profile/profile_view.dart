// ignore_for_file: prefer_const_constructors

import 'package:blog/app/constants/helper_function.dart';
import 'package:blog/app/views/dashboard/posts/deleted_post_view/deleted_post_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../posts/saved_posts/saved_post_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text("Profile Page"),
      ),
      body: SafeArea(
        child: Column(
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
            ),
            MaterialButton(
              onPressed: () {
                Get.to(() => DeletedPostView());
              },
              child: Text("Deleted Posts"),
            ),
            MaterialButton(
              onPressed: () {
                Get.to(() => SavedPostsView());
              },
              child: Text("All Saved Posts"),
            )
          ],
        ),
      ),
    );
  }
}
