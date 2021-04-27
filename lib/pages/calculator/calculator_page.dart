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
  CalculatorService calculatorService = new CalculatorService();

  Size screenSize;
  DateTime selectedDate = DateTime.now();
  String _parsedDate = formatDate(DateTime.now(), [dd, ' / ', mm, ' / ', yyyy]);
  String calculatedDateWeek = "";
  String calculatedDate = "";
  int currentWeek = 0;
  int userId = 0;

  DateTime calculateMaxDate() {
    var now = new DateTime.now();
    var maxDate = now.add(new Duration(days: 280));

    if (userId != null && userId > 0 && calculatedDateWeek != null) {
      maxDate = DateTime.parse(calculatedDateWeek)
          .add(new Duration(days: 280 - (40 - currentWeek) * 7));
    }

    return maxDate;
  }

  Future<DateTime> calculateMinDate() async {
    var now = new DateTime.now();
    DateTime minDate = now;

    if (userId != null && userId > 0 && calculatedDateWeek != null) {
      minDate = DateTime.parse(calculatedDateWeek)
          .add(new Duration(days: -(40 - currentWeek) * 7));
    }

    return minDate;
  }

  int calculateWeekBySetDate(DateTime selectedDate) {
    var difference = new DateTime.now().difference(selectedDate).inDays / 7;
    print(difference);
    difference = difference.abs();
    if (difference <= 1) {
      difference = 1;
    }
    return difference.toInt();
  }

  void getCalculatedDate() async {
    userId = await SharedPreferencesUtil.getInt('user_id');

    calculatedDateWeek =
        await SharedPreferencesUtil.getString('calculated_date_week');
    calculatedDate = await SharedPreferencesUtil.getString('calculated_date');
    currentWeek = await SharedPreferencesUtil.getInt('currentWeek');

    print("calculatedDateWeek");
    print(calculatedDateWeek);
    print("calculatedDate");
    print(calculatedDate);
    print("currentWeek");
    print(currentWeek.toString());

    print("calculatedDateWeek");
    if (userId != null && userId > 0 && calculatedDateWeek != null) {
      /*
      var d =
      DateTime.parse(calculatedDate).difference(new DateTime.now()).inDays;

      print("d");
      print(d);
      var diff = getDifferenceBetweenDatesInWeeks(
          DateTime.parse(calculatedDateWeek), new DateTime.now());
      print("getCalculatedDate");
      print(diff);
      */

      setState(() {
        DateTime time = DateTime.parse(calculatedDateWeek);
        //time = time.add(new Duration(days: d));
        _parsedDate = '${time.day} / ${time.month} / ${time.year}';
        selectedDate = time;
      });
    }
  }

  int calculatePregnancyWeeks(DateTime estimatedBirthDate) {
    var now = new DateTime.now();
    int diff = getDifferenceBetweenDatesInWeeks(estimatedBirthDate, now);

    print(calculatedDateWeek);

    /*
    if (userId != null && userId > 0 && calculatedDateWeek != null) {
      diff = getDifferenceBetweenDatesInWeeks(estimatedBirthDate, DateTime.parse(calculatedDate));
    }
    */

    print("diff inside");
    print(diff);

    var lastMenstruationDate = now.add(new Duration(days: -280 + (diff * 7)));

    int weeks =
        this.getDifferenceBetweenDatesInWeeks(lastMenstruationDate, now);
    if (weeks == 0) {
      weeks = 1;
    }

    return weeks;
  }

  int getDifferenceBetweenDatesInWeeks(DateTime startDate, DateTime endDate) {
    var difference = startDate.difference(endDate).inDays / 7;
    difference = difference.abs();
    print("getDifferenceBetweenDatesInWeeks");
    print(difference);
    return difference.toInt();
  }

  @override
  void initState() {
    super.initState();

    getCalculatedDate();
    SystemChrome.setEnabledSystemUIOverlays([]);
    /*
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
    */
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;

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
                  "Selecione a data prevista para o parto",
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
                          maxTime: calculateMaxDate(), onConfirm: (date) async {
                        print('confirm $date');
                        selectedDate = date;
                        _parsedDate =
                            '${date.day} / ${date.month} / ${date.year}';



                        var week = calculatePregnancyWeeks(date);
                        print("week");
                        print(week);


                        calculatorService.calculatorByWeek(week).then((val) {
                          if (val != null) {
                            print("val");
                            print(val);
                            val.selectedDateTime = selectedDate;
                            Navigator.of(context).pushNamed(
                                '/calculator_detail',
                                arguments: val);
                          }
                        });

                        setState(() {});
                      }, locale: LocaleType.pt);
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
                                fontSize: 14, fontWeight: FontWeight.bold)),
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
