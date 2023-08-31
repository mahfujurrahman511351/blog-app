import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../../constants/colors.dart';
import '../../../../controllers/dashboard/post_controller.dart';
import '../../../../models/dashboard/post.dart';
import '../../home/widgets/post_card.dart';

class DeletedPostView extends StatelessWidget {
  const DeletedPostView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text("Deleted Posts"),
      ),
      body: SafeArea(
        child: Obx(() {
          var deletedPosts = Get.find<PostController>().deletedPosts;
          bool loading = Get.find<PostController>().gettingDeletedPost.value;

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
              : deletedPosts.isEmpty
                  ? Center(
                      child: Text("No deleted post found yet!", style: TextStyle(fontSize: 14.sp)),
                    )
                  : ListView(
                      children: List.generate(deletedPosts.length, (index) {
                        Post post = deletedPosts[index];
                        return PostCard(post: post, index: index, deletedPost: true);
                      }),
                    );
        }),
      ),
    );
  }
}
