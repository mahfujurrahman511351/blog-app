import '../auth/user.dart';

class Reply {
  String? id;
  String? text;
  User? user;
  String? createdAt;

  Reply({this.id, this.text, this.user, this.createdAt});

  Reply.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    text = json['text'];
    user = json['user'] != null ? User.fromJson(json) : null;
    createdAt = json['createdAt'];
  }
}
