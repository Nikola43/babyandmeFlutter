import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

class DownloadFileUtil {
  static downloadImage(String url) async {
    var response = await Dio()
        .get(url, options: Options(responseType: ResponseType.bytes));
    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 100,
        name: url.split('/')[url.split('/').length - 1]);

    if (result != null) {
      return true;
    }

    return false;
  }

  static downloadVideo(String url) async {
    var appDocDir = await getTemporaryDirectory();
    String savePath =
        appDocDir.path + url.split('/')[url.split('/').length - 1];
    await Dio().download(url, savePath);
    final result = await ImageGallerySaver.saveFile(savePath);
    if (result != null) {
      return true;
    }
    return false;
  }

  static shareFile(String url, String type) async {
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    Uint8List bytes = await consolidateHttpClientResponseBytes(response);
    await Share.file(
        'ESYS AMLOG', url.split('/')[url.split('/').length - 1], bytes, type);
  }
}
