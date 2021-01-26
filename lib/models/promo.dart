class Promo {
  int emitter_user_id;
  String title;
  String text;
  int available;
  String updated_at;
  String created_at;
  String start_at;
  String end_at;
  int week;


  Promo({
    this.emitter_user_id,
    this.title,
    this.text,
    this.available,
    this.updated_at,
    this.created_at,
    this.start_at,
    this.end_at,
    this.week,
  });

  Promo.fromJsonMap(Map<String, dynamic> json) {
    emitter_user_id = json['emitter_user_id'];
    title = json['title'];
    text = json['text'];
    available = json['available'];
    updated_at = json['updated_at'];
    created_at = json['created_at'];
    start_at = json['start_at'];
    end_at = json['end_at'];
    week = json['week'];
  }

  Map<String, dynamic> toJson() => {
        'emitter_user_id': emitter_user_id,
        'title': title,
        'text': text,
        'available': available,
        'updated_at': updated_at,
        'created_at': created_at,
        'start_at': start_at,
        'end_at': end_at,
        'week': week,
      };
}
