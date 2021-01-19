import 'package:babyandme/models/calculator.dart';
import 'package:flutter/material.dart';

class PromosPage extends StatefulWidget {
  PromosPage({Key key}) : super(key: key);

  _PromosPageState createState() => _PromosPageState();
}

class _PromosPageState extends State<PromosPage> {
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
            ],
          ),
        ),
      ),
    );
  }
}
