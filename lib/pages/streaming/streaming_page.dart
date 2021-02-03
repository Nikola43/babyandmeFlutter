import 'package:another_flushbar/flushbar.dart';
import 'package:babyandme/pages/streaming/streaming_video_page.dart';
import 'package:babyandme/services/streaming_service.dart';
import 'package:flutter/material.dart';
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

    return Scaffold(

        extendBodyBehindAppBar: true,
        appBar: AppBar(
          centerTitle: true,
          // this is all you need

          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text("Streaming", style: TextStyle(color: Colors.white)),
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
        ),
        body: Container(
          color: Colors.orangeAccent,
          child: Column(
            children: <Widget>[
              SizedBox(height: screenSize.height / 8),
              Align(
                child: Lottie.asset('assets/images/16367-madre-embarazada.json',
                    width: 300.0),
                //child: Image.asset('assets/$assetName.jpg', width: 350.0),
                alignment: Alignment.topCenter,
              ),
              SizedBox(height: screenSize.height / 64),
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
                        autofocus: true,
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
                      RaisedButton(
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(18.0),
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
                        color: Colors.white,
                        textColor: Colors.orangeAccent,
                        child: Text("Ver".toUpperCase(),
                            style: TextStyle(fontSize: 20)),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
