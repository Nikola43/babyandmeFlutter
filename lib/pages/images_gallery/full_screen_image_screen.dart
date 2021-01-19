import 'package:babyandme/models/image.dart';
import 'package:babyandme/models/images.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

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
    final Images images = ModalRoute.of(context).settings.arguments;

    pageController =
        PageController(initialPage: images.index, viewportFraction: 1);

    print(images.index);

    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.cloud_download,
                color: Colors.white,
              ),
              onPressed: () {
                // do something
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
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => {Navigator.pop(context)})),
      body: Stack(
        children: <Widget>[
          Hero(
            tag: images.list[images.index].id.toString() + String.fromCharCode(images.index),
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
            imageProvider: NetworkImage(images[index].thumbnail.length > 0 ? images[index].thumbnail : images[index].url),
          )),
    );
  }
}
