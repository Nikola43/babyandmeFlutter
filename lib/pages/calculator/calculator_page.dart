import 'package:babyandme/services/calculator_service.dart';
import 'package:babyandme/utils/shared_preferences.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

  DateTime calculateMinDate() {
    var now = new DateTime.now();
    var minDate = now.add(new Duration(days: -280));
    return minDate;
  }

  int calculateWeekBySetDate(DateTime selectedDate) {
    var difference = new DateTime.now().difference(selectedDate).inDays / 7;
    print(difference);
    if (difference <= 1) {
      difference = 1;
    }
    SharedPreferencesUtil.saveInt("currentWeek", difference.toInt());

    return difference.toInt();
  }

  @override
  void initState() {
    super.initState();
    _parsedDate = formatDate(DateTime.now(), [dd, ' / ', mm, ' / ', yyyy]);
    SharedPreferencesUtil.getInt('user_id').then((onValue) {
      _userID = onValue;
    });
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
    final openFrom = ModalRoute.of(context).settings.arguments;
    CalculatorService calculatorService = new CalculatorService();

    SystemChrome.setEnabledSystemUIOverlays([]);

    return Stack(children: [
      Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/Mama-bebe.png"),
            // <-- BACKGROUND IMAGE
            fit: BoxFit.cover,
          ),
        ),
      ),
      Container(
        color: Color.fromRGBO(0, 0, 0, 0.25098039215686274),
        width: screenSize.width,
        height: screenSize.height,
      ),
      Scaffold(
        backgroundColor: Colors.transparent,
        // <-- SCAFFOLD WITH TRANSPARENT BG
        appBar: AppBar(
          centerTitle: true, // this is all you need
          backgroundColor: Colors.orangeAccent,
          elevation: 0,
          title: Text(
            "CALCULADORA",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          leading: new IconButton(
              icon: new Icon(FontAwesomeIcons.arrowLeft, color: Colors.white),
              onPressed: () => {Navigator.pop(context)}),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              SizedBox(height: screenSize.height / 4),
              Text(
                "Selecione a data da sua última menstruação",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: screenSize.width / 28),
              ),
              SizedBox(height: screenSize.height / 32),

              Container(
                  width: 200,
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0)),
                          elevation: 4.0,
                          onPressed: () {
                            DatePicker.showDatePicker(context,
                                theme: DatePickerTheme(
                                  containerHeight: 210.0,
                                ),
                                showTitleActions: true,
                                minTime: calculateMinDate(),
                                maxTime: new DateTime.now(), onConfirm: (date) {
                              print('confirm $date');
                              selectedDate = date;
                              _parsedDate =
                                  '${date.day} / ${date.month} / ${date.year}';
                              calculateWeekBySetDate(date);
                              setState(() {});
                            },
                                currentTime: DateTime.now(),
                                locale: LocaleType.es);
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
                                            color: Colors.orangeAccent,
                                          ),
                                          Text(
                                            " $_parsedDate",
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
                        SizedBox(height: screenSize.height / 16),
                        Container(
                          margin: EdgeInsets.all(10),
                          height: 50.0,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                                side: BorderSide(color: Colors.orangeAccent)),
                            onPressed: () {
                              if (_userID != 0) {
                                print('userid');

                                print(_userID);
                              }

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
                            },
                            padding: EdgeInsets.only(left: 20, right: 20),
                            color: Colors.orangeAccent,
                            textColor: Colors.white,
                            child: Text("CALCULAR",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                          ),
                        )
                      ])),
            ],
          ),
        ),
      ),
    ]);
  }
}
