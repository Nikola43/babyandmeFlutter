import 'package:babyandme/services/calculator_service.dart';
import 'package:babyandme/utils/shared_preferences.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:lottie/lottie.dart';

import '../../dashboard_screen.dart';

class CalculatorPage extends StatefulWidget {
  static const routeName = '/calculator';

  CalculatorPage({Key key}) : super(key: key);

  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  static DateTime now = DateTime.now();
  Size screenSize;

  String _date = "";
  int _userID = 0;

  @override
  void initState() {
    _date = formatDate(DateTime.now(), [dd, '-', mm, '-', yyyy]);

    super.initState();
    SharedPreferencesUtil.getInt('user_id').then((onValue) {
      _userID = onValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    final CalculatorService calculatorService = CalculatorService();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true, // this is all you need
        backgroundColor: Colors.transparent,
        elevation: 0.0,
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
        child: Column(
          children: [
            SizedBox(height: screenSize.height / 8),
            Stack(
              children: <Widget>[
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
                    SizedBox(height: screenSize.height / 32),
                    Text(
                      "Seleccione la fecha de su ultima menstruación",
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
                                  RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    elevation: 4.0,
                                    onPressed: () {
                                      DatePicker.showDatePicker(context,
                                          theme: DatePickerTheme(
                                            containerHeight: 210.0,
                                          ),
                                          showTitleActions: true,
                                          minTime: DateTime(2000, 1, 1),
                                          maxTime: DateTime(2022, 12, 31),
                                          onConfirm: (date) {
                                        print('confirm $date');
                                        _date =
                                            '${date.year} - ${date.month} - ${date.day}';
                                        setState(() {});
                                      },
                                          currentTime: DateTime.now(),
                                          locale: LocaleType.es);
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 50.0,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                child: Row(
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.date_range,
                                                      size: 18.0,
                                                      color: Colors.lightBlue,
                                                    ),
                                                    Text(
                                                      " $_date",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18.0),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    color: Colors.white,
                                  ),
                                  SizedBox(height: screenSize.height / 20),
                                  RaisedButton(
                                    shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(18.0),
                                        side: BorderSide(
                                            color: Colors.lightBlue)),
                                    onPressed: () {
                                      if (_userID != 0) {
                                        print('userid');

                                        print(_userID);
                                      }

                                      calculatorService
                                          .calculatorByWeek(16, 4)
                                          .then((val) {
                                        if (val != null) {
                                          Navigator.of(context).pushNamed(
                                              '/calculator_detail',
                                              arguments: val);
                                        }
                                      });
                                    },
                                    color: Colors.white,
                                    textColor: Colors.lightBlue,
                                    child: Text("Calcular".toUpperCase(),
                                        style: TextStyle(fontSize: 20)),
                                  )
                                ]))),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
