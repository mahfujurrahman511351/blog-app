import '../auth/user.dart';

class Comment {
  String? id;
  String? text;
  User? user;
  String? createdAt;
  int? replyCount;

  Comment({this.id, this.text, this.user, this.createdAt, this.replyCount});

  Comment.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    text = json['text'];
    user = json['user'] != null ? User.fromJson(json) : null;
    createdAt = json['createdAt'];
    replyCount = int.parse(json['replyCount'].toString());
  }
}
