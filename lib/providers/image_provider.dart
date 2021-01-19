

import 'package:babyandme/models/image.dart';
import 'package:babyandme/utils/http_request.dart';
import 'package:babyandme/utils/shared_preferences.dart';

class ImageProvider {
  final apiUrl = "https://api.babyandme.stelast.com/api/multimedia_content/";


  Future<List<ImageModel>> getImages(int type) async {
    List<ImageModel> list = [];
    var token = await SharedPreferencesUtil.getString('token');
    var userId = await SharedPreferencesUtil.getInt('user_id');
    var mode = 'images';
    try {
      switch(type) {
        case 1: mode = "images"; break;
        case 2: mode = "videos"; break;
        case 3: mode = "holo"; break;
      }
      final response = await HttpRequestUtil.makeSecureGetRequest(apiUrl + mode  + '/' + userId.toString(), token);
      //print("resp");
      //print(response);

      for (int i = 0; i < response.length; i++) {
        final img = ImageModel.fromJsonMap(response[i]);
        //print(img);
        list.add(img);
      }
    } on NoSuchMethodError catch (e) {
      print('error caught: $e');
    }
    //print('sdsd');

    return list;
  }
}
