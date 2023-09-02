// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:blog/app/constants/app_string.dart';
import 'package:blog/app/constants/colors.dart';
import 'package:blog/app/controllers/dashboard/post_controller.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../models/dashboard/post.dart';
import 'widgets/category_dropdown.dart';
import 'widgets/post_card.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(APP_NAME),
        centerTitle: true,
        elevation: 0,
        actions: [
          GestureDetector(
            child: Icon(Icons.search),
          ),
          SizedBox(
            width: 10.w,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Column(
            children: [
              CategoryDropDown(),
              SizedBox(height: 5.w),
              Expanded(
                child: Obx(() {
                  var posts = Get.find<PostController>().allPosts;
                  bool loading = Get.find<PostController>().loadingData.value;

                  return loading
                      ? Center(
                          child: SizedBox(
                          height: 30.w,
                          width: 30.w,
                          child: LoadingIndicator(
                            indicatorType: Indicator.ballSpinFadeLoader,
                            colors: [kBaseColor],
                            strokeWidth: 6.w,
                          ),
                        ))
                      : posts.isEmpty
                          ? Center(
                              child: Text("No posts found yet!", style: TextStyle(fontSize: 14.sp)),
                            )
                          : ListView(
                              children: List.generate(posts.length, (index) {
                                Post post = posts[index];
                                return PostCard(
                                  post: post,
                                  index: index,
                                  deletedPost: false,
                                  savedPost: false,
                                );
                              }),
                            );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
