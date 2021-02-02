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

    return Scaffold(
      resizeToAvoidBottomPadding: false,
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
        color: Colors.orange,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Center(
                    child: Container(
                  height: _screenSize.height / 20,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Estás de " +
                              calculateWeekBySetDate(calc.selectedDateTime)
                                  .toString() +
                              ' semanas' +
                              " y " +
                              calculateDaysBySetDate(calc.selectedDateTime)
                                  .toString() +
                              ' dias',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
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
                      Padding(
                        padding: EdgeInsets.only(top: 25),
                        child: Text(
                          'Semana ' + calc.id.toString(),
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(25),
                        child: ClipRRect(
                            borderRadius: new BorderRadius.circular(50.0),
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
