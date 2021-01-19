// Generated by https://quicktype.io

class Video {
  int id;
  int userId;
  String name;
  String type;
  String url;
  String updatedAt;
  String createdAt;
  String deletedAt;
  String thumbnail;

  Video({
    this.id,
    this.userId,
    this.name,
    this.type,
    this.url,
    this.updatedAt,
    this.createdAt,
    this.deletedAt,
    this.thumbnail,
  });

  Video.fromJsonMap(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    type = json['type'];
    url = json['url'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    deletedAt = json['deleted_at'];
    thumbnail = json['thumbnail'];
  }
}