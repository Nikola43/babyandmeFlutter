import 'package:babyandme/pages/images_gallery/image_gallery.dart';
import 'package:flutter/material.dart';
import '../../dashboard_screen.dart';

class Gallery extends StatefulWidget {
  static const routeName = '/gallery';

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> with SingleTickerProviderStateMixin {
  final List<Tab> myTabs = <Tab>[
    Tab(icon: Icon(Icons.photo, color: Colors.white), text: "Imágenes"),
    Tab(icon: Icon(Icons.photo, color: Colors.white), text: "Videos"),
    Tab(icon: Icon(Icons.photo, color: Colors.white), text: "Holo"),
  ];

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {

    }

    if (_tabController.indexIsChanging) {
      switch (_tabController.index) {
        case 0:
          print("1");
          break;
        case 1:
          print("1");
          break;
        case 3:
          print("1");
          break;
      }
    }
  }
  changeMyTab(){
    setState(() {
      _tabController.index = 2;
    });
  }
  @override
  Widget build(BuildContext context) {
    final type = ModalRoute.of(context).settings.arguments;
    print(type);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
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
          controller: _tabController,
          children: [

            ImageGalleryPage(),
            ImageGalleryPage(),
            ImageGalleryPage(),
          ],
        ),
      ),
    );
  }
}
