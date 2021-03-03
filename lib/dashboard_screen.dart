import 'package:babyandme/services/calculator_service.dart';
import 'package:babyandme/utils/shared_preferences.dart';
import 'package:babyandme/utils/toast_util.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:universal_io/io.dart';
import 'package:babyandme/login_screen.dart';
import 'package:babyandme/pages/appointment/appointment.dart';
import 'package:babyandme/pages/calculator/calculator_page.dart';
import 'package:babyandme/pages/heartbeat_page.dart';
import 'package:babyandme/pages/images_gallery/image_gallery.dart';
import 'package:babyandme/pages/info/info.dart';
import 'package:babyandme/pages/promos/promos_page.dart';
import 'package:babyandme/pages/streaming/streaming_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'transition_route_observer.dart';
import 'widgets/fade_in.dart';
import 'widgets/round_button.dart';
import 'package:universal_io/io.dart';
import 'package:flutter/services.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = '/dashboard';

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin, TransitionRouteAware {
  Size screenSize;

  CalculatorService calculatorService = new CalculatorService();
  DateTime selectedDate = DateTime.now();
  String _parsedDate = formatDate(DateTime.now(), [dd, ' / ', mm, ' / ', yyyy]);

  final routeObserver = TransitionRouteObserver<PageRoute>();
  static const headerAniInterval =
      const Interval(.1, .3, curve: Curves.easeOut);
  Animation<double> _headerScaleAnimation;
  AnimationController _loadingController;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      // check if user has logged
      SharedPreferencesUtil.getInt('user_id').then((value) => {
            if (value > 0)
              {
                SharedPreferencesUtil.getInt('first_login').then((value) => {
                      if (value != 1)
                        {
                          print('value'),
                          print(value),
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Center(child: Text('Data de nascimento')),
                              content: Container(
                                margin: EdgeInsets.all(10),
                                width: 150,
                                height: 50.0,
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4.0),
                                      side: BorderSide(
                                          color: Colors.orangeAccent)),
                                  onPressed: () {
                                    DatePicker.showDatePicker(context,
                                        currentTime: selectedDate,
                                        theme: DatePickerTheme(
                                          containerHeight: 210.0,
                                        ),
                                        showTitleActions: true,
                                        minTime: DateTime.now(),
                                        maxTime: calculateMaxDate(),
                                        onConfirm: (date) async {
                                      print('confirm $date');
                                      selectedDate = date;
                                      _parsedDate =
                                          '${date.day} / ${date.month} / ${date.year}';
                                      // calculateWeekBySetDate(date);

                                      var diff =
                                          getDifferenceBetweenDatesInWeeks(
                                              date, new DateTime.now());
                                      print("diff");
                                      print(diff);

                                      var week = calculatePregnancyWeeks(date);
                                      print("week");
                                      print(week);

                                      await SharedPreferencesUtil.saveString(
                                          'calculated_date',
                                          selectedDate.toString());

                                      SharedPreferencesUtil.saveInt("currentWeek", week);

                                      calculatorService
                                          .calculatorByWeekSave(week)
                                          .then((val) {
                                        setState(() {});
                                        Navigator.pop(context);

                                        SharedPreferencesUtil.saveInt(
                                                'first_login', 1)
                                            .then((value) => {
                                                  showDialog(
                                                    context: context,
                                                    builder: (_) => AlertDialog(
                                                      title: Center(
                                                          child: Text(
                                                              'Data de nascimento')),
                                                      content: Text(
                                                          "Data de nascimento salva corretamente",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .green)),
                                                      actions: [
                                                        FlatButton(
                                                            child: Text("OK"),
                                                            textColor:
                                                                Colors.blue,
                                                            onPressed:
                                                                () async {
                                                              Navigator.pop(
                                                                  context);
                                                            }),
                                                      ],
                                                    ),
                                                  )
                                                });
                                      });
                                    }, locale: LocaleType.es);
                                  },
                                  padding: EdgeInsets.all(10.0),
                                  color: Colors.orangeAccent,
                                  textColor: Colors.white,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Icon(FontAwesomeIcons.calendarAlt),
                                      Text(_parsedDate,
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                              actions: [],
                            ),
                          )
                        }
                    }),
              }
          });
    });

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

    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1250),
    );

    _headerScaleAnimation =
        Tween<double>(begin: .6, end: 1).animate(CurvedAnimation(
      parent: _loadingController,
      curve: headerAniInterval,
    ));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _loadingController.dispose();
    super.dispose();
  }

  @override
  void didPushAfterTransition() => _loadingController.forward();

  int calculatePregnancyWeeks(DateTime estimatedBirthDate) {
    DateTime now = new DateTime.now();

    var diff = getDifferenceBetweenDatesInWeeks(estimatedBirthDate, now);
    print("diff inside");
    print(diff);

    var lastMenstruationDate = now.add(new Duration(days: -280 + (diff * 7)));

    return this.getDifferenceBetweenDatesInWeeks(lastMenstruationDate, now);
  }

  int getDifferenceBetweenDatesInWeeks(DateTime startDate, DateTime endDate) {
    var difference = startDate.difference(endDate).inDays / 7;
    difference = difference.abs();
    print("difference");
    print(difference);
    if (difference <= 1) {
      difference = 1;
    }
    return difference.toInt();
  }

  DateTime calculateMaxDate() {
    var now = new DateTime.now();
    var minDate = now.add(new Duration(days: 280));
    return minDate;
  }

  int calculateWeekBySetDate(DateTime selectedDate) {
    var difference = new DateTime.now().difference(selectedDate).inDays / 7;
    print(difference);
    if (difference <= 1) {
      difference = 1;
    }

    return difference.toInt();
  }

  AppBar _buildAppBar(ThemeData theme) {
    final signOutBtn = IconButton(
      icon: const Icon(FontAwesomeIcons.signOutAlt),
      color: Colors.white,
      onPressed: () => {
        ToastUtil.makeToast("Sessão encerrada"),
        SharedPreferencesUtil.saveString("token", ""),
        Navigator.pushNamed(context, LoginScreen.routeName),
        //_goToLogin(context)
      },
    );

    return AppBar(
      centerTitle: true,
      // this is all you need
      automaticallyImplyLeading: false,
      actions: <Widget>[
        FadeIn(
          child: signOutBtn,
          controller: _loadingController,
          offset: .3,
          curve: headerAniInterval,
          fadeDirection: FadeDirection.endToStart,
        ),
      ],
      title: Text(" "),
      backgroundColor: Colors.transparent,
      elevation: 0,
      textTheme: theme.accentTextTheme,
      iconTheme: theme.accentIconTheme,
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return ScaleTransition(
      scale: _headerScaleAnimation,
      child: FadeIn(
        controller: _loadingController,
        curve: headerAniInterval,
        fadeDirection: FadeDirection.bottomToTop,
        offset: 0.5,
        child: Column(
          children: [
            Image.asset(
              'assets/images/babyandmebranco.png',
              filterQuality: FilterQuality.high,
              height: 150,
            ),
            SizedBox(height: screenSize.height / 64),
            Text(
              "(by ecox Lisboa)",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: screenSize.width / 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(
      {Widget icon, String label, Interval interval, VoidCallback onPressed}) {
    return RoundButton(
      icon: icon,
      label: label,
      loadingController: _loadingController,
      interval: Interval(
        interval.begin,
        interval.end,
        curve: ElasticOutCurve(0.42),
      ),
      onPressed: onPressed,
    );
  }

  Widget _buildDashboardGrid() {
    const step = 0.04;
    const aniInterval = 0.75;
    SystemChrome.setEnabledSystemUIOverlays([]);
    return GridView.count(
      physics: new NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 5,
      ),
      childAspectRatio: .9,
      // crossAxisSpacing: 5,
      crossAxisCount: 3,
      children: [
        _buildButton(
          icon: Icon(FontAwesomeIcons.calendarAlt),
          label: 'MARCAÇÕES',
          interval: Interval(step * 2, aniInterval + step * 2),
          onPressed: () =>
              {Navigator.pushNamed(context, AppointmentPage.routeName)},
        ),
        _buildButton(
          icon: Icon(FontAwesomeIcons.calculator),
          label: 'CALCULADORA',
          interval: Interval(0, aniInterval),
          onPressed: () => {_goToCalculator(context)},
        ),
        _buildButton(
          icon: Icon(FontAwesomeIcons.heartbeat),
          label: 'BATIMENTO',
          interval: Interval(step, aniInterval + step),
          onPressed: () =>
              {Navigator.pushNamed(context, HeartbeatPage.routeName)},
        ),
        _buildButton(
          icon: Icon(FontAwesomeIcons.image),
          label: 'IMAGENS',
          interval: Interval(step * 2, aniInterval + step * 2),
          onPressed: () => {_goToImageGallery(context, 1)},
        ),
        _buildButton(
          icon: Icon(FontAwesomeIcons.video),
          label: 'VÍDEOS',
          interval: Interval(step * 2, aniInterval + step * 2),
          onPressed: () => {_goToImageGallery(context, 2)},
        ),
        _buildButton(
          icon: Icon(const IconData(0xe901, fontFamily: 'Hologram')),
          label: 'HOLOGRAFIAS',
          interval: Interval(0, aniInterval),
          onPressed: () => {_goToImageGallery(context, 3)},
        ),
        _buildButton(
          icon: Icon(const IconData(0xe900, fontFamily: 'Streaming')),
          label: 'STREAMING',
          interval: Interval(step * 2, aniInterval + step * 2),
          onPressed: () =>
              {Navigator.pushNamed(context, StreamingCodePage.routeName)},
        ),
        _buildButton(
          icon: Icon(FontAwesomeIcons.gift),
          label: 'PROMOÇÕES',
          interval: Interval(step, aniInterval + step),
          onPressed: () => {Navigator.pushNamed(context, PromosPage.routeName)},
        ),
        _buildButton(
          icon: Icon(FontAwesomeIcons.info),
          label: 'CONTACTO',
          interval: Interval(step * 2, aniInterval + step * 2),
          onPressed: () => {Navigator.pushNamed(context, InfoPage.routeName)},
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    if (Platform.operatingSystem == "android") {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light));
      SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    } else {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.dark // this one for iOS
            ),
      );
      SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    }

    return WillPopScope(
        onWillPop: () async {
          // ToastUtil.makeToast("Usuario no encontrado");
          return false;
        },
        child: Stack(children: [
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
            extendBodyBehindAppBar: true,
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            appBar: _buildAppBar(theme),
            body: Column(
              children: <Widget>[
                SizedBox(height: screenSize.height / 16),
                _buildHeader(theme),
                SizedBox(height: screenSize.height / 16),
                Expanded(
                  flex: 8,
                  child: _buildDashboardGrid(),
                ),
              ],
            ),
          ),
        ]));
  }
}

_goToGallery(BuildContext context, int type) {
  Navigator.pushNamed(context, ImageGalleryPage.routeName, arguments: type);
}

_goToImageGallery(BuildContext context, int type) {
  Navigator.pushNamed(context, ImageGalleryPage.routeName, arguments: type);
}

_goToStreaming(BuildContext context) {
  Navigator.pushNamed(context, StreamingCodePage.routeName);
}

_goToCalculator(BuildContext context) {
  Navigator.pushNamed(context, CalculatorPage.routeName);
}

/*
_goToHeartbeat(BuildContext context) {
  Navigator.of(context).pushReplacement(MaterialPageRoute(
    builder: (context) => HeartbeatPage(),
  ));
}
*/
