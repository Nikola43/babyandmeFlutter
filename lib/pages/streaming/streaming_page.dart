import 'dart:ui';

import 'package:another_flushbar/flushbar.dart';
import 'package:babyandme/pages/streaming/streaming_video_page.dart';
import 'package:babyandme/services/streaming_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';

import '../../dashboard_screen.dart';

class StreamingCodePage extends StatefulWidget {
  static const routeName = '/streaming_code';

  StreamingCodePage({Key key}) : super(key: key);

  _StreamingCodePageState createState() => _StreamingCodePageState();
}

class _StreamingCodePageState extends State<StreamingCodePage> {
  TextEditingController _textFieldController = TextEditingController();
  StreamingService streamingService = StreamingService();
  Size screenSize;
  FocusNode myFocusNode;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();

    myFocusNode.addListener(() {
      print('Listener');
    });
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          // this is all you need
          title: Text(
            "STREAMING",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          leading: new IconButton(
            icon: new Icon(
              FontAwesomeIcons.arrowLeft,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
          child: Container(
            width: screenSize.width,
            color: Colors.white,
            child: Column(
              children: <Widget>[
                SizedBox(height: screenSize.height / 32),
                Lottie.asset(
                    'assets/images/16638-madre-con-su-hijo-mother-and-her-son.json',
                    width: 250.0),
                SizedBox(height: screenSize.height / 32),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Introduza o código de streaming",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: screenSize.width / 28),
                      ),
                      SizedBox(height: screenSize.height / 32),
                      Container(
                        width: screenSize.width / 4,
                        child: TextField(
                          maxLength: 4,
                          textAlign: TextAlign.center,
                          controller: _textFieldController,
                          textCapitalization: TextCapitalization.characters,
                          focusNode: myFocusNode,
                          autofocus: false,
                          decoration: InputDecoration(
                            filled: true,
                            counterStyle: TextStyle(color: Colors.black),
                            fillColor: Colors.white,
                            //Add th Hint text here.
                            hintText: "Código",

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenSize.height / 64),
                      Container(
                        margin: EdgeInsets.all(10),
                        height: 50.0,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              side: BorderSide(color: Colors.orangeAccent)),
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });
                            if (_textFieldController.value.text.length == 4) {
                              var streamingResult =
                                  await streamingService.getStreamingByCode(
                                      _textFieldController.value.text);
                              if (streamingResult != null) {
                                print(streamingResult.url);
                                if (streamingResult.url != null) {
                                  print("ok");
                                  setState(() {
                                    isLoading = false;
                                  });
                                  Navigator.pushNamed(
                                      context, StreamingYoutubeVideo.routeName,
                                      arguments: streamingResult.url);
                                } else {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  Flushbar(
                                    backgroundColor: Colors.redAccent,
                                    title: "Código no encontrado",
                                    message: " ",
                                    duration: Duration(seconds: 3),
                                  )..show(context);
                                }
                              }
                            } else {
                              FocusScope.of(context).requestFocus(myFocusNode);

                              //myFocusNode.requestFocus();
                              Flushbar(
                                backgroundColor: Colors.orangeAccent,
                                title: "O código deve ter 4 letras",
                                message: " ",
                                duration: Duration(seconds: 3),
                              )..show(context);
                              setState(() {
                                isLoading = false;
                              });
                            }
                          },
                          padding: EdgeInsets.all(10.0),
                          color: Colors.orangeAccent,
                          textColor: Colors.white,
                          child: isLoading
                              ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                )
                              : Text("VER",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
