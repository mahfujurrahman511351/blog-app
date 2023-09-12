// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../constants/api_string.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/helper_function.dart';
import '../../../../controllers/dashboard/comment_controller.dart';
import '../../../../models/auth/user.dart';
import '../../../../models/dashboard/comment.dart';
import 'reply_card.dart';

class CommentCard extends StatefulWidget {
  const CommentCard({
    super.key,
    required this.comment,
    required this.commentIndex,
    required this.postIndex,
  });

  final Comment comment;
  final int commentIndex, postIndex;

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  final _replyKey = GlobalKey<FormState>();
  final _replyController = TextEditingController();

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User user = widget.comment.user != null ? widget.comment.user as User : User();

    String avatar = user.avatar ?? "";

    String avatarUrl = imageBaseUrl + avatar;

    return Padding(
      padding: EdgeInsets.all(8.0.w),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                avatar.isNotEmpty
                    ? Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.transparent,
                            image: DecorationImage(
                              image: NetworkImage(avatarUrl),
                              fit: BoxFit.cover,
                            )),
                      )
                    : Icon(Icons.person, size: 35.sp),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name ?? "",
                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 5.w),
                      Text(
                        widget.comment.text ?? "",
                        style: TextStyle(fontSize: 13.sp),
                      ),
                      SizedBox(height: 5.w),
                      Row(
                        children: [
                          Text(
                            getTimeAgo(widget.comment.createdAt ?? ""),
                            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(width: 10.w),
                          Text("|"),
                          SizedBox(width: 10.w),
                          GestureDetector(
                            onTap: () {
                              final controller = Get.find<CommentController>();
                              controller.selectedCommentIndex.value = widget.commentIndex;

                              if (controller.selectedCommentIndex.value == widget.commentIndex) {
                                controller.showReply.value = !controller.showReply.value;

                                if (controller.showReply.value) {
                                  controller.getReplies(widget.comment.id ?? "");
                                } else {
                                  controller.showReplyEntry.value = false;
                                }
                              }
                            },
                            child: Text(
                              "${widget.comment.replyCount ?? 0} replies",
                              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Text("|"),
                          SizedBox(width: 10.w),
                          GestureDetector(
                            onTap: () {
                              final controller = Get.find<CommentController>();
                              controller.selectedCommentIndex.value = widget.commentIndex;

                              if (controller.selectedCommentIndex.value == widget.commentIndex) {
                                controller.showReplyEntry.value = !controller.showReplyEntry.value;

                                if (controller.showReplyEntry.value) {
                                  controller.getReplies(widget.comment.id ?? "");

                                  if (!controller.showReply.value) {
                                    controller.showReply.value = true;
                                  }
                                } else {
                                  controller.showReply.value = false;
                                }
                              }
                            },
                            child: Text(
                              "reply",
                              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          if (user.id == userId) Text("|"),
                          SizedBox(width: 10.w),
                          //
                          if (user.id == userId)
                            GestureDetector(
                              onTap: () {
                                Get.find<CommentController>().deleteComment(widget.comment.id ?? "", widget.commentIndex, widget.postIndex);
                              },
                              child: Text(
                                "Delete",
                                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
                              ),
                            ),
                          SizedBox(width: 10.w),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.w),
            Padding(
              padding: EdgeInsets.only(left: 20.w),
              child: _replies(widget.commentIndex),
            ),
            SizedBox(height: 5.w),
            Divider(),
          ],
        ),
      ),
    );
  }

  Widget _replies(int commentIndex) {
    return Obx(() {
      final controller = Get.find<CommentController>();
      var replies = controller.replies;
      int selectedIndex = controller.selectedCommentIndex.value;
      bool showReply = controller.showReply.value;
      bool showReplyEntry = controller.showReplyEntry.value;

      return Column(
        children: [
          showReply
              ? selectedIndex == commentIndex
                  ? Column(
                      children: List.generate(replies.length, (index) {
                        return ReplyCard(reply: replies[index], replyIndex: index, commentIndex: commentIndex);
                      }),
                    )
                  : Container()
              : Container(),
          showReplyEntry
              ? selectedIndex == commentIndex
                  ? _replyEntry()
                  : Container()
              : Container(),
        ],
      );
    });
  }

  Widget _replyEntry() {
    final controller = Get.find<CommentController>();
    return Form(
      key: _replyKey,
      child: Padding(
        padding: EdgeInsets.all(3.0.w),
        child: TextFormField(
          style: TextStyle(fontSize: 14.sp),
          decoration: InputDecoration(
            hintText: "Write a reply",
            hintStyle: TextStyle(fontSize: 14.sp),
            suffixIcon: IconButton(
              onPressed: () async {
                if (_replyKey.currentState!.validate()) {
                  _replyKey.currentState!.save();
                  bool created = await controller.createReplies(widget.comment.id ?? "", widget.commentIndex);

                  if (created) {
                    _replyController.clear();
                    controller.replyText = "";
                    controller.isReplyTyping.value = false;
                  }
                }
              },
              icon: Obx(() {
                return Icon(
                  Icons.send,
                  color: controller.isReplyTyping.value ? kBaseColor : Colors.black87,
                );
              }),
            ),
          ),
          controller: _replyController,
          onSaved: (value) {
            controller.replyText = value ?? "";
          },
          onChanged: (value) {
            if (value.isNotEmpty) {
              controller.isReplyTyping.value = true;
            } else {
              controller.isReplyTyping.value = false;
            }
          },
        ),
      ),
    );
  }
}
