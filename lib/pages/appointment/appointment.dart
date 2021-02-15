import 'dart:ui';
import 'package:another_flushbar/flushbar.dart';
import 'package:babyandme/login_screen.dart';
import 'package:babyandme/utils/shared_preferences.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
    var difference = new DateTime.now()
        .difference(selectedDate)
        .inDays / 7;
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
    screenSize = MediaQuery
        .of(context)
        .size;
    final openFrom = ModalRoute
        .of(context)
        .settings
        .arguments;

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
            title: Text(
              "CITAS",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.orangeAccent,
            leading: new IconButton(
                icon: new Icon(FontAwesomeIcons.arrowLeft, color: Colors.white),
                onPressed: () => {Navigator.pop(context)}),
          ),
          body: Center(
            child: Column(
              children: <Widget>[
                SizedBox(height: screenSize.height / 32),
                Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                        width: screenSize.width / 1.2,
                        child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4.0),
                                child: BackdropFilter(
                                  filter:
                                  ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(4.0),
                                        border:
                                        Border.all(color: Colors.white)),
                                    padding:
                                    EdgeInsets.only(left: 20, right: 20),
                                    child: TextFormField(
                                      controller: _nameTextEditingController,
                                      focusNode: _nameTextEditingFocusNode,
                                      style: TextStyle(color: Colors.white),
                                      cursorColor: Colors.white,
                                      keyboardType: TextInputType.name,
                                      decoration: new InputDecoration(
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                          hintText: 'Nombre',
                                          hintStyle:
                                          TextStyle(color: Colors.white)),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: screenSize.height / 64),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4.0),
                                child: BackdropFilter(
                                  filter:
                                  ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(4.0),
                                        border:
                                        Border.all(color: Colors.white)),
                                    padding:
                                    EdgeInsets.only(left: 20, right: 20),
                                    child: TextFormField(
                                      controller: _emailTextEditingController,
                                      focusNode: _emailTextEditingFocusNode,
                                      style: TextStyle(color: Colors.white),
                                      cursorColor: Colors.white,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: new InputDecoration(
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                          hintText: 'Email',
                                          hintStyle:
                                          TextStyle(color: Colors.white)),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: screenSize.height / 64),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4.0),
                                child: BackdropFilter(
                                  filter:
                                  ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                                  child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(4.0),
                                          border:
                                          Border.all(color: Colors.white)),
                                      padding:
                                      EdgeInsets.only(left: 20, right: 20),
                                      child: TextFormField(
                                        controller: _phoneTextEditingController,
                                        focusNode: _phoneTextEditingFocusNode,
                                        style: TextStyle(color: Colors.white),
                                        cursorColor: Colors.white,
                                        keyboardType: TextInputType.phone,
                                        decoration: new InputDecoration(
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                            hintText: 'Teléfono',
                                            hintStyle:
                                            TextStyle(color: Colors.white)),
                                      )),
                                ),
                              ),
                              SizedBox(height: screenSize.height / 16),
                              Container(
                                margin: EdgeInsets.all(10),
                                height: 50.0,
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4.0),
                                      side: BorderSide(
                                          color: Colors.orangeAccent)),
                                  onPressed: () {
                                    if (_nameTextEditingController
                                        .value.text.length ==
                                        0) {
                                      FocusScope.of(context).requestFocus(
                                          _nameTextEditingFocusNode);
                                      Flushbar(
                                        title: "El nombre es obligatorio",
                                        message: " ",
                                        duration: Duration(seconds: 3),
                                      )
                                        ..show(context);
                                    } else if (_phoneTextEditingController
                                        .value.text.length ==
                                        0) {
                                      FocusScope.of(context).requestFocus(
                                          _phoneTextEditingFocusNode);
                                      Flushbar(
                                        title: "El telefono es obligatorio",
                                        message: " ",
                                        duration: Duration(seconds: 3),
                                      )
                                        ..show(context);
                                    } else {
                                      Flushbar(
                                        title:
                                        "Solicitud enviada correctamente",
                                        message: " ",
                                        duration: Duration(seconds: 3),
                                      )
                                        ..show(context);

                                      Future.delayed(Duration(seconds: 4), () {
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
                                  child: Text("Enviar",
                                      style: TextStyle(fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ]))),
              ],
            ),
          ))
    ]);
  }
}
