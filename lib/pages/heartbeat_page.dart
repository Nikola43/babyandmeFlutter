import 'package:babyandme/models/heartbeat.dart';
import 'package:babyandme/providers/audio_provider.dart';
import 'package:babyandme/services/heartbeat_service.dart';
import 'package:babyandme/utils/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';

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
  bool isPlaying = false;
  //AudioPlayer audioPlayer = new AudioPlayer();
  AudioProvider audioProvider;

  AnimationController motionController;
  Animation motionAnimation;
  double size = 300;
  Heartbeat heartbeat;
  Size screenSize;

  HeartbeatService heartbeatService = new HeartbeatService();

  void initState() {
    super.initState();

    heartbeatService.getHeartbeat().then((value) => {
          if (value != null)
            {
              heartbeat = value,
              Future.delayed(Duration.zero, () {
                setState(() {
                  audioProvider = new AudioProvider(heartbeat.url);
                });
              })
            }
        });

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
  }

  @override
  void dispose() {
    motionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;

    return new Scaffold(

      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        // this is all you need
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text("Latido", style: TextStyle(color: Colors.white)),
        leading: new IconButton(
          icon: new Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Colors.orangeAccent,
        child: Column(
          children: [
            SizedBox(height: screenSize.height / 8),
            Stack(
              children: <Widget>[
                Align(
                  child: SvgPicture.asset('assets/images/LATIDO.svg',
                      height: 300.0,
                      width: 300.0,
                      allowDrawingOutsideViewBox: true,
                      semanticsLabel: 'Acme Logo'),
                ),
                Positioned(
                  left: 20,
                  child: GestureDetector(
                    onTap: () {
                     // play();
                    },
                    child: Container(
                      height: size,
                      width: size,
                      child: Icon(
                        FontAwesomeIcons.solidHeart,
                        size: size,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /*
  play() async {
    if (!isPlaying) {
      if (heartbeat != null && heartbeat.url != null) {
        isPlaying = true;
        String localUrl = await audioProvider.load();
        audioPlayer.play(localUrl, isLocal: true);
        motionController.forward();
      } else {
        ToastUtil.makeToast("No tiene latido");
      }
    } else {
      isPlaying = false;
      audioPlayer.stop();
      motionController.stop(canceled: true);
      //animationController1.reset();
    }
  }
  */
}
