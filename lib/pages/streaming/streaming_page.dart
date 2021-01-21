import 'package:babyandme/services/calculator_service.dart';
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
  CalculatorService calculatorService = CalculatorService();
  Size screenSize;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          centerTitle: true, // this is all you need

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
            color: Colors.lightBlue,
            child: Column(
              children: [
                SizedBox(height: screenSize.height / 8),
                Stack(children: <Widget>[
                  Column(
                    children: <Widget>[
                      SizedBox(height: screenSize.height / 64),
                      Align(
                        child: Lottie.asset(
                            'assets/images/16367-madre-embarazada.json',
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
                                textAlign: TextAlign.center,
                                controller: _textFieldController,
                                decoration: InputDecoration(
                                  filled: true,

                                  fillColor: Colors.white,
                                  //Add th Hint text here.
                                  hintText: "Codigo",

                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                ),
                              ),
                              SizedBox(height: screenSize.height / 20),
                              RaisedButton(
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.lightBlue)),
                                onPressed: () {},
                                color: Colors.white,
                                textColor: Colors.lightBlue,
                                child: Text("Ver".toUpperCase(),
                                    style: TextStyle(fontSize: 20)),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ])
              ],
            )));
  }
}
