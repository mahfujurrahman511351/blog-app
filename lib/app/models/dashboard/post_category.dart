class PostCategory {
  String? id;
  String? name;
  int? postCount;

  PostCategory({this.id, this.name, this.postCount});

  PostCategory.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    postCount = json['postCount'] != null ? int.parse(json['postCount'].toString()) : null;
  }
}
