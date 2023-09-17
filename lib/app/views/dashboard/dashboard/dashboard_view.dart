// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_field

import 'package:blog/app/constants/colors.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/dashboard/comment_controller.dart';
import '../../../controllers/dashboard/home_contrller.dart';
import '../../../controllers/dashboard/post_controller.dart';
import '../../../controllers/dashboard/profile_Controller.dart';
import '../home/home_view.dart';
import '../posts/create_post/create_post_view.dart';
import '../profile/profile_view.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final _homeController = Get.put(HomeController());
  final _postController = Get.put(PostController());
  final _commentController = Get.put(CommentController());
  final _profileController = Get.put(ProfileController());

  int selectedIndex = 0;

  List<Widget> pages = const [
    HomeView(),
    ProfileView(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DoubleBackToCloseApp(
        snackBar: const SnackBar(
          content: Text('Tap back again to leave app'),
        ),
        child: SafeArea(
          child: pages[selectedIndex],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kBaseColor,
        onPressed: () {
          Get.to(() => const CreatePostView());
        },
        child: Icon(
          Icons.add,
          size: 20.sp,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        notchMargin: 5.w,
        elevation: 10,
        clipBehavior: Clip.antiAlias,
        shape: CircularNotchedRectangle(),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
