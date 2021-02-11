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
          title: Text(
            "STREAMING",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.orangeAccent,
          leading: new IconButton(
              icon: new Icon(FontAwesomeIcons.arrowLeft, color: Colors.white),
              onPressed: () => {Navigator.pop(context)}),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              SizedBox(height: screenSize.height / 32),
              Text(
                "Introduzca el código del streaming",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: screenSize.width / 2,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      /*
                            Text(
                              'Introduzca el código del streaming',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  decoration: TextDecoration.none),
                            ),

                             */
                      SizedBox(height: screenSize.height / 32),
                      TextField(
                        maxLength: 4,
                        textAlign: TextAlign.center,
                        controller: _textFieldController,
                        textCapitalization: TextCapitalization.characters,
                        focusNode: myFocusNode,
                        autofocus: false,
                        decoration: InputDecoration(
                          filled: true,
                          counterStyle: TextStyle(color: Colors.white),
                          fillColor: Colors.white,
                          //Add th Hint text here.
                          hintText: "Codigo",

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0),
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
                          onPressed: () {
                            if (_textFieldController.value.text.length == 4) {
                              streamingService
                                  .getStreamingByCode(
                                  _textFieldController.value.text)
                                  .then((value) => {
                                print(value.url),
                                if (value.url != null)
                                  {
                                    print("ok"),
                                    Navigator.pushNamed(context,
                                        StreamingYoutubeVideo.routeName,
                                        arguments: value.url)
                                  }
                                else
                                  {
                                    Flushbar(
                                      title: "Código no encontrado",
                                      message: " ",
                                      duration: Duration(seconds: 3),
                                    )..show(context)
                                  }
                              });
                            } else {
                              FocusScope.of(context).requestFocus(myFocusNode);

                              //myFocusNode.requestFocus();
                              Flushbar(
                                title: "El código debe tener 4 letras",
                                message: " ",
                                duration: Duration(seconds: 3),
                              )..show(context);
                            }
                          },
                          padding: EdgeInsets.all(10.0),
                          color: Colors.orangeAccent,
                          textColor: Colors.white,
                          child: Text("VER",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}

