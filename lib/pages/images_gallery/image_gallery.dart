import 'package:babyandme/utils/donwload_file_util.dart';
import 'package:babyandme/utils/toast_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:babyandme/login_screen.dart';
import 'package:babyandme/models/image.dart';
import 'package:babyandme/models/images.dart';
import 'package:flutter/material.dart';
import 'package:babyandme/providers/image_provider.dart' as p;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ImageGalleryPage extends StatefulWidget {
  static const routeName = '/image_gallery';

  @override
  State<StatefulWidget> createState() {
    return new ImageGalleryPageState(); //Return a state object
  }
}

class ImageGalleryPageState extends State<ImageGalleryPage> {
  final imageProvider = p.ImageProvider();
  String label = "";
  Size screenSize;
  List<String> selectedImages = List<String>();
  List<ImageModel> images = List<ImageModel>();
  bool selectMode = false;
  int selectedImagesCounter = 0;
  List<Widget> list = [];
  bool showDownloadButton = false;
  Future future;
  int type;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      setState(() {
        type = ModalRoute.of(context).settings.arguments;
        future = imageProvider.getImages(type);
        future.then((value) => {
              if (value != null && value.length > 0)
                {
                  setState(() {
                    showDownloadButton = true;
                  })
                }
            });
      });
    });
  }

  _enableSelectionMode() {
    selectMode = true;
    setState(() {});
  }

  _buildSelector(int selectedImagesCounter) {
    return Positioned(
        top: 10,
        right: 10,
        child: ClipRRect(
          borderRadius: new BorderRadius.circular(10.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: new BorderRadius.circular(10.0),
              color: Colors.orangeAccent,
            ),
            width: 20,
            height: 20,
            child: Center(
                child: Text(
              selectedImages.length > 0 ? selectedImagesCounter.toString() : "",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            )),
          ),
        ));
  }

  Widget _drawImage(
      BuildContext context, List<ImageModel> list, int index, int type) {
    final images = Images(list: list, index: index);
    return Hero(
        tag: list[index].id.toString() + String.fromCharCode(index),
        child: GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .pushNamed('/full_screen_image_screen', arguments: images);
              /*
              if (selectMode) {
                selectedImages.add(list[index].url);
                selectedImagesCounter++;
                setState(() {});
              } else {
                Navigator.of(context)
                    .pushNamed('/full_screen_image_screen', arguments: images);
              }
               */
            },
            //onLongPress: _enableSelectionMode,
            child: type == 1
                ? ClipRRect(
                    borderRadius: new BorderRadius.circular(4.0),
                    child: CachedNetworkImage(
                      imageUrl:
                          type == 1 ? list[index].url : list[index].thumbnail,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                      placeholder: (context, url) => SizedBox(
                        width: 25,
                        height: 25,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.orangeAccent),
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ))
                : Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                          width: 200,
                          height: 200,
                          child: ClipRRect(
                              borderRadius: new BorderRadius.circular(4.0),
                              child: CachedNetworkImage(
                                imageUrl: type == 1
                                    ? list[index].url
                                    : list[index].thumbnail,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover),
                                  ),
                                ),
                                placeholder: (context, url) => SizedBox(
                                  width: 25,
                                  height: 25,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.orangeAccent),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ))),
                      Icon(
                        FontAwesomeIcons.play,
                        size: 25,
                        color: Colors.white,
                      ),
                      //selectMode ? _buildSelector(selectedImagesCounter) : Text(""),
                    ],
                  )));
  }

  //State must have "build" => return Widget
  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    type = ModalRoute.of(context).settings.arguments;

    if (type < 0) {
      type = 1;
    }
    SystemChrome.setEnabledSystemUIOverlays([]);

    switch (type) {
      case 1:
        label = "IMAGENS";
        break;
      case 2:
        label = "VÍDEOS";
        break;
      case 3:
        label = "HOLOGRAFIAS";
        break;
    }

    Widget widget = new FutureBuilder<List<ImageModel>>(
      future: future,
      builder:
          (BuildContext context, AsyncSnapshot<List<ImageModel>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return new Center(
              child: CircularProgressIndicator(
                  valueColor:
                      new AlwaysStoppedAnimation<Color>(Colors.orangeAccent)),
            );
          default:
            if (snapshot.hasError) {
              return new Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData && snapshot.data.length > 0) {
              images = snapshot.data;
              showDownloadButton = true;
              for (int i = 0; i < snapshot.data.length; i++) {
                list.add(_drawImage(context, images, i, type));
              }
              return GridView.extent(
                  maxCrossAxisExtent: 100.0,
                  mainAxisSpacing: 5.0,
                  crossAxisSpacing: 5.0,
                  padding: const EdgeInsets.all(5.0),
                  children: list);
            } else if (!snapshot.hasData) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Deve fazer login para ter acesso a esta secção",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15.0),
                    ),
                    SizedBox(height: screenSize.height / 16),
                    Container(
                      margin: EdgeInsets.all(10),
                      height: 50.0,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            side: BorderSide(color: Colors.orangeAccent)),
                        onPressed: () {
                          Navigator.pushNamed(context, LoginScreen.routeName);
                        },
                        padding: EdgeInsets.only(left: 20, right: 20),
                        color: Colors.orangeAccent,
                        textColor: Colors.white,
                        child: Text("FAZER LOGIN",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Center(
                child: Text(
                  "Não tem " + label.toLowerCase() + " disponíveis",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
                ),
              );
            }
        }
      },
    );

    setState(() {
    });

    return Scaffold(
        appBar: AppBar(
            centerTitle: true, // this is all you need
            title: Text(
              label,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            actions: [
              showDownloadButton
                  ? IconButton(
                      icon: new Icon(FontAwesomeIcons.download,
                          color: Colors.white),
                      onPressed: () async => {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Center(child: Text('Baixar tudo')),
                            content:
                                Text("¿Certeza que você deseja baixar tudo?"),
                            actions: [
                              FlatButton(
                                  child: Text("Cancelar"),
                                  textColor: Colors.red,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }),
                              FlatButton(
                                  child: Text("Baixar"),
                                  textColor: Colors.blue,
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    for (int i = 1; i <= images.length; i++) {
                                      if (label == "IMAGENS") {
                                        await DownloadFileUtil.downloadImage(
                                            images[i - 1].url);
                                      } else {
                                        await DownloadFileUtil.downloadVideo(
                                            images[i - 1].url);
                                      }
                                      ToastUtil.makeToast(
                                          "Baixando " + i.toString());
                                    }
                                    ToastUtil.makeToast(
                                        "Tudo foi baixado corretamente");
                                  }),
                            ],
                          ),
                        )
                      },
                    )
                  : Text(""),
            ],
            leading: new IconButton(
                icon: new Icon(FontAwesomeIcons.arrowLeft, color: Colors.white),
                onPressed: () => {Navigator.pop(context)})),
        body: Container(color: Colors.white, child: widget));
  }
}
