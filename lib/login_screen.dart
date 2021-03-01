import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:babyandme/services/recovery_password_service.dart';
import 'package:babyandme/services/signup_service.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/scheduler.dart' show SchedulerBinding, timeDilation;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dashboard_screen.dart';
import 'services/login_service.dart';
import 'package:babyandme/utils/toast_util.dart';

import 'utils/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/auth';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
  }

  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 2250);

  final LoginService loginService = LoginService();
  final SignUpService signUpService = SignUpService();

  final RecoveryPasswordService recoveryPasswordService =
      RecoveryPasswordService();

  Future<String> _singUpUser(LoginData data) async {
    var insertResult = await signUpService.signUp(data.name, data.password);
    print(insertResult);

    if (insertResult == true) {
      var user = await loginService.login(data.name, data.password);
      if (user != null && user.id > 0) {
        await SharedPreferencesUtil.saveInt("user_id", user.id);
        await SharedPreferencesUtil.saveString("token", user.token.string);
        await SharedPreferencesUtil.saveInt("currentWeek", user.week);

        ToastUtil.makeToast("Bem-vindo a Baby&Me by ecox Lisboa");
        return null;
      } else {
        return 'Error usuario ya registrado';
      }
    } else {
      return 'Error usuario ya registrado';
    }

    /*

    if (user != null) {
      await SharedPreferencesUtil.saveInt("user_id", user.id);
      await SharedPreferencesUtil.saveString("token", user.token.string);
      await SharedPreferencesUtil.saveInt("currentWeek", user.week);

      ToastUtil.makeToast("Bem-vindo a Baby&Me by ecox Lisboa");
      return null;
    } else {
      ToastUtil.makeToast("Usuário não encontrado");
      return 'Usuário ou senha incorrectos';
    }
    */
  }

  Future<String> _loginUser(LoginData data) async {
    var user = await loginService.login(data.name, data.password);

    if (user != null) {
      await SharedPreferencesUtil.saveInt("user_id", user.id);
      await SharedPreferencesUtil.saveString("token", user.token.string);
      await SharedPreferencesUtil.saveInt("currentWeek", user.week);

      ToastUtil.makeToast("Bem-vindo a Baby&Me by ecox Lisboa");
      return null;
    } else {
      ToastUtil.makeToast("Usuário não encontrado");
      return 'Usuário ou senha incorrectos';
    }
  }

  Future<String> _recoverPassword(String name) async {
    var ok = await recoveryPasswordService.recoveryPassword(name);
    if (ok != null) {
      return null;
    } else {
      return 'Erro';
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    final inputBorder = BorderRadius.vertical(
      bottom: Radius.circular(10.0),
      top: Radius.circular(20.0),
    );
    return WillPopScope(
        onWillPop: () async {
          // ToastUtil.makeToast("Usuario no encontrado");
          return false;
        },
        child: Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: false,
            // <-- SCAFFOLD WITH TRANSPARENT BG
            appBar: AppBar(
              centerTitle: true, // this is all you need
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: new IconButton(
                  icon:
                      new Icon(FontAwesomeIcons.arrowLeft, color: Colors.white),
                  onPressed: () => {Navigator.pop(context)}),
            ),
            body: FlutterLogin(
              title: null,
              logo: 'assets/images/babyandmebranco.png',
              messages: LoginMessages(
                usernameHint: 'Email',
                passwordHint: 'Senha',
                confirmPasswordHint: 'Confirmar',
                loginButton: 'Entrar',
                signupButton: 'Registe-se',
                forgotPasswordButton: 'Esqueceu a senha?',
                recoverPasswordButton: 'Enviar',
                goBackButton: 'Voltar',
                confirmPasswordError: 'As senhas não são as mesmas',
                recoverPasswordIntro: 'Recuperar a senha',
                recoverPasswordDescription:
                    'Digite o seu e-mail para recuperar a senha',
                recoverPasswordSuccess:
                    'E-mail enviado. Verifique a sua caixa de entrada.',
              ),
              // theme: LoginTheme(
              //   primaryColor: Colors.teal,
              //   accentColor: Colors.yellow,
              //   errorColor: Colors.deepOrange,
              //   pageColorLight: Colors.indigo.shade300,
              //   pageColorDark: Colors.indigo.shade500,
              //   titleStyle: TextStyle(
              //     color: Colors.greenAccent,
              //     fontFamily: 'Quicksand',
              //     letterSpacing: 4,
              //   ),
              //   // beforeHeroFontSize: 50,
              //   // afterHeroFontSize: 20,
              //   bodyStyle: TextStyle(
              //     fontStyle: FontStyle.italic,
              //     decoration: TextDecoration.underline,
              //   ),
              //   textFieldStyle: TextStyle(
              //     color: Colors.orangeAccent,
              //     shadows: [Shadow(color: Colors.yellow, blurRadius: 2)],
              //   ),
              //   buttonStyle: TextStyle(
              //     fontWeight: FontWeight.w800,
              //     color: Colors.yellow,
              //   ),
              //   cardTheme: CardTheme(
              //     color: Colors.yellow.shade100,
              //     elevation: 5,
              //     margin: EdgeInsets.only(top: 15),
              //     shape: ContinuousRectangleBorder(
              //         borderRadius: BorderRadius.circular(100.0)),
              //   ),
              //   inputTheme: InputDecorationTheme(
              //     filled: true,
              //     fillColor: Colors.purple.withOpacity(.1),
              //     contentPadding: EdgeInsets.zero,
              //     errorStyle: TextStyle(
              //       backgroundColor: Colors.orangeAccent,
              //       color: Colors.white,
              //     ),
              //     labelStyle: TextStyle(fontSize: 12),
              //     enabledBorder: UnderlineInputBorder(
              //       borderSide: BorderSide(color: Colors.blue.shade700, width: 4),
              //       borderRadius: inputBorder,
              //     ),
              //     focusedBorder: UnderlineInputBorder(
              //       borderSide: BorderSide(color: Colors.blue.shade400, width: 5),
              //       borderRadius: inputBorder,
              //     ),
              //     errorBorder: UnderlineInputBorder(
              //       borderSide: BorderSide(color: Colors.red.shade700, width: 7),
              //       borderRadius: inputBorder,
              //     ),
              //     focusedErrorBorder: UnderlineInputBorder(
              //       borderSide: BorderSide(color: Colors.red.shade400, width: 8),
              //       borderRadius: inputBorder,
              //     ),
              //     disabledBorder: UnderlineInputBorder(
              //       borderSide: BorderSide(color: Colors.grey, width: 5),
              //       borderRadius: inputBorder,
              //     ),
              //   ),
              //   buttonTheme: LoginButtonTheme(
              //     splashColor: Colors.purple,
              //     backgroundColor: Colors.pinkAccent,
              //     highlightColor: Colors.lightGreen,
              //     elevation: 9.0,
              //     highlightElevation: 6.0,
              //     shape: BeveledRectangleBorder(
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //     // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              //     // shape: CircleBorder(side: BorderSide(color: Colors.green)),
              //     // shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(55.0)),
              //   ),
              // ),
              emailValidator: (value) {
                if (!EmailValidator.validate(value)) {
                  return "Seu email não é válido";
                }
                return null;
              },
              passwordValidator: (value) {
                if (value.isEmpty) {
                  return 'Senha vazia';
                }
                return null;
              },
              onLogin: (loginData) {
                print('Login info');
                print('Name: ${loginData.name}');
                print('Password: ${loginData.password}');
                return _loginUser(loginData);
              },
              onSignup: (loginData) {
                print('Signup info');
                print('Name: ${loginData.name}');
                print('Password: ${loginData.password}');
                return _singUpUser(loginData);
              },
              onSubmitAnimationCompleted: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DashboardScreen()));
                /*
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => DashboardScreen(),
        ));
        */
              },
              onRecoverPassword: (name) {
                print('Recover password info');
                print('Name: $name');
                return _recoverPassword(name);
                // Show new password dialog
              },
              showDebugButtons: false,
            )));
  }
}
