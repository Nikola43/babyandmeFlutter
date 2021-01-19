import 'package:babyandme/services/calculator_service.dart';
import 'package:babyandme/utils/shared_preferences.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class CalculatorPage extends StatefulWidget {
  CalculatorPage({Key key}) : super(key: key);

  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  static DateTime now = DateTime.now();

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
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    CalculatorService calculatorService = CalculatorService();
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/family.jpg'), fit: BoxFit.cover),
        ),
        child: Column(
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
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      elevation: 4.0,
                      onPressed: () {
                        DatePicker.showDatePicker(context,
                            theme: DatePickerTheme(
                              containerHeight: 210.0,
                            ),
                            showTitleActions: true,
                            minTime: DateTime(2000, 1, 1),
                            maxTime: DateTime(2022, 12, 31), onConfirm: (date) {
                          print('confirm $date');
                          _date = '${date.year} - ${date.month} - ${date.day}';
                          setState(() {});
                        }, currentTime: DateTime.now(), locale: LocaleType.es);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 50.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.date_range,
                                        size: 18.0,
                                        color: Colors.pink,
                                      ),
                                      Text(
                                        " $_date",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
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
                          borderRadius: new BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.red)),
                      onPressed: () {
                        if (_userID != 0) {
                          print('userid');

                          print(_userID);
                        }

                        calculatorService.calculatorByWeek(1, 1).then((val) {
                          if (val != null) {
                            Navigator.of(context).pushNamed(
                                '/calculator_detail',
                                arguments: val);
                          }
                        });
                      },
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
      ),
    );
  }
}
