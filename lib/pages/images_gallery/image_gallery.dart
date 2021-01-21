import 'package:babyandme/models/image.dart';
import 'package:babyandme/models/images.dart';
import 'package:babyandme/utils/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:babyandme/providers/image_provider.dart' as p;

class ImageGalleryPage extends StatefulWidget {
  static const routeName = '/image_gallery';

  @override
  State<StatefulWidget> createState() {
    return new ImageGalleryPageState(); //Return a state object
  }
}

class ImageGalleryPageState extends State<ImageGalleryPage> {
  final imageProvider = p.ImageProvider();

  //State must have "build" => return Widget
  @override
  Widget build(BuildContext context) {
    int type = ModalRoute.of(context).settings.arguments;
    print(type);
    if (type < 0) {
      type = 1;
    }
    String label = "";

    switch (type) {
      case 1:
        label = "Fotos";
        break;
      case 2:
        label = "Videos";
        break;
      case 3:
        label = "Holos";
        break;
    }

    return Scaffold(
        appBar: AppBar(
            centerTitle: true, // this is all you need

            title: Text(
              label,
              style: TextStyle(color: Colors.white),
            ),
            leading: new IconButton(
                icon: new Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => {Navigator.pop(context)})),
        body: Container(
          color: Colors.white,
          child: _buildGridTiles(context, imageProvider, type),
        ));
  }
}

_getUserId() {
  new FutureBuilder(
      future: SharedPreferencesUtil.getInt('user_id'),
      builder: (context, snapshot) {
        if (snapshot.hasData) return Text(snapshot.data);
        return Container(
          width: 0.0,
          height: 0.0,
        );
      });
}

Widget _buildGridTiles(
    BuildContext context, p.ImageProvider imageProvider, int type) {
  return new FutureBuilder<List<ImageModel>>(
    future: imageProvider.getImages(type),
    builder: (BuildContext context, AsyncSnapshot<List<ImageModel>> snapshot) {
      if (snapshot.hasData) {
        print(snapshot.data);
        List<Widget> list = [];

        for (int i = 0; i < snapshot.data.length; i++) {
          list.add(_drawImage(context, snapshot.data, i, type));
        }
        return GridView.extent(
            maxCrossAxisExtent: 150.0,
            mainAxisSpacing: 5.0,
            crossAxisSpacing: 5.0,
            padding: const EdgeInsets.all(5.0),
            children: list);
      }
      return Container(); // unreachable
    },
  );
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
          },
          child: new ClipRRect(
            borderRadius: new BorderRadius.circular(10.0),
            child: FadeInImage(
              fit: BoxFit.fitHeight,
              placeholder:
                  AssetImage("assets/images/9619-loading-dots-in-yellow.gif"),
              image: NetworkImage(
                  type == 1 ? list[index].url : list[index].thumbnail),
            ),
          )));
}
