import 'package:babyandme/models/calculator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:universal_io/io.dart';
import 'package:flutter/services.dart';

class CalculatorDetailPage extends StatefulWidget {
  static const routeName = '/calculator_detail';

  CalculatorDetailPage({Key key}) : super(key: key);

  _CalculatorDetailPageState createState() => _CalculatorDetailPageState();
}

class _CalculatorDetailPageState extends State<CalculatorDetailPage> {
  Size _screenSize;

  int calculateDaysBySetDate(DateTime selectedDate) {
    var difference = new DateTime.now().difference(selectedDate).inDays % 7;
    print(difference);
    if (difference <= 1) {
      difference = 1;
    }
    return difference.toInt();
  }

  int calculateWeekBySetDate(DateTime selectedDate) {
    var difference = new DateTime.now().difference(selectedDate).inDays / 7;
    print(difference);
    if (difference <= 1) {
      difference = 1;
    }
    return difference.toInt();
  }

  @override
  Widget build(BuildContext context) {
    final Calculator calc = ModalRoute.of(context).settings.arguments;
    _screenSize = MediaQuery.of(context).size;
    SystemChrome.setEnabledSystemUIOverlays([]);

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Estás de " +
                calculateWeekBySetDate(calc.selectedDateTime).toString() +
                ' semanas' +
                " y " +
                calculateDaysBySetDate(calc.selectedDateTime).toString() +
                ' dias',
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
                width: _screenSize.width,
                height: _screenSize.height,
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Column(children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 25),
                      child: Text(
                        'Semana ' + calc.id.toString(),
                        style: TextStyle(fontSize: 25, color: Colors.black),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(25),
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
                    Padding(
                        padding: EdgeInsets.only(left: 25, right: 25),
                        child: Text(calc.text)),
                    SizedBox(height: _screenSize.height / 32),
                  ]),
                ))));
  }
}
