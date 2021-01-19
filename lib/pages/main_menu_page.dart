import 'package:babyandme/utils/shared_preferences.dart';
import 'package:babyandme/utils/toast_util.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class MainMenuPage extends StatefulWidget {
  @override
  _MainMenuPageState createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  Size _screenSize;
  double _optionMenuSize;
  double _iconMenuSize;
  double _optionMenuMargin;
  Color _optionMenuColor = Colors.grey;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    _optionMenuSize = _screenSize.width / 5;
    _iconMenuSize = _screenSize.width / 5;
    _optionMenuMargin = _screenSize.height / 22;

    return Scaffold(
      body: Stack(children: <Widget>[
        Image.asset(
          'assets/fondo_2.jpg',
          width: _screenSize.width,
          height: _screenSize.height,
          fit: BoxFit.fill,
        ),
        Column(
          children: <Widget>[
            SizedBox(height: _screenSize.height / 10),
            Image(image: AssetImage('assets/logo.png')),
            SizedBox(height: _screenSize.height / 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildMenuButton('assets/heart.png', 'Latido', '/heartbeat'),
                SizedBox(width: _optionMenuMargin),
                _buildMenuButton('assets/gift.png', 'Promos', '/promos'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildMenuButton('assets/camera.png', 'Fotos', '/images'),
                SizedBox(width: _optionMenuMargin),
                _buildMenuButton('assets/video.png', 'Videos', '/videos'),
                SizedBox(width: _optionMenuMargin),
                _buildMenuButton(
                    'assets/holovision.png', 'Holovisión', '/holo'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildMenuButton(
                    'assets/streaming.png', 'Streaming', '/streaming_code'),
                SizedBox(width: _optionMenuMargin),
                _buildMenuButton(
                    'assets/calendar.png', 'Calculadora', '/calculator')
              ],
            ),
            SizedBox(height: _screenSize.height / 10),
            _buildLoginButton(),
            _buildLogoutButton()
          ],
        ),
      ]),
    );
  }

  Widget _buildMenuButton(String icon, String label, String route) {
    return GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(route);
        },
        child: Transform.rotate(
            angle: pi / 4,
            child: Container(
                height: _optionMenuSize,
                width: _optionMenuSize,
                color: _optionMenuColor,
                child: Transform.rotate(
                    angle: pi / -4,
                    child: Container(
                        height: _iconMenuSize,
                        width: _iconMenuSize,
                        child: _buildMenuIcon(icon, label))))));
  }

  Widget _buildLogoutButton() {
    return FutureBuilder(
        future: SharedPreferencesUtil.getString("token"),
        initialData: "",
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data != null) {
            return RaisedButton(
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.red)),
              onPressed: () {
                setState(() {
                  ToastUtil.makeToast("Hasta luego");
                  SharedPreferencesUtil.removeItem("token");
                });
              },
              color: Colors.pink,
              textColor: Colors.white,
              child: Text("Cerrar Sesion".toUpperCase(),
                  style: TextStyle(fontSize: 20)),
            );
          } else {
            return Container();
          }
        });
  }

  Widget _buildLoginButton() {
    return FutureBuilder(
      future: SharedPreferencesUtil.getString("token"),
      initialData: "",
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data == null) {
          return RaisedButton(
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.red)),
            onPressed: () {
              Navigator.of(context).pushNamed('/login');
            },
            color: Colors.pink,
            textColor: Colors.white,
            child: Text("Entrar".toUpperCase(), style: TextStyle(fontSize: 20)),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildMenuIcon(String asset, String text) {
    return Column(children: <Widget>[
      Image.asset(
        asset,
        height: 50,
        width: 50,
      ),
      Text(
        text,
        style: TextStyle(fontSize: 14.0, color: Colors.white),
      )
    ]);
  }
}
