import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

class DownloadFileUtil {
  static downloadImage(String url) async {
    var response = await Dio()
        .get(url, options: Options(responseType: ResponseType.bytes));
    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 100,
        name: "hello");

    if (result != null) {
      return true;
    }

    return false;
  }

  static downloadVideo(String url) async {
    var appDocDir = await getTemporaryDirectory();
    String savePath = appDocDir.path + "/temp.mp4";
    await Dio().download(url, savePath);
    final result = await ImageGallerySaver.saveFile(savePath);
    if (result != null) {
      return true;
    }
    return false;
  }
}
