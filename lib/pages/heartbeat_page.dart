import 'package:babyandme/providers/audio_provider.dart';
import 'package:flutter/material.dart';
import 'package:audioplayer/audioplayer.dart';

import '../dashboard_screen.dart';

class HeartbeatPage extends StatefulWidget {
  HeartbeatPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HeartbeatPageState createState() => new _HeartbeatPageState();
}

class _HeartbeatPageState extends State<HeartbeatPage>
    with SingleTickerProviderStateMixin {
  AnimationController animationController1;
  Animation<double> animation;

  bool isPlaying = false;
  static String url =
      'https://codingwithjoe.com/wp-content/uploads/2018/03/applause.mp3';
  AudioPlayer audioPlayer = new AudioPlayer();
  AudioProvider audioProvider = new AudioProvider(url);

  @override
  void initState() {
    super.initState();
    animationController1 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    )..addListener(() => setState(() {}));
    animation = Tween<double>(
      begin: 50.0,
      end: 120.0,
    ).animate(animationController1);

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController1.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true, // this is all you need

        title: new Text("heartbeat"),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DashboardScreen()),
            );
          },
        ),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new GestureDetector(
              onTap: () {
                play();
              },
              child: Container(
                color: Colors.red,
                height: animation.value,
                width: animation.value,
              ),
            ),
          ],
        ),
      ),
    );
  }

  play() async {
    if (!isPlaying) {
      isPlaying = true;
      String localUrl = await audioProvider.load();
      audioPlayer.play(localUrl, isLocal: true);
      animationController1.forward();
    } else {
      isPlaying = false;
      audioPlayer.stop();
      animationController1.reset();
    }
  }
}
