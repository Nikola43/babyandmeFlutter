import 'package:babyandme/models/promo.dart';
import 'package:babyandme/utils/shared_preferences.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:lottie/lottie.dart';
import '../../dashboard_screen.dart';

class InfoPage extends StatefulWidget {
  static const routeName = '/info_page';

  InfoPage({Key key}) : super(key: key);

  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
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

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        // this is all you need
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text("Citas", style: TextStyle(color: Colors.white)),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                      "Introduzca sus datos para pedir cita",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                    SizedBox(height: screenSize.height / 32),
                    Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                            width: screenSize.width / 1.5,
                            child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  
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
