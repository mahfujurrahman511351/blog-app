import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../../constants/colors.dart';
import '../../../../controllers/dashboard/post_controller.dart';
import '../../../../models/dashboard/post.dart';
import '../../home/widgets/post_card.dart';

class SavedPostsView extends StatelessWidget {
  const SavedPostsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text("Saved Posts"),
      ),
      body: SafeArea(
        child: Obx(() {
          var savedPosts = Get.find<PostController>().savedPosts;
          bool loading = Get.find<PostController>().gettingSavedPost.value;

          return loading
              ? Center(
                  child: SizedBox(
                  height: 30.w,
                  width: 30.w,
                  child: LoadingIndicator(
                    indicatorType: Indicator.ballSpinFadeLoader,
                    colors: const [kBaseColor],
                    strokeWidth: 6.w,
                  ),
                ))
              : savedPosts.isEmpty
                  ? Center(
                      child: Text("No saved post found yet!", style: TextStyle(fontSize: 14.sp)),
                    )
                  : ListView(
                      children: List.generate(savedPosts.length, (index) {
                        Post post = savedPosts[index];
                        return PostCard(
                          post: post,
                          index: index,
                          deletedPost: false,
                          savedPost: true,
                        );
                      }),
                    );
        }),
      ),
    );
  }
}
