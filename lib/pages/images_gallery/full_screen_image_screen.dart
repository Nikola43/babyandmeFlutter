import 'package:babyandme/models/image.dart';
import 'package:babyandme/models/images.dart';
import 'package:babyandme/pages/videos_gallery/video_player.dart';
import 'package:babyandme/utils/donwload_file_util.dart';
import 'package:babyandme/utils/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
    SystemChrome.setEnabledSystemUIOverlays([]);

    pageController =
        PageController(initialPage: images.index, viewportFraction: 1);

    print(images.index);

    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
        extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true, // this is all you need

        leading: new IconButton(
            icon: new Icon(FontAwesomeIcons.arrowLeft, color: Colors.white),
            onPressed: () => {Navigator.pop(context)}),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              FontAwesomeIcons.download,
              color: Colors.white,
            ),
            onPressed: () async {
              ToastUtil.makeToast("Descargando....");
              var downloadResult;
              images.list[images.index].thumbnail.length > 0
                  ? downloadResult = await DownloadFileUtil.downloadVideo(
                      images.list[images.index].url)
                  : downloadResult = await DownloadFileUtil.downloadImage(
                      images.list[images.index].url);

              print('downloadResult');
              print(downloadResult);
              if (downloadResult == true) {
                ToastUtil.makeToast("Descarga completada");
              }
            },
          ),
          IconButton(
            icon: Icon(
              Icons.share,
              color: Colors.white,
            ),
            onPressed: () {
              var type = images.list[images.index].thumbnail.length > 0
                  ? 'video/mp4'
                  : 'image/jpg';
              DownloadFileUtil.shareFile(images.list[images.index].url, type);
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
            child: AppBar(
                centerTitle: true, // this is all you need
                backgroundColor: Colors.transparent,
                elevation: 0.0),
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
        child: images[index].thumbnail.length > 0
            ? GestureDetector(
                onTap: () => {
                      Navigator.pushNamed(context, VideoAppPage.routeName,
                          arguments: images[index].url)
                    },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PhotoView(
                      disableGestures: true,
                      imageProvider: NetworkImage(images[index].thumbnail),
                    ),
                    Icon(
                      FontAwesomeIcons.play,
                      size: 25,
                      color: Colors.white,
                    ),
                  ],
                ))
            : PhotoView(
                minScale: PhotoViewComputedScale.contained * 1,
                maxScale: PhotoViewComputedScale.covered * 2,
                imageProvider: NetworkImage(images[index].url),
              ),
      ),
    );
  }
}
