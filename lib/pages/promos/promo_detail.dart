import 'package:babyandme/models/promo.dart';
import 'package:babyandme/pages/appointment/appointment.dart';
import 'package:babyandme/utils/shared_preferences.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:universal_io/io.dart';
import 'package:flutter/services.dart';

class PromoDetail extends StatefulWidget {
  static const routeName = '/promo_detail';

  PromoDetail({Key key}) : super(key: key);

  _PromoDetailState createState() => _PromoDetailState();
}

class _PromoDetailState extends State<PromoDetail> {
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
    _parsedDate = formatDate(DateTime.now(), [dd, '-', mm, '-', yyyy]);

    super.initState();
    SharedPreferencesUtil.getInt('user_id').then((onValue) {
      _userID = onValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    Promo promo = ModalRoute.of(context).settings.arguments;
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          centerTitle: true,
          // this is all you need
          title: Text(promo.title,
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
                SizedBox(height: screenSize.height / 8),
                Lottie.asset('assets/images/16367-madre-embarazada.json',
                    width: 250.0),
                SizedBox(height: screenSize.height / 32),
                Padding(
                    padding: EdgeInsets.only(left: 25, right: 25),
                    child: Text(
                      promo.text,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15),
                    )),
                SizedBox(height: screenSize.height / 32),
                Padding(
                    padding: EdgeInsets.only(left: 25, right: 25),
                    child: Text(
                        "Válido desde " +
                            formatDate(DateTime.parse(promo.start_at),
                                [dd, '-', mm, '-', yyyy]) +
                            " hasta " +
                            formatDate(DateTime.parse(promo.end_at),
                                [dd, '-', mm, '-', yyyy]),
                        style: TextStyle(
                            color: DateTime.parse(promo.end_at)
                                    .isAfter(DateTime.now())
                                ? Colors.green
                                : Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 15))),
                SizedBox(height: screenSize.height / 32),
                DateTime.parse(promo.end_at).isAfter(DateTime.now())
                    ? Container(
                        margin: EdgeInsets.all(10),
                        height: 50.0,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              side: BorderSide(color: Colors.orangeAccent)),
                          onPressed: () {
                            Navigator.pushNamed(
                                context, AppointmentPage.routeName);
                          },
                          padding: EdgeInsets.all(10.0),
                          color: Colors.orangeAccent,
                          textColor: Colors.white,
                          child: Text("Solicitar",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ));
  }
}
