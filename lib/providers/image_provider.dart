

import 'package:babyandme/models/image.dart';
import 'package:babyandme/utils/http_request.dart';
import 'package:babyandme/utils/shared_preferences.dart';

class ImageProvider {
  final apiUrl = "https://api.babyandme.stelast.com/api/multimedia_content/images/";


  Future<List<String>> getImages() async {
    List<String> list = [];
    print("get images");
    var token = await SharedPreferencesUtil.getString('token');
    print(token);

    var userId = await SharedPreferencesUtil.getInt('user_id');
    print(userId.toString());

    try {
      final response = await HttpRequestUtil.makeSecureGetRequest(apiUrl + userId.toString(), token);
      print("resp");
      print(response);

      for (int i = 0; i < response.length; i++) {
        final img = Image.fromJsonMap(response[i]);
        print(img);
        list.add(img.url);
      }
    } on NoSuchMethodError catch (e) {
      print('error caught: $e');
    }
    print('sdsd');

    return list;
  }
}
