import 'package:babyandme/services/calculator_service.dart';
import 'package:babyandme/utils/shared_preferences.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:universal_io/io.dart';
import 'package:flutter/services.dart';

class CalculatorPage extends StatefulWidget {
  static const routeName = '/calculator';

  CalculatorPage({Key key}) : super(key: key);

  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  Size screenSize;

  DateTime selectedDate = DateTime.now();
  String _parsedDate = "";
  int _userID = 0;

  Future<DateTime> calculateMaxDate() async {
    /*
    var now = new DateTime.now();
    int currentWeek = await SharedPreferencesUtil.getInt("currentWeek");
    DateTime maxDate = now;
    currentWeek = 40 - currentWeek;

    print(currentWeek);
    print(280 - currentWeek * 7);

    if (currentWeek != null) {
      maxDate = now.add(new Duration(days: 280 - currentWeek * 7));
    }
    return maxDate;
    */

    return new DateTime.now();
  }

  Future<DateTime> calculateMinDate() async {
    var now = new DateTime.now();
    DateTime minDate = now.add(new Duration(days: -280));
    /*
    var now = new DateTime.now();
    int currentWeek = await SharedPreferencesUtil.getInt("currentWeek");
    DateTime minDate = now.add(new Duration(days: -280));

    if (currentWeek != null) {
      minDate = now.add(new Duration(days: -280 + (currentWeek * 7)));
    }
    */

    return minDate;
  }

  int calculateWeekBySetDate(DateTime selectedDate) {
    var difference = new DateTime.now().difference(selectedDate).inDays / 7;
    print(difference);
    difference = difference.abs();
    if (difference <= 1) {
      difference = 1;
    }

    //SharedPreferencesUtil.saveInt("currentWeek", difference.toInt());

    return difference.toInt();
  }

  void getCalculatedDate() async {
    String date = await SharedPreferencesUtil.getString('calculated_date');
    if (date != null) {
      print(date);
      setState(() {
        DateTime time = DateTime.parse(date);
        _parsedDate = '${time.day} / ${time.month} / ${time.year}';
        selectedDate = time;
      });
    }
  }

  int calculatePregnancyWeeks(DateTime estimatedBirthDate) {
    DateTime now = new DateTime.now();

    var diff = getDifferenceBetweenDatesInWeeks(estimatedBirthDate, now);
    print("diff inside");
    print(diff);

    var lastMenstruationDate = now.add(new Duration(days: -280 + (diff * 7)));

    return this.getDifferenceBetweenDatesInWeeks(lastMenstruationDate, now);
  }

  int getDifferenceBetweenDatesInWeeks(DateTime startDate, DateTime endDate) {
    var difference = startDate.difference(endDate).inDays / 7;
    difference = difference.abs();
    print("difference");
    print(difference);
    if (difference <= 1) {
      difference = 1;
    }
    return difference.toInt();
  }

  @override
  void initState() {
    super.initState();
    _parsedDate = formatDate(DateTime.now(), [dd, ' / ', mm, ' / ', yyyy]);
    SharedPreferencesUtil.getInt('user_id').then((onValue) {
      _userID = onValue;
    });
    getCalculatedDate();

    if (Platform.operatingSystem == "android") {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light));
      SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    } else {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.dark // this one for iOS
            ),
      );
      SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    }
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    CalculatorService calculatorService = new CalculatorService();

    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          // this is all you need
          title: Text(
            "CALCULADORA",
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
            width: screenSize.width,
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Lottie.asset('assets/images/14483-newborn.json', width: 250.0),
                SizedBox(height: screenSize.height / 32),
                Text(
                  "Selecione a data da sua última menstruação",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: screenSize.width / 28),
                ),
                SizedBox(height: screenSize.height / 32),
                Container(
                  margin: EdgeInsets.all(10),
                  width: 150,
                  height: 50.0,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                        side: BorderSide(color: Colors.orangeAccent)),
                    onPressed: () async {
                      DatePicker.showDatePicker(context,
                          currentTime: selectedDate,
                          theme: DatePickerTheme(
                            containerHeight: 210.0,
                          ),
                          showTitleActions: true,
                          minTime: await calculateMinDate(),
                          maxTime: await calculateMaxDate(),
                          onConfirm: (date) async {
                        print('confirm $date');
                        selectedDate = date;
                        _parsedDate =
                            '${date.day} / ${date.month} / ${date.year}';
                        calculateWeekBySetDate(date);

                        if (_userID != 0) {
                          print('userid');

                          print(_userID);
                        }

                        //await SharedPreferencesUtil.saveString(
                        //    'calculated_date', selectedDate.toString());

                        calculatorService
                            .calculatorByWeek(
                                calculateWeekBySetDate(selectedDate))
                            .then((val) {
                          if (val != null) {
                            val.selectedDateTime = selectedDate;
                            Navigator.of(context).pushNamed(
                                '/calculator_detail',
                                arguments: val);
                          }
                        });
                        setState(() {});
                      }, locale: LocaleType.es);
                    },
                    padding: EdgeInsets.all(10.0),
                    color: Colors.orangeAccent,
                    textColor: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(FontAwesomeIcons.calendarAlt),
                        Text(_parsedDate,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
