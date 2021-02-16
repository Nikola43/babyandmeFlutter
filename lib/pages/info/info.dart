import 'dart:async';

import 'package:babyandme/models/promo.dart';
import 'package:babyandme/utils/shared_preferences.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as maps;
import 'package:lottie/lottie.dart';
import 'package:maps_launcher/maps_launcher.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => {_add()});
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
      position: maps.LatLng(38.7567533, -9.095221),
      infoWindow: maps.InfoWindow(
          title: "Rua da Nau Catrineta, 3, 1990-183 Lisboa", snippet: ' '),
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
    SystemChrome.setEnabledSystemUIOverlays([]);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        // this is all you need
        backgroundColor: Colors.orangeAccent,

        title: Text("CONTACTO",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: new IconButton(
          icon: new Icon(
            FontAwesomeIcons.arrowLeft,
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
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Container(
              width: screenSize.width,
              height: screenSize.height / 2.5,
              child: maps.GoogleMap(
                myLocationButtonEnabled: false,
                markers: Set<maps.Marker>.of(markers.values),
                mapType: maps.MapType.normal,
                initialCameraPosition: maps.CameraPosition(
                  target: maps.LatLng(38.7565928, -9.0948698),
                  zoom: 14.4746,
                ),
                onMapCreated: (maps.GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
            ),
            SizedBox(height: screenSize.height / 32),
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Entre em contacto connosco",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold)),
                      SizedBox(height: screenSize.width / 32),
                      Container(
                        margin: EdgeInsets.all(10),
                        height: 50.0,
                        width: screenSize.width / 0.8,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              side: BorderSide(color: Colors.orangeAccent)),
                          onPressed: () {
                            _makeEmail("info.lisboa@ecox4d.pt", false);
                          },
                          padding: EdgeInsets.all(10.0),
                          color: Colors.orangeAccent,
                          textColor: Colors.white,
                          child: Text("Email: info.lisboa@ecox4d.pt",
                              style: TextStyle(
                                  fontSize: screenSize.width / 30,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        height: 50.0,
                        width: screenSize.width / 0.8,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              side: BorderSide(color: Colors.orangeAccent)),
                          onPressed: () {
                            _makePhoneCall('+351924244293', false);
                          },
                          padding: EdgeInsets.all(10.0),
                          color: Colors.orangeAccent,
                          textColor: Colors.white,
                          child: Text("Telemóvel: +351924244293",
                              style: TextStyle(
                                  fontSize: screenSize.width / 30,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        height: 50.0,
                        width: screenSize.width / 0.8,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              side: BorderSide(color: Colors.orangeAccent)),
                          onPressed: () {
                            _makePhoneCall('+351217960548', false);
                          },
                          padding: EdgeInsets.all(10.0),
                          color: Colors.orangeAccent,
                          textColor: Colors.white,
                          child: Text("Telefone: +351217960548",
                              style: TextStyle(
                                  fontSize: screenSize.width / 30,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        height: 50.0,
                        width: screenSize.width / 0.8,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              side: BorderSide(color: Colors.orangeAccent)),
                          onPressed: () {
                            MapsLauncher.launchQuery(
                                'Rua da Nau Catrineta, 3, 1990-183 Lisboa');
                          },
                          padding: EdgeInsets.all(10.0),
                          color: Colors.orangeAccent,
                          textColor: Colors.white,
                          child: Text(
                              "Endereço: Rua da Nau Catrineta, 3, 1990-183 Lisboa",
                              style: TextStyle(
                                  fontSize: screenSize.width / 30,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ])),
          ],
        ),
      ),
    );
  }
}
