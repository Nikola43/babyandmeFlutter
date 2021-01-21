import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemUiOverlayStyle(
      statusBarColor: Colors.white, //top bar color
      statusBarIconBrightness: Brightness.dark, //top bar icons
    );
    return Scaffold(
        appBar: AppBar(  centerTitle: true, // this is all you need
            backgroundColor: Colors.transparent, elevation: 0.0),
        body: Container(
          width: double.infinity,
          child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image(image: AssetImage('assets/images/quantika.png')),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 0.0),
                  child: new TextField(
                    decoration: new InputDecoration(labelText: 'Email'),
                  ),
                ),
                new SizedBox(
                  height: 40.0,
                ),
                GestureDetector(
                    onTap: () {
                      Fluttertoast.showToast(
                          msg:
                              "Enviado. En breve le llegará un email de recuperación",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    },
                    child: new Container(
                        alignment: Alignment.center,
                        height: 60.0,
                        width: 300,
                        decoration: new BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: new BorderRadius.circular(9.0)),
                        child: new Text("Enviar",
                            style: new TextStyle(
                                fontSize: 20.0, color: Colors.white)))),
              ]),
        ));
  }
}
