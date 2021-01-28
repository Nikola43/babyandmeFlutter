class Heartbeat {
  int id;
  int userId;
  String url;

  Heartbeat({
    this.id,
    this.userId,
    this.url,
  });

  Heartbeat.fromJsonMap(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'url': url,
      };
}
