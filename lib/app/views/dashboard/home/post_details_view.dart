// ignore_for_file: prefer_const_constructors

import 'package:blog/app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../constants/api_string.dart';
import '../../../constants/helper_function.dart';
import '../../../controllers/dashboard/comment_controller.dart';
import '../../../models/auth/user.dart';
import '../../../models/dashboard/comment.dart';
import '../../../models/dashboard/post.dart';
import '../../../models/dashboard/post_category.dart';
import '../posts/edit_post_view/edit_post_view.dart';
import 'widgets/comment_card.dart';

class PostDetailsView extends StatefulWidget {
  const PostDetailsView({super.key, required this.post, required this.deletedPost, required this.postIndex});

  final Post post;
  final bool deletedPost;
  final int postIndex;

  @override
  State<PostDetailsView> createState() => _PostDetailsViewState();
}

class _PostDetailsViewState extends State<PostDetailsView> {
  final _commentKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final category = widget.post.category != null ? widget.post.category as PostCategory : PostCategory();
    final owner = widget.post.user != null ? widget.post.user as User : User();
    Get.find<CommentController>().getComments(widget.post.id ?? "");

    return Scaffold(
      appBar: AppBar(
        title: const Text("Post Details"),
        centerTitle: true,
        elevation: 0,
        actions: [
          if (owner.id == userId && !widget.deletedPost)
            IconButton(
              onPressed: () {
                Get.to(() => EditPostView(post: widget.post));
              },
              icon: const Icon(Icons.edit_note),
            )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.w),
        child: SafeArea(
          child: ListView(
            children: [
              _titleDescription(category),
              SizedBox(height: 10.w),
              _thumbnail(),
              _images(),
              SizedBox(height: 10.w),
              _authorCard(),
              SizedBox(height: 20.w),
              _comments(),
              SizedBox(height: 10.w),
            ],
          ),
        ),
      ),
    );
  }

  Widget _comments() {
    return Obx(() {
      final comments = Get.find<CommentController>().comments;
      return Column(
        children: [
          comments.isEmpty
              ? Text(
                  "No Comments found",
                  textAlign: TextAlign.center,
                )
              : Column(
                  children: List.generate(comments.length, (index) {
                    Comment comment = comments[index];
                    return CommentCard(
                      comment: comment,
                      commentIndex: index,
                      postIndex: widget.postIndex,
                    );
                  }),
                ),
          _commentEntry()
        ],
      );
    });
  }

  Widget _commentEntry() {
    final controller = Get.find<CommentController>();
    return Form(
      key: _commentKey,
      child: Padding(
        padding: EdgeInsets.all(3.0.w),
        child: TextFormField(
          style: TextStyle(fontSize: 14.sp),
          decoration: InputDecoration(
            hintText: "Write a comment",
            hintStyle: TextStyle(fontSize: 14.sp),
            suffixIcon: IconButton(
              onPressed: () async {
                if (_commentKey.currentState!.validate()) {
                  _commentKey.currentState!.save();
                  bool created = await controller.createComments(widget.post.id ?? "", widget.postIndex);

                  if (created) {
                    _commentController.clear();
                    controller.commentText = "";
                    controller.isCommentTyping.value = false;
                  }
                }
              },
              icon: Obx(() {
                return Icon(
                  Icons.send,
                  color: controller.isCommentTyping.value ? kBaseColor : Colors.black87,
                );
              }),
            ),
          ),
          controller: _commentController,
          onSaved: (value) {
            controller.commentText = value ?? "";
          },
          onChanged: (value) {
            if (value.isNotEmpty) {
              controller.isCommentTyping.value = true;
            } else {
              controller.isCommentTyping.value = false;
            }
          },
        ),
      ),
    );
  }

  Widget _authorCard() {
    User user = widget.post.user != null ? widget.post.user as User : User();

    var avatar = user.avatar ?? '';
    var avatarLink = imageBaseUrl + avatar;

    return Padding(
      padding: EdgeInsets.all(8.0.w),
      child: Column(
        children: [
          const Divider(),
          Padding(
            padding: EdgeInsets.all(8.0.w),
            child: Row(
              children: [
                if (avatar.isEmpty) Icon(Icons.person, size: 40.sp),
                if (avatar.isNotEmpty)
                  Container(
                    width: 60.w,
                    height: 60.w,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(avatarLink),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name ?? '',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 5.w),
                      Text(
                        user.shortBio ?? '',
                        style: TextStyle(fontSize: 13.sp),
                      ),
                      SizedBox(height: 5.w),
                      Text(
                        'Total ${user.postCount} posts',
                        style: TextStyle(fontSize: 12.sp),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _images() {
    final images = (widget.post.images != null) || (widget.post.images!.isNotEmpty) ? widget.post.images as List<String> : <String>[];

    return Column(
      children: List.generate(images.length, (index) {
        String image = images[index];
        String imageUrl = imageBaseUrl + image;
        return image.isEmpty
            ? Container()
            : Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0.w),
                child: Image.network(
                  imageUrl,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
              );
      }),
    );
  }

  Widget _thumbnail() {
    final image = widget.post.thumbnail != null ? widget.post.thumbnail as String : '';
    final imageUrl = imageBaseUrl + image;

    return image.isEmpty
        ? Container()
        : Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0.w),
            child: Image.network(
              imageUrl,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
          );
  }

  Widget _titleDescription(PostCategory category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.post.title ?? '',
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 2.w),
        Row(
          children: [
            Expanded(child: Text(category.name ?? '', style: TextStyle(fontSize: 12.sp))),
            Text(getCustomDate(widget.post.createdAt ?? ''), style: TextStyle(fontSize: 12.sp)),
          ],
        ),
        SizedBox(height: 10.w),
        Text(
          widget.post.description ?? '',
          style: TextStyle(fontSize: 14.sp),
          textAlign: TextAlign.justify,
        )
      ],
    );
  }
}
