import '../auth/user.dart';
import 'post_category.dart';

class Post {
  String? id;
  String? title;
  String? description;
  PostCategory? category;
  List<String>? images;
  User? user;
  String? createdAt;
  String? thumbnail;
  int? likeCount;
  int? commentCount;
  bool? isLiked;

  Post({this.id, this.title, this.description, this.category, this.images, this.user, this.createdAt, this.thumbnail, this.likeCount, this.commentCount, this.isLiked});

  Post.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    title = json['title'];
    description = json['description'];
    category = json['category'] != null ? PostCategory.fromJson(json['category']) : null;
    images = json['images'].cast<String>();
    user = json['user'] != null ? User.fromJson(json) : null;
    createdAt = json['createdAt'];
    thumbnail = json['thumbnail'];
    likeCount = int.parse(json['likeCount'].toString());
    commentCount = int.parse(json['commentCount'].toString());
    isLiked = json['isLiked'];
  }
}
