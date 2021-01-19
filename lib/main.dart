import 'package:babyandme/pages/gallery/gallery.dart';
import 'package:babyandme/pages/images_gallery/image_gallery.dart';
import 'package:babyandme/pages/streaming/streaming_page.dart';
import 'package:babyandme/pages/streaming/streaming_video_page.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'dashboard_screen.dart';
import 'login_screen.dart';
import 'pages/images_gallery/full_screen_image_screen.dart';
import 'transition_route_observer.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
        statusBarColor: Colors.white, // this one for android
        statusBarBrightness: Brightness.dark // this one for iOS
        ),
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      title: 'Login Demo',
      theme: ThemeData(
        // brightness: Brightness.dark,
        primarySwatch: Colors.lightBlue,
        accentColor: Colors.orange,
        cursorColor: Colors.orange,
        // fontFamily: 'SourceSansPro',
        textTheme: TextTheme(
          display2: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 45.0,
            // fontWeight: FontWeight.w400,
            color: MaterialColor(0xFF46668C, colorCodes),
          ),
          button: TextStyle(
            // OpenSans is similar to NotoSans but the uppercases look a bit better IMO
            fontFamily: 'OpenSans',
          ),
          caption: TextStyle(
            fontFamily: 'NotoSans',
            fontSize: 12.0,
            fontWeight: FontWeight.normal,
            color: Colors.deepPurple[300],
          ),
          display4: TextStyle(fontFamily: 'Quicksand'),
          display3: TextStyle(fontFamily: 'Quicksand'),
          display1: TextStyle(fontFamily: 'Quicksand'),
          headline: TextStyle(fontFamily: 'NotoSans'),
          title: TextStyle(fontFamily: 'NotoSans'),
          subhead: TextStyle(fontFamily: 'NotoSans'),
          body2: TextStyle(fontFamily: 'NotoSans'),
          body1: TextStyle(fontFamily: 'NotoSans'),
          subtitle: TextStyle(fontFamily: 'NotoSans'),
          overline: TextStyle(fontFamily: 'NotoSans'),
        ),
      ),
      home: new SplashScreen(
        seconds: 1,
        navigateAfterSeconds: DashboardScreen(),
        image: Image.asset(
          'assets/images/babyandmebranco.png',
          filterQuality: FilterQuality.high,
          height: 50,
          width: 50,
        ),
        backgroundColor: Colors.lightBlue,
        loaderColor: Colors.red,
      ),
      navigatorObservers: [TransitionRouteObserver()],
      routes: {
        LoginScreen.routeName: (context) => LoginScreen(),
        DashboardScreen.routeName: (context) => DashboardScreen(),
        ImageGalleryPage.routeName: (context) => ImageGalleryPage(),
        Gallery.routeName: (context) => Gallery(),
        FullScreenImage.routeName: (context) => FullScreenImage(),
        StreamingCodePage.routeName: (context) => StreamingCodePage(),
        StreamingYoutubeVideo.routeName: (context) => StreamingYoutubeVideo(),
      },
    );
  }
}

Map<int, Color> colorCodes = {
  50: Color.fromRGBO(70, 102, 140, 1),
  100: Color.fromRGBO(70, 102, 140, 1),
  200: Color.fromRGBO(70, 102, 140, 1),
  300: Color.fromRGBO(70, 102, 140, 1),
  400: Color.fromRGBO(70, 102, 140, 1),
  500: Color.fromRGBO(70, 102, 140, 1),
  600: Color.fromRGBO(70, 102, 140, 1),
  700: Color.fromRGBO(70, 102, 140, 1),
  800: Color.fromRGBO(70, 102, 140, 1),
  900: Color.fromRGBO(70, 102, 140, 1),
};
