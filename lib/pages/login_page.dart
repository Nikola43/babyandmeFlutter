import 'package:babyandme/services/login_service.dart';
import 'package:babyandme/utils/shared_preferences.dart';
import 'package:babyandme/utils/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'forgot_password_page.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginService loginService = LoginService();
  final TextEditingController usernameController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  Size _screenSize;

  @override
  Widget build(BuildContext context) {
    usernameController.text = "prueba@gmail.com";
    passwordController.text = "ecodadys";

    _screenSize = MediaQuery.of(context).size;

    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.white));
    return Scaffold(
        appBar: AppBar(),
        body: Stack(children: <Widget>[
          Image.asset(
            'assets/family.jpg',
            width: _screenSize.width,
            height: _screenSize.height,
            fit: BoxFit.fill,
          ),
          Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Image(image: AssetImage('assets/logo.png')),
                Column(
                  children: <Widget>[
                    _formInput(context, Icons.email, 'Email', false,
                        usernameController),
                    _formInput(context, Icons.lock, 'Contraseña', true,
                        passwordController),
                  ],
                ),
                _loginPasswordRow(context, loginService,
                    usernameController.text, passwordController.text),
              ],
            ),
          )
        ]));
  }
}

Widget _formInput(BuildContext context, IconData iconData, String label,
    obscured, TextEditingController textEditingController) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
    child: TextField(
        controller: textEditingController,
        obscureText: obscured,
        cursorColor: Theme.of(context).primaryColor,
        decoration:
            InputDecoration(prefixIcon: Icon(iconData), labelText: label)),
  );
}

Widget _loginPasswordRow(BuildContext context, LoginService loginService,
    String username, String password) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      _loginButton(context, loginService, username, password),
      _forgotPasswordButton(context),
    ],
  );
}

Widget _loginButton(BuildContext context, LoginService loginService,
    String username, String password) {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {
          print(username);
          if (username.length < 1) {
            ToastUtil.makeToast("Introduzca el nombre de usuario");
            return;
          }

          if (password.length < 1) {
            ToastUtil.makeToast("Introduzca la contraseña");
            return;
          }

          if (password.length > 0 && username.length > 0) {
            loginService.login(username, password).then((user) {
              if (user != null) {
                SharedPreferencesUtil.saveInt("user_id", user.id);
                SharedPreferencesUtil.saveString("token", user.token.string);
                print(user.token.string);

                ToastUtil.makeToast("Bienvenido a ecodadys");

                Navigator.of(context).pushNamed('/main_menu');
              } else {
                ToastUtil.makeToast("Usuario no encontrado");
              }
            });
          }
        },
        child: Container(
            alignment: Alignment.center,
            height: 60.0,
            decoration: BoxDecoration(
                color: Color.fromRGBO(105, 95, 145, 1),
                borderRadius: BorderRadius.circular(9.0)),
            child: Text("Entrar",
                style: TextStyle(fontSize: 20.0, color: Colors.white))),
      ),
    ),
  );
}

Widget _forgotPasswordButton(BuildContext context) {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ForgotPasswordPage()));
        },
        child: Container(
            alignment: Alignment.center,
            height: 60.0,
            child: Text("¿Olvidó su contraseña?",
                style: TextStyle(
                    fontSize: 17.0, color: Color.fromRGBO(105, 95, 145, 1)))),
      ),
    ),
  );
}
