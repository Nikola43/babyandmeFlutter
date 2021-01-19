import 'package:babyandme/models/images.dart';
import 'package:flutter/material.dart';

import 'package:babyandme/providers/image_provider.dart' as p;

class VideoGalleryPage extends StatefulWidget {
  static const routeName = '/video_gallery';

  @override
  State<StatefulWidget> createState() {
    return new VideoGalleryPageState(); //Return a state object
  }
}

class VideoGalleryPageState extends State<VideoGalleryPage> {
  final imageProvider = p.ImageProvider();

  //State must have "build" => return Widget
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Fotos"),
      ),
      body: _buildGridTiles(context, imageProvider),
    );
  }
}

Widget _buildGridTiles(BuildContext context, p.ImageProvider imageProvider) {
  return new FutureBuilder<List<String>>(
    future: imageProvider.getImages(),
    builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
      if (snapshot.hasData) {
        List<Widget> list = [];

        for (int i = 0; i < snapshot.data.length; i++) {
          list.add(_drawImage(context, snapshot.data, i));
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

Widget _drawImage(BuildContext context, List<String> list, int index) {
  final images = Images(list: list, index: index);

  return Hero(
    tag: list[index] + String.fromCharCode(index),
    child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed('/full_screen_image_screen', arguments: images);
        },
        child: FadeInImage(
          image: NetworkImage(list[index]),
          placeholder: AssetImage('assets/loading.gif'),
        )),
  );
}
