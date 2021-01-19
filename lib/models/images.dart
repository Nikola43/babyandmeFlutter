import 'image.dart';

class Images {
  List<ImageModel> list;
  int index;

  Images({
    this.list,
    this.index,
  });

  Images.fromJsonMap(Map<String, dynamic> json) {
    list = json['list'];
    index = json['index'];
  }
}
