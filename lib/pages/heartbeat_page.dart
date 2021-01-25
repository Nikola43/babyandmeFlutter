import 'package:babyandme/providers/audio_provider.dart';
import 'package:flutter/material.dart';
import 'package:audioplayer/audioplayer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../dashboard_screen.dart';

class HeartbeatPage extends StatefulWidget {
  static const routeName = '/heartbeat';

  HeartbeatPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HeartbeatPageState createState() => new _HeartbeatPageState();
}

class _HeartbeatPageState extends State<HeartbeatPage>
    with SingleTickerProviderStateMixin {
  //AnimationController animationController1;
  //Animation<double> animation;

  bool isPlaying = false;
  static String url =
      'https://s3.eu-central-1.wasabisys.com/stela/3/heartbeat/dvr_20200729_1118.mpg_latido_.mp3';
  AudioPlayer audioPlayer = new AudioPlayer();
  AudioProvider audioProvider = new AudioProvider(url);

  AnimationController motionController;
  Animation motionAnimation;
  double size = 125;
  void initState() {
    super.initState();

    motionController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
      lowerBound: 0.5,
    );

    motionAnimation = CurvedAnimation(
      parent: motionController,
      curve: Curves.ease,
    );

    motionController.forward();
    motionController.addStatusListener((status) {
      setState(() {
        if (status == AnimationStatus.completed) {
          motionController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          motionController.forward();
        }
      });
    });

    motionController.addListener(() {
      setState(() {
        size = motionController.value * 250;
      });
    });

    motionController.stop(canceled: true);

    // motionController.repeat();
  }

  @override
  void dispose() {
    motionController.dispose();
    super.dispose();
  }

  /*

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
      } else if (status == AnimationStatus.dismissed) {
        animationController1.forward();
      }
    });
  }
  */

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true, // this is all you need

        title: Text("Calculadora", style: TextStyle(color: Colors.white)),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () {
            if (!isPlaying) {
              isPlaying = false;
              audioPlayer.stop();
            }
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
                color: Colors.blue,
                height: size,
                width: size,
                child: Icon(
                  FontAwesomeIcons.solidHeart,
                  size: size,
                  color: Colors.red,
                ),
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
      motionController.forward();
    } else {
      isPlaying = false;
      audioPlayer.stop();
      motionController.stop(canceled: true);
      //animationController1.reset();
    }
  }
}
