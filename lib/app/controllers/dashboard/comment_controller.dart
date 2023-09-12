import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_string.dart';
import '../../constants/helper_function.dart';
import '../../models/dashboard/comment.dart';
import '../../models/dashboard/comment_response.dart';
import '../../models/dashboard/reply.dart';
import '../../models/dashboard/reply_response.dart';
import '../../models/response_status.dart';
import '../../service/comment_service.dart';
import 'post_controller.dart';

class CommentController extends GetxController {
  var gettingComments = false.obs;
  var creatingComments = false.obs;
  var deletingComments = false.obs;
  var isCommentTyping = false.obs;
  //replies
  var gettingReplies = false.obs;
  var creatingReplies = false.obs;
  var deletingReplies = false.obs;
  var isReplyTyping = false.obs;
  //
  var showReply = false.obs;
  var showReplyEntry = false.obs;
  var selectedCommentIndex = 0.obs;

  String commentText = "";
  String replyText = "";

  var comments = <Comment>[].obs;
  var replies = <Reply>[].obs;

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
          creatingComments.value = false;
        }
      } else if (response.error == UN_AUTHENTICATED) {
        logout();
        creatingComments.value = false;
      } else {
        showError(error: response.error ?? "");
        creatingComments.value = false;
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

  getReplies(String commentId) async {
    if (!gettingReplies.value) {
      gettingReplies.value = true;

      replies.clear();

      final response = await _commentService.getReplies(commentId);

      if (response.error == null) {
        var replyList = response.data != null ? response.data as List<dynamic> : [];

        for (var item in replyList) {
          replies.add(item);
        }
        gettingReplies.value = false;
      } else if (response.error == UN_AUTHENTICATED) {
        logout();
        gettingReplies.value = false;
      } else {
        gettingReplies.value = false;
      }
    }
  }

  deleteReply(String replyId, int replyIndex, int commentIndex) async {
    if (!deletingReplies.value) {
      deletingReplies.value = true;

      final response = await _commentService.deleteReply(replyId);

      if (response.error == null) {
        final responseStatus = response.data != null ? response.data as ResponseStatus : ResponseStatus();

        bool success = responseStatus.success ?? false;

        if (success) {
          Get.snackbar(
            "Success",
            "Reply deleted",
            colorText: Colors.white,
            backgroundColor: Colors.black87,
            snackPosition: SnackPosition.BOTTOM,
          );

          //
          final comment = comments[commentIndex];
          int count = comment.replyCount ?? 0;
          comment.replyCount = count != 0 ? count - 1 : count;

          comments[commentIndex] = comment;
          //

          replies.removeAt(replyIndex);

          deletingReplies.value = false;
        } else {
          deletingReplies.value = false;
          showError(error: responseStatus.message ?? "");
        }
      } else if (response.error == UN_AUTHENTICATED) {
        logout();
        deletingReplies.value = false;
      } else {
        showError(error: response.error ?? "");
        deletingReplies.value = false;
      }
    }
  }

  Future<bool> createReplies(String commentId, int commentIndex) async {
    bool created = false;
    if (!creatingReplies.value && replyText.isNotEmpty) {
      creatingReplies.value = true;

      var body = jsonEncode({
        "text": replyText.trim(),
        "commentId": commentId,
      });

      final response = await _commentService.createReplies(body);

      if (response.error == null) {
        final resposeStatus = response.data != null ? response.data as ResponseStatus : ResponseStatus();

        bool success = resposeStatus.success ?? false;

        if (success) {
          final replyResponse = resposeStatus.data != null ? resposeStatus.data as ReplyResponse : ReplyResponse();

          final reply = replyResponse.reply != null ? replyResponse.reply as Reply : Reply();

          replies.add(reply);
          created = true;

          final comment = comments[commentIndex];
          comment.replyCount = replyResponse.replyCount ?? 0;
          comments[commentIndex] = comment;

          creatingReplies.value = false;
        } else {
          showError(error: resposeStatus.message ?? "");
          creatingReplies.value = false;
        }
      } else if (response.error == UN_AUTHENTICATED) {
        logout();
        creatingReplies.value = false;
      } else {
        showError(error: response.error ?? "");
        creatingReplies.value = false;
      }
    }
    return created;
  }
}
