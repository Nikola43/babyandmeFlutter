import 'dart:typed_data';
import 'package:babyandme/models/image.dart';
import 'package:babyandme/models/images.dart';
import 'package:babyandme/providers/download_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class FullScreenImage extends StatefulWidget {
  static const routeName = '/full_screen_image_screen';

  @override
  _FullScreenImageState createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0, viewportFraction: 1);
  }

  @override
  Widget build(BuildContext context) {
    var fileDownloaderProvider =
        Provider.of<FileDownloaderProvider>(context, listen: false);

    final Images images = ModalRoute.of(context).settings.arguments;

    pageController =
        PageController(initialPage: images.index, viewportFraction: 1);

    print(images.index);

    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true, // this is all you need

        leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => {Navigator.pop(context)}),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.cloud_download,
              color: Colors.white,
            ),
            onPressed: () async {
              String a = "https://s3.eu-central-1.wasabisys.com/stela/4/image/IMG_20200729_1_52.jpg-compress.jpg";

              var response = await Dio().get(a,
                  options: Options(responseType: ResponseType.bytes));
              final result = await ImageGallerySaver.saveImage(
                  Uint8List.fromList(response.data),
                  quality: 60,
                  name: "hello");
              print(result);


              /*GallerySaver.saveImage(a
                      )
                  .then((value) => {
                        print(value),
                      });
              */
              /*
                  fileDownloaderProvider
                      .downloadFile(
                          "https://s3.eu-central-1.wasabisys.com/stela/4/image/IMG_20200729_1_52.jpg-compress.jpg",
                          "My File.jpg")
                      .then((onValue) {
                    print(onValue);

                  }),

                   */
            },
          ),
          IconButton(
            icon: Icon(
              Icons.share,
              color: Colors.white,
            ),
            onPressed: () {
              // do something
            },
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Hero(
            tag: images.list[images.index].id.toString() +
                String.fromCharCode(images.index),
            child: PageView.builder(
                controller: pageController,
                itemCount: images.list.length,
                itemBuilder: (context, index) {
                  print(index);
                  return imageSlider(
                      images.list, index, screenSize.width, screenSize.height);
                }),
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: AppBar(backgroundColor: Colors.transparent, elevation: 0.0),
          )
        ],
      ),
    );
  }

  Widget imageSlider(
      List<ImageModel> images, int index, double width, double height) {
    return AnimatedBuilder(
      animation: pageController,
      builder: (context, widget) {
        return widget;
      },
      child: Container(
          width: width,
          height: height,
          child: PhotoView(
            imageProvider: NetworkImage(images[index].thumbnail.length > 0
                ? images[index].thumbnail
                : images[index].url),
          )),
    );
  }
}
