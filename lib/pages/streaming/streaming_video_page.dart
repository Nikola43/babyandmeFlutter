import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class StreamingYoutubeVideo extends StatefulWidget {
  static const routeName = '/streaming_video';

  StreamingYoutubeVideo({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _StreamingYoutubeVideoState createState() => _StreamingYoutubeVideoState();
}

class _StreamingYoutubeVideoState extends State<StreamingYoutubeVideo> {
  YoutubePlayerController _controller =
      YoutubePlayerController(initialVideoId: 'nPt8bK2gbaU');

  String _videoId = "nPt8bK2gbaU";

  void listener() {}

  @override
  void deactivate() {
    // This pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    _controller.toggleFullScreenMode();
    bool _fullScreen = false;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          YoutubePlayer(
            controller: _controller,
            progressIndicatorColor: Color(0xFFFF0000),
            topActions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
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
