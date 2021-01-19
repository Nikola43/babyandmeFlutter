import 'package:babyandme/services/calculator_service.dart';
import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
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
      body: Stack(children: <Widget>[
        Image.asset(
          'assets/fondo_2.png',
          width: screenSize.width,
          height: screenSize.height,
          fit: BoxFit.fill,
        ),
        Column(
          children: <Widget>[
            SizedBox(height: screenSize.height / 2),
            Text(
              'Introduzca la fecha de su ultima menstruación',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.pink,
                  decoration: TextDecoration.none),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextField(
                      controller: _textFieldController,
                      decoration: InputDecoration(
                        filled: true,

                        fillColor: Colors.white,
                        //Add th Hint text here.
                        hintText: "Introduzca el código del streaming",

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                    ),
                    SizedBox(height: screenSize.height / 20),
                    RaisedButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.red)),
                      onPressed: () {},
                      color: Colors.pink,
                      textColor: Colors.white,
                      child: Text("Calcular".toUpperCase(),
                          style: TextStyle(fontSize: 20)),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
