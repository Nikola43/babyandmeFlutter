import 'dart:ui';
import 'package:another_flushbar/flushbar.dart';
import 'package:babyandme/login_screen.dart';
import 'package:babyandme/utils/shared_preferences.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import '../../dashboard_screen.dart';
import 'package:universal_io/io.dart';
import 'package:flutter/services.dart';

class AppointmentPage extends StatefulWidget {
  static const routeName = '/appointment';

  AppointmentPage({Key key}) : super(key: key);

  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  Size screenSize;
  TextEditingController _nameTextEditingController = TextEditingController();
  TextEditingController _phoneTextEditingController = TextEditingController();
  TextEditingController _emailTextEditingController = TextEditingController();
  FocusNode _nameTextEditingFocusNode;
  FocusNode _phoneTextEditingFocusNode;
  FocusNode _emailTextEditingFocusNode;

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
    final openFrom = ModalRoute.of(context).settings.arguments;

    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          // this is all you need
          title: Text(
            "CITAS",
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
                SizedBox(height: screenSize.height / 16),
                Image.asset("assets/images/undraw_doctors_hwty.png"),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                              width: screenSize.width / 1.2,
                              child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    TextField(
                                      keyboardType: TextInputType.name,
                                      textAlign: TextAlign.center,
                                      controller: _nameTextEditingController,
                                      textCapitalization:
                                          TextCapitalization.characters,
                                      focusNode: _nameTextEditingFocusNode,
                                      autofocus: false,
                                      decoration: InputDecoration(
                                        filled: true,
                                        counterStyle:
                                            TextStyle(color: Colors.black),
                                        fillColor: Colors.white,
                                        //Add th Hint text here.
                                        hintText: "Nombre",

                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: screenSize.height / 64),
                                    TextField(
                                      keyboardType: TextInputType.emailAddress,
                                      textAlign: TextAlign.center,
                                      controller: _emailTextEditingController,
                                      textCapitalization:
                                          TextCapitalization.characters,
                                      focusNode: _emailTextEditingFocusNode,
                                      autofocus: false,
                                      decoration: InputDecoration(
                                        filled: true,
                                        counterStyle:
                                            TextStyle(color: Colors.black),
                                        fillColor: Colors.white,
                                        //Add th Hint text here.
                                        hintText: "Email",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: screenSize.height / 64),
                                    TextField(
                                      keyboardType: TextInputType.phone,
                                      textAlign: TextAlign.center,
                                      controller: _phoneTextEditingController,
                                      textCapitalization:
                                          TextCapitalization.characters,
                                      focusNode: _phoneTextEditingFocusNode,
                                      autofocus: false,
                                      decoration: InputDecoration(
                                        filled: true,
                                        counterStyle:
                                            TextStyle(color: Colors.black),
                                        fillColor: Colors.white,
                                        //Add th Hint text here.
                                        hintText: "Telefone",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: screenSize.height / 16),
                                    Container(
                                      margin: EdgeInsets.all(10),
                                      height: 50.0,
                                      child: RaisedButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                            side: BorderSide(
                                                color: Colors.orangeAccent)),
                                        onPressed: () {
                                          if (_nameTextEditingController
                                                  .value.text.length ==
                                              0) {
                                            FocusScope.of(context).requestFocus(
                                                _nameTextEditingFocusNode);
                                            Flushbar(
                                              backgroundColor:
                                                  Colors.orangeAccent,
                                              title: "El nombre es obligatorio",
                                              message: " ",
                                              duration: Duration(seconds: 3),
                                            )..show(context);
                                          } else if (_emailTextEditingController
                                                  .value.text.length ==
                                              0) {
                                            FocusScope.of(context).requestFocus(
                                                _phoneTextEditingFocusNode);
                                            Flushbar(
                                              backgroundColor:
                                                  Colors.orangeAccent,
                                              title: "El email es obligatorio",
                                              message: " ",
                                              duration: Duration(seconds: 3),
                                            )..show(context);
                                          } else if (_phoneTextEditingController
                                                  .value.text.length ==
                                              0) {
                                            FocusScope.of(context).requestFocus(
                                                _phoneTextEditingFocusNode);
                                            Flushbar(
                                              backgroundColor:
                                                  Colors.orangeAccent,
                                              title:
                                                  "El telefono es obligatorio",
                                              message: " ",
                                              duration: Duration(seconds: 3),
                                            )..show(context);
                                          } else {
                                            Flushbar(
                                              backgroundColor:
                                                  Colors.orangeAccent,
                                              title:
                                                  "Solicitud enviada correctamente",
                                              message: " ",
                                              duration: Duration(seconds: 3),
                                            )..show(context);

                                            Future.delayed(Duration(seconds: 4),
                                                () {
                                              if (openFrom != null &&
                                                  openFrom == 'login') {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          LoginScreen()),
                                                );
                                              } else {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          DashboardScreen()),
                                                );
                                              }
                                            });
                                          }
                                        },
                                        padding: EdgeInsets.all(10.0),
                                        color: Colors.orangeAccent,
                                        textColor: Colors.white,
                                        child: Text("ENVIAR",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                  ]))),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
