import 'dart:async';

import 'package:babyandme/models/promo.dart';
import 'package:babyandme/utils/shared_preferences.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as maps;
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../dashboard_screen.dart';

class InfoPage extends StatefulWidget {
  static const routeName = '/info_page';

  InfoPage({Key key}) : super(key: key);

  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  Size screenSize;
  Completer<maps.GoogleMapController> _controller = Completer();
  Map<maps.MarkerId, maps.Marker> markers = <maps.MarkerId, maps.Marker>{};

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

    WidgetsBinding.instance.addPostFrameCallback((_) => {_add()});
    _parsedDate = formatDate(DateTime.now(), [dd, '-', mm, '-', yyyy]);

    SharedPreferencesUtil.getInt('user_id').then((onValue) {
      _userID = onValue;
    });
  }

  Future<void> _makeEmail(String contact, bool direct) async {
    if (direct == true) {
      bool res = await FlutterPhoneDirectCaller.callNumber(contact);
    } else {
      String telScheme = 'mailto:$contact';

      if (await canLaunch(telScheme)) {
        await launch(telScheme);
      } else {
        throw 'Could not launch $telScheme';
      }
    }
  }

  Future<void> _makePhoneCall(String contact, bool direct) async {
    if (direct == true) {
      bool res = await FlutterPhoneDirectCaller.callNumber(contact);
    } else {
      String telScheme = 'tel:$contact';

      if (await canLaunch(telScheme)) {
        await launch(telScheme);
      } else {
        throw 'Could not launch $telScheme';
      }
    }
  }

  void _add() {
    final int markerCount = markers.length;

    if (markerCount == 12) {
      return;
    }

    final String markerIdVal = 'marker_id_1';
    final maps.MarkerId markerId = maps.MarkerId(markerIdVal);

    final maps.Marker marker = maps.Marker(
      markerId: markerId,
      position: maps.LatLng(38.7565928, -9.0948698),
      infoWindow: maps.InfoWindow(
          title: "Rua da Nau Catrineta, 1D, 1990-183 Lisboa", snippet: ' '),
      onTap: () {
        //_onMarkerTapped(markerId);
      },
      onDragEnd: (maps.LatLng position) {
        //_onMarkerDragEnd(markerId, position);
      },
    );

    setState(() {
      markers[markerId] = marker;
    });
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    Promo promo = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        // this is all you need
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text("Info", style: TextStyle(color: Colors.white)),
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
        color: Colors.orangeAccent,
        child: Column(
          children: [
            SizedBox(height: screenSize.height / 16),
            Stack(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Align(
                      child: Padding(
                        padding: const EdgeInsets.only(left:32.0, right: 32.0, top: 32),
                        child: ClipRRect(
                          borderRadius: new BorderRadius.circular(10.0),
                          child: Container(
                            width: screenSize.width,
                            height: screenSize.height / 2,
                            child: maps.GoogleMap(
                              markers: Set<maps.Marker>.of(markers.values),
                              mapType: maps.MapType.normal,
                              initialCameraPosition: maps.CameraPosition(
                                target: maps.LatLng(38.7565928, -9.0948698),
                                zoom: 14.4746,
                              ),
                              onMapCreated:
                                  (maps.GoogleMapController controller) {
                                _controller.complete(controller);
                              },
                            ),
                          ),
                        ),
                      ),
                      //child: Image.asset('assets/$assetName.jpg', width: 350.0),
                      alignment: Alignment.topCenter,
                    ),
                    SizedBox(height: screenSize.height / 32),
                    Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              FlatButton(
                                  onPressed: () => {
                                        _makeEmail("info@babyandme.pt", false),
                                      },
                                  child: Text(
                                    "Email: info@babyandme.pt",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0),
                                  )),
                              SizedBox(height: screenSize.height / 64),
                              FlatButton(
                                  onPressed: () => {
                                        _makePhoneCall('+351217960548', false),
                                      },
                                  child: Text(
                                    "Telemóvel: +351217960548",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0),
                                  )),
                              SizedBox(height: screenSize.height / 64),
                              FlatButton(
                                  onPressed: () => {
                                        _makePhoneCall('+351924244293', false),
                                      },
                                  child: Text(
                                    "Telemóvel: +351924244293",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0),
                                  ))
                            ])),
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
