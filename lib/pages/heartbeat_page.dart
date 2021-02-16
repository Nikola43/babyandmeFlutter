import 'package:another_flushbar/flushbar.dart';
import 'package:audioplayer/audioplayer.dart';
import 'package:babyandme/models/heartbeat.dart';
import 'package:babyandme/providers/audio_provider.dart';
import 'package:babyandme/services/heartbeat_service.dart';
import 'package:babyandme/utils/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  bool isPlaying = false;
  AudioPlayer audioPlayer = new AudioPlayer();
  AudioProvider audioProvider;

  AnimationController motionController;
  Animation motionAnimation;
  double size = 300;
  Heartbeat heartbeat;
  Size screenSize;

  HeartbeatService heartbeatService = new HeartbeatService();

  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

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
    WidgetsBinding.instance.removeObserver(this);
    motionController.dispose();
    super.dispose();

  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      isPlaying = false;
      audioPlayer.stop();
      motionController.stop(canceled: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    final openFrom = ModalRoute.of(context).settings.arguments;
    SystemChrome.setEnabledSystemUIOverlays([]);

    return Stack(children: [
      Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/Mama-bebe.png"),
            // <-- BACKGROUND IMAGE
            fit: BoxFit.cover,
          ),
        ),
      ),
      Container(
        color: Color.fromRGBO(0, 0, 0, 0.25098039215686274),
        width: screenSize.width,
        height: screenSize.height,
      ),
      Scaffold(
          backgroundColor: Colors.transparent,
          // <-- SCAFFOLD WITH TRANSPARENT BG
          appBar: AppBar(
            centerTitle: true, // this is all you need
            title: Text(
              "BATIMENTO",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.orangeAccent,
            leading: new IconButton(
                icon: new Icon(FontAwesomeIcons.arrowLeft, color: Colors.white),
                onPressed: () => {
                      isPlaying = false,
                      audioPlayer.stop(),
                      motionController.stop(canceled: true),
                      Navigator.pop(context)
                    }),
          ),
          body: Center(
              child: GestureDetector(
            onTap: () {
              play();
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
          )))
    ]);
  }

  play() async {
    if (!isPlaying) {
      if (heartbeat != null && heartbeat.url != null) {
        isPlaying = true;
        String localUrl = await audioProvider.load();
        audioPlayer.play(localUrl, isLocal: true);
        motionController.forward();
      } else {
        Flushbar(
          backgroundColor: Colors.orangeAccent,
          title: "Não tem batimento cardíaco disponível",
          message: " ",
          duration: Duration(seconds: 3),
        )..show(context);
      }
    } else {
      isPlaying = false;
      audioPlayer.stop();
      motionController.stop(canceled: true);
      //animationController1.reset();
    }
  }
}
