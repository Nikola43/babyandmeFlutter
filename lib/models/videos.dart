
import 'video.dart';

class Videos {
  List<Video> list;
  int index;

  Videos({
    this.list,
    this.index,
  });

  Videos.fromJsonMap(Map<String, dynamic> json) {
    list = json['list'];
    index = json['index'];
  }
}
