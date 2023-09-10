import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_string.dart';
import '../../constants/helper_function.dart';
import '../../models/dashboard/comment.dart';
import '../../models/dashboard/comment_response.dart';
import '../../models/response_status.dart';
import '../../service/comment_service.dart';
import 'post_controller.dart';

class CommentController extends GetxController {
  var gettingComments = false.obs;
  var creatingComments = false.obs;
  var deletingComments = false.obs;
  var isCommentTyping = false.obs;

  String commentText = "";

  var comments = <Comment>[].obs;

  final _commentService = CommentService();

  getComments(String postId) async {
    if (!gettingComments.value) {
      gettingComments.value = true;

      comments.clear();

      final response = await _commentService.getComments(postId);

      if (response.error == null) {
        var commentList = response.data != null ? response.data as List<dynamic> : [];

        for (var item in commentList) {
          comments.add(item);
        }
        gettingComments.value = false;
      } else if (response.error == UN_AUTHENTICATED) {
        logout();
        gettingComments.value = false;
      } else {
        gettingComments.value = false;
      }
    }
  }

  Future<bool> createComments(String postId, int postIndex) async {
    bool created = false;
    if (!creatingComments.value && commentText.isNotEmpty) {
      creatingComments.value = true;

      var body = jsonEncode({
        "text": commentText.trim(),
        "postId": postId,
      });

      final response = await _commentService.createComments(body);

      if (response.error == null) {
        final resposeStatus = response.data != null ? response.data as ResponseStatus : ResponseStatus();

        bool success = resposeStatus.success ?? false;

        if (success) {
          final commentResponse = resposeStatus.data != null ? resposeStatus.data as CommentResponse : CommentResponse();

          final comment = commentResponse.comment != null ? commentResponse.comment as Comment : Comment();

          comments.add(comment);
          created = true;

          final post = Get.find<PostController>().allPosts[postIndex];
          post.commentCount = commentResponse.commentCount ?? 0;
          Get.find<PostController>().allPosts[postIndex] = post;

          creatingComments.value = false;
        } else {
          showError(error: resposeStatus.message ?? "");
        }
      } else if (response.error == UN_AUTHENTICATED) {
        logout();
        creatingComments.value = false;
      } else {
        showError(error: response.error ?? "");
      }
    }
    return created;
  }

  deleteComment(String commentId, int commentIndex, int postIndex) async {
    if (!deletingComments.value) {
      deletingComments.value = true;

      final response = await _commentService.deleteComment(commentId);

      if (response.error == null) {
        final responseStatus = response.data != null ? response.data as ResponseStatus : ResponseStatus();

        bool success = responseStatus.success ?? false;

        if (success) {
          Get.snackbar(
            "Success",
            "Comment deleted",
            colorText: Colors.white,
            backgroundColor: Colors.black87,
            snackPosition: SnackPosition.BOTTOM,
          );

          //
          final post = Get.find<PostController>().allPosts[postIndex];
          int count = post.commentCount ?? 0;
          post.commentCount = count != 0 ? count - 1 : count;

          Get.find<PostController>().allPosts[postIndex] = post;
          //

          comments.removeAt(commentIndex);

          deletingComments.value = false;
        } else {
          deletingComments.value = false;
          showError(error: responseStatus.message ?? "");
        }
      } else if (response.error == UN_AUTHENTICATED) {
        logout();
        deletingComments.value = false;
      } else {
        showError(error: response.error ?? "");
        deletingComments.value = false;
      }
    }
  }
}
