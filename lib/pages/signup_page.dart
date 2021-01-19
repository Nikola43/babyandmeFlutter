import 'package:flutter/material.dart';
import 'login_page.dart';


class SignupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(backgroundColor: Colors.transparent, elevation: 0.0),
      body: Container(
        width: double.infinity,
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage('assets/images/quantika.png')),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
              child: new TextField(
                decoration: new InputDecoration(labelText: 'Nombre'),
              ),
            ),
            new SizedBox(
              height: 15.0,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
              child: new TextField(
                decoration: new InputDecoration(labelText: 'Email'),
              ),
            ),
            new SizedBox(
              height: 15.0,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
              child: new TextField(
                obscureText: true,
                decoration: new InputDecoration(labelText: 'Contraseña'),
              ),
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 5.0, top: 10.0),
                    child: GestureDetector(
                      onTap: () {

                      },
                      child: new Container(
                          alignment: Alignment.center,
                          height: 60.0,
                          decoration: new BoxDecoration(
                              color: Color.fromRGBO(105, 95, 145, 1),
                              borderRadius: new BorderRadius.circular(9.0)),
                          child: new Text("Regístrate",
                              style: new TextStyle(
                                  fontSize: 20.0, color: Colors.white))),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 20.0, top: 10.0),
                      child: new Container(
                          alignment: Alignment.center,
                          height: 60.0,
                          child: new Text("¿Tienes cuenta?",
                              style: new TextStyle(
                                  fontSize: 17.0,
                                  color: Color.fromRGBO(105, 95, 145, 1)))),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
