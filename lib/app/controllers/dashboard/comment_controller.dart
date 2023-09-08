import 'package:get/get.dart';

import '../../constants/app_string.dart';
import '../../constants/helper_function.dart';
import '../../models/dashboard/comment.dart';
import '../../service/comment_service.dart';

class CommentController extends GetxController {
  var gettingComments = false.obs;

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
        print(comments);
        gettingComments.value = false;
      } else if (response.error == UN_AUTHENTICATED) {
        logout();
        gettingComments.value = false;
      } else {
        gettingComments.value = false;
      }
    }
  }
}
