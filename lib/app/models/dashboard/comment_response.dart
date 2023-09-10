import 'comment.dart';

class CommentResponse {
  Comment? comment;
  int? commentCount;

  CommentResponse({this.comment, this.commentCount});

  CommentResponse.fromJson(Map<String, dynamic> json) {
    comment = json['comment'] != null ? Comment.fromJson(json['comment']) : null;
    commentCount = int.parse(json['commentCount'].toString());
  }
}
