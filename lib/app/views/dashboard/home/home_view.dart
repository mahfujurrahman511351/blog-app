// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../constants/app_string.dart';
import '../../../constants/colors.dart';
import '../../../controllers/dashboard/home_contrller.dart';
import '../../../controllers/dashboard/post_controller.dart';
import '../../../models/dashboard/post.dart';
import 'widgets/category_dropdown.dart';
import 'widgets/post_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late TextEditingController _searchController;

  Timer? _debounceTimer;

  void debouncing({required Function() fn, int waitForMs = 800}) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(Duration(milliseconds: waitForMs), fn);
  }

  @override
  void initState() {
    _searchController = TextEditingController();
    _searchController.addListener(_onSearchChanged);
    super.initState();
  }

  _onSearchChanged() {
    debouncing(fn: () {
      Get.find<PostController>().searchPost(_searchController.text.trim());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          bool searching = Get.find<HomeController>().searching.value;
          return searching
              ? TextFormField(
                  style: TextStyle(fontSize: 13.sp),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: whiteColor,
                    hintText: "Search Anything",
                    hintStyle: TextStyle(fontSize: 13.sp),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        Get.find<HomeController>().searching.value = false;
                      },
                      child: Icon(Icons.close),
                    ),
                  ),
                  controller: _searchController,
                )
              : Text(APP_NAME);
        }),
        centerTitle: true,
        elevation: 0,
        actions: [
          Obx(() {
            bool searching = Get.find<HomeController>().searching.value;
            return searching
                ? Container()
                : IconButton(
                    onPressed: () {
                      Get.find<HomeController>().searching.value = true;
                    },
                    icon: Icon(Icons.search),
                  );
          }),
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
