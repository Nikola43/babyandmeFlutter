import 'package:babyandme/models/calculator.dart';
import 'package:flutter/material.dart';

import '../../dashboard_screen.dart';

class CalculatorDetailPage extends StatefulWidget {
  static const routeName = '/calculator_detail';

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
      appBar: AppBar(
        centerTitle: true,
        title: Text("Calculadora", style: TextStyle(color: Colors.white)),
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
                            child: FadeInImage(
                              fit: BoxFit.fitHeight,
                              placeholder: AssetImage(
                                  "assets/images/9619-loading-dots-in-yellow.gif"),
                              image: NetworkImage(calc.imageUrl),
                            )),
                        /*

                            child: ExtendedImage.network(
                              calc.imageUrl,
                              fit: BoxFit.fill,
                              cache: true,
                            )),
                         */
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
