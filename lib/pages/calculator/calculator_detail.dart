import 'package:babyandme/models/calculator.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class CalculatorDetailPage extends StatefulWidget {
  CalculatorDetailPage({Key key}) : super(key: key);

  _CalculatorDetailPageState createState() => _CalculatorDetailPageState();
}

class _CalculatorDetailPageState extends State<CalculatorDetailPage> {
  Size _screenSize;

  @override
  Widget build(BuildContext context) {
    final Calculator calc = ModalRoute.of(context).settings.arguments;
    _screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Center(
                    child: Container(
                  height: _screenSize.height / 10,
                  child: Text("df"),
                )),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Center(
                    child: Container(
                  child: Column(
                    children: <Widget>[
                      Text('Semana 4'),
                      Padding(
                        padding: EdgeInsets.all(50),
                        child: ClipRRect(
                            borderRadius: new BorderRadius.circular(10.0),
                            child: ExtendedImage.network(
                              calc.imageUrl,
                              fit: BoxFit.fill,
                              cache: true,
                            )),
                      ),
                      Text(calc.text),
                    ],
                  ),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
