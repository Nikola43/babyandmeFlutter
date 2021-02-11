import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class StreamingYoutubeVideo extends StatefulWidget {
  static const routeName = '/streaming_video';

  StreamingYoutubeVideo({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _StreamingYoutubeVideoState createState() => _StreamingYoutubeVideoState();
}

class _StreamingYoutubeVideoState extends State<StreamingYoutubeVideo> {
  String url;
  YoutubePlayerController _controller = YoutubePlayerController(initialVideoId: '33lGm3AEzjY');


  void listener() {}

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      setState(() {
        url = ModalRoute.of(context).settings.arguments;
        print(url);
        String videoId = url.split('=')[1];
        print(videoId);
        initializePlayer(url);
        _controller.load(videoId);

        //_controller.toggleFullScreenMode();
      });
    });
  }

  Future<void> initializePlayer(String url) async {
    String videoId = url.split('=')[1];
    print(videoId);
    _controller = YoutubePlayerController(initialVideoId: videoId);
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    // This pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    String videoId = url.split('=')[1];
    print(videoId);
    //initializePlayer(url);
    _controller.load(videoId);
    _controller.toggleFullScreenMode();
    SystemChrome.setEnabledSystemUIOverlays([]);

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          YoutubePlayer(
            controller: _controller,
            progressIndicatorColor: Color(0xFFFF0000),
            topActions: <Widget>[
              IconButton(
                icon: Icon(
                  FontAwesomeIcons.arrowLeft,
                  color: Colors.white,
                  size: 20.0,
                ),
                onPressed: () {
                  _controller.toggleFullScreenMode();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
