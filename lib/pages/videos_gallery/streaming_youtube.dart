import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class StreamingYoutubeVideo extends StatefulWidget {
  StreamingYoutubeVideo({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _StreamingYoutubeVideoState createState() => _StreamingYoutubeVideoState();
}

class _StreamingYoutubeVideoState extends State<StreamingYoutubeVideo> {
  YoutubePlayerController _controller = YoutubePlayerController();
  var _idController = TextEditingController();
  var _seekToController = TextEditingController();
  double _volume = 100;
  bool _muted = false;
  String _playerStatus = "";

  String _videoId = "50kklGefAcs";

  void listener() {
    if (_controller.value.playerState == PlayerState.ended) {
      _showThankYouDialog();
    }
    if (mounted) {
      setState(() {
        _playerStatus = _controller.value.playerState.toString();
      });
    }
  }

  @override
  void deactivate() {
    // This pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "widget.title",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 20.0,
              ),
              onPressed: () {
                //_controller.exitFullScreenMode();
              },
            ),
            Expanded(
              child: Text(
                'Bhanchu Aaja || Ma Yesto Geet Gaunchu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.settings,
                color: Colors.white,
                size: 25.0,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  void _showThankYouDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Video Ended"),
          content: Text("Thank you for trying the plugin!"),
        );
      },
    );
  }
}
