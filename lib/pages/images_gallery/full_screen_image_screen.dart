import 'package:babyandme/models/image.dart';
import 'package:babyandme/models/images.dart';
import 'package:babyandme/pages/videos_gallery/video_player.dart';
import 'package:babyandme/utils/donwload_file_util.dart';
import 'package:babyandme/utils/toast_util.dart';
import 'package:flutter/material.dart';
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

    pageController =
        PageController(initialPage: images.index, viewportFraction: 1);

    print(images.index);

    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomPadding: false,
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
                      initialScale: PhotoViewComputedScale.contained * 1.8,
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
                minScale: PhotoViewComputedScale.contained * 1.8,
                maxScale: PhotoViewComputedScale.covered * 2,
                initialScale: PhotoViewComputedScale.contained * 1.8,
                imageProvider: NetworkImage(images[index].url),
              ),
      ),
    );
  }
}

/*
PhotoView(
            imageProvider: NetworkImage(images[index].thumbnail.length > 0
                ? images[index].thumbnail
                : images[index].url),
          )


Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 200,
                      height: 200,
                      child: ClipRRect(
                        borderRadius: new BorderRadius.circular(10.0),
                        child: FadeInImage(
                          fit: BoxFit.fitHeight,
                          placeholder: AssetImage(
                              "assets/images/9619-loading-dots-in-yellow.gif"),
                          image: NetworkImage(type == 1
                              ? list[index].url
                              : list[index].thumbnail),
                        ),
                      ),
                    ),
                    Icon(
                      FontAwesomeIcons.play,
                      size: 25,
                      color: Colors.white,
                    ),
                  ],
                )
 */
