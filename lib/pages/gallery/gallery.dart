import 'package:babyandme/pages/images_gallery/image_gallery.dart';
import 'package:babyandme/pages/videos_gallery/video_gallery.dart';
import 'package:flutter/material.dart';

import '../../dashboard_screen.dart';

class Gallery extends StatefulWidget {
  static const routeName = '/gallery';

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.white,),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DashboardScreen()),
              );
            },
          ),
          bottom: TabBar(
            labelColor: Colors.white,
            tabs: [
              Tab(
                  icon: Icon(Icons.photo, color: Colors.white),
                  text: "Imágenes"),
              Tab(icon: Icon(Icons.photo, color: Colors.white), text: "Videos"),
              Tab(icon: Icon(Icons.photo, color: Colors.white), text: "Holo"),
            ],
          ),
          title: Text(
            'Galeria',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: TabBarView(
          children: [
            ImageGalleryPage(),
            VideoGalleryPage(),
            VideoGalleryPage(),
          ],
        ),
      ),
    );
  }
}
