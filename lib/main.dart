import 'package:babyandme/on_boarding_page.dart';
import 'package:babyandme/pages/appointment/appointment.dart';
import 'package:babyandme/pages/calculator/calculator_detail.dart';
import 'package:babyandme/pages/calculator/calculator_page.dart';
import 'package:babyandme/pages/gallery/gallery.dart';
import 'package:babyandme/pages/heartbeat_page.dart';
import 'package:babyandme/pages/images_gallery/image_gallery.dart';
import 'package:babyandme/pages/info/info.dart';
import 'package:babyandme/pages/promos/promo_detail.dart';
import 'package:babyandme/pages/streaming/streaming_page.dart';
import 'package:babyandme/pages/streaming/streaming_video_page.dart';
import 'package:babyandme/transition_route_observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'dashboard_screen.dart';
import 'login_screen.dart';
import 'pages/images_gallery/full_screen_image_screen.dart';
import 'pages/promos/promos_page.dart';
import 'pages/videos_gallery/video_player.dart';
import 'l10n/messages_all.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:universal_io/io.dart';

class MainLocalizations {
  MainLocalizations(this.localeName);

  static Future<MainLocalizations> load(Locale locale) {
    final String name =
        locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((_) {
      return MainLocalizations(localeName);
    });
  }

  static MainLocalizations of(BuildContext context) {
    return Localizations.of<MainLocalizations>(context, MainLocalizations);
  }

  final String localeName;

  String get title {
    return Intl.message(
      'Hello World',
      name: 'title',
      desc: 'Title for the Demo application',
      locale: localeName,
    );
  }

  String get onboarding_title_1 {
    return Intl.message(
      'Semanas de embarazo',
      name: 'onboarding_title_1',
      desc: 'Title for the Demo application',
      locale: localeName,
    );
  }
}

class MainLocalizationsDelegate
    extends LocalizationsDelegate<MainLocalizations> {
  const MainLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'es', 'pt'].contains(locale.languageCode);

  @override
  Future<MainLocalizations> load(Locale locale) =>
      MainLocalizations.load(locale);

  @override
  bool shouldReload(MainLocalizationsDelegate old) => false;
}

void main() {
  /*
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
        statusBarColor: Colors.orangeAccent, // this one for android
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark // this one for iOS
        ),
  );
  */



  SystemChrome.setEnabledSystemUIOverlays([]);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    //Remove this method to stop OneSignal Debugging
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

    OneSignal.shared.init("0f19ed5b-2b9b-4492-a8ef-298845ce7d21", iOSSettings: {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.inAppLaunchUrl: false
    });
    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);

// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt.
//We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.shared
        .promptUserForPushNotificationPermission(fallbackToSettings: true)
        .then((value) => {
          print(value),
        print(value)
        });

    return MaterialApp(
      onGenerateTitle: (BuildContext context) =>
          MainLocalizations.of(context).title,
      localizationsDelegates: [
        const MainLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''),
        const Locale('es', ''),
        const Locale('pt', ''),
      ],
      locale: Locale('pt'),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // brightness: Brightness.dark,
        primaryColor: Colors.orangeAccent,
        secondaryHeaderColor: Colors.grey,
        primarySwatch: Colors.grey,
        accentColor: Colors.grey,
        cursorColor: Colors.grey,
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
      home: _buildFirstScreen(),
      navigatorObservers: [TransitionRouteObserver()],
      routes: {
        LoginScreen.routeName: (context) => LoginScreen(),
        DashboardScreen.routeName: (context) => DashboardScreen(),
        ImageGalleryPage.routeName: (context) => ImageGalleryPage(),
        Gallery.routeName: (context) => Gallery(),
        FullScreenImage.routeName: (context) => FullScreenImage(),
        CalculatorPage.routeName: (context) => CalculatorPage(),
        CalculatorDetailPage.routeName: (context) => CalculatorDetailPage(),
        StreamingCodePage.routeName: (context) => StreamingCodePage(),
        StreamingYoutubeVideo.routeName: (context) => StreamingYoutubeVideo(),
        HeartbeatPage.routeName: (context) => HeartbeatPage(),
        VideoAppPage.routeName: (context) => VideoAppPage(),
        PromosPage.routeName: (context) => PromosPage(),
        PromoDetail.routeName: (context) => PromoDetail(),
        AppointmentPage.routeName: (context) => AppointmentPage(),
        InfoPage.routeName: (context) => InfoPage(),
      },
    );
  }
}

class VideoPlayerPage {}

Widget _buildFirstScreen() {
  return DashboardScreen();

  //return OnBoardingPage();

  // return LoginScreen();
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
