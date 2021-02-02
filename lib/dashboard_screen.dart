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

class DashboardScreen extends StatefulWidget {
  static const routeName = '/dashboard';

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin, TransitionRouteAware {
  Future<bool> _goToLogin(BuildContext context) {
    return Navigator.of(context)
        .pushReplacement(MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ))
        .then((_) => false);

    /*
    Navigator.of(context).pop();
    return Future.delayed(Duration(milliseconds: 1)).then((_) {
      return false;
    });
    return Navigator.of(context)
        .pushReplacement(MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ))
        .then((_) => false);


        return Navigator.of(context)
        .pushReplacementNamed('/')
        // we dont want to pop the screen, just replace it completely
        .then((_) => false);
     */
  }

  final routeObserver = TransitionRouteObserver<PageRoute>();
  static const headerAniInterval =
      const Interval(.1, .3, curve: Curves.easeOut);
  Animation<double> _headerScaleAnimation;
  AnimationController _loadingController;

  @override
  void initState() {
    super.initState();

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

  AppBar _buildAppBar(ThemeData theme) {
    final signOutBtn = IconButton(
      icon: const Icon(
        FontAwesomeIcons.signOutAlt,
        color: Colors.white,
      ),
      color: theme.accentColor,
      onPressed: () => _goToLogin(context),
    );

    return AppBar(
      centerTitle: true,
      // this is all you need
      automaticallyImplyLeading: false,
      brightness: Brightness.light,
      // status bar brightness
      actions: <Widget>[
        FadeIn(
          child: signOutBtn,
          controller: _loadingController,
          offset: .3,
          curve: headerAniInterval,
          fadeDirection: FadeDirection.endToStart,
        ),
      ],
      title: Text(''),
      backgroundColor: theme.primaryColor,
      elevation: 0,
      textTheme: theme.accentTextTheme,
      iconTheme: theme.accentIconTheme,
    );
  }

  Widget _buildHeader(ThemeData theme) {
    /*
    final primaryColor = Colors.primaries.where((c) => c == theme.primaryColor).first;
    final accentColor = Colors.primaries.where((c) => c == theme.accentColor).first;
    final linearGradient = LinearGradient(colors: [primaryColor.shade800, primaryColor.shade200,
    ]).createShader(Rect.fromLTWH(0.0, 0.0, 418.0, 78.0));
    */

    return ScaleTransition(
      scale: _headerScaleAnimation,
      child: FadeIn(
        controller: _loadingController,
        curve: headerAniInterval,
        fadeDirection: FadeDirection.bottomToTop,
        offset: .5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/babyandmebranco.png',
              filterQuality: FilterQuality.high,
              height: 100,
            )
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

    return GridView.count(
      physics: new NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        horizontal: 32.0,
        vertical: 20,
      ),
      childAspectRatio: .9,
      // crossAxisSpacing: 5,
      crossAxisCount: 3,
      children: [
        _buildButton(
          icon: Icon(FontAwesomeIcons.image),
          label: 'Imagenes',
          interval: Interval(step * 2, aniInterval + step * 2),
          onPressed: () => {_goToImageGallery(context, 1)},
        ),
        _buildButton(
          icon: Icon(FontAwesomeIcons.video),
          label: 'Video',
          interval: Interval(step * 2, aniInterval + step * 2),
          onPressed: () => {_goToImageGallery(context, 2)},
        ),
        _buildButton(
          icon: Icon(const IconData(0xe901, fontFamily: 'Hologram')),
          label: 'Holo',
          interval: Interval(0, aniInterval),
          onPressed: () => {_goToImageGallery(context, 3)},
        ),
        _buildButton(
          icon: Icon(FontAwesomeIcons.heartbeat),
          label: 'Latido',
          interval: Interval(step, aniInterval + step),
          onPressed: () =>
              {Navigator.pushNamed(context, HeartbeatPage.routeName)},
        ),
        _buildButton(
          icon: Icon(const IconData(0xe900, fontFamily: 'Streaming')),
          label: 'Streaming',
          interval: Interval(step * 2, aniInterval + step * 2),
          onPressed: () =>
              {Navigator.pushNamed(context, StreamingCodePage.routeName)},
        ),
        _buildButton(
          icon: Icon(FontAwesomeIcons.calculator),
          label: 'Calculadora',
          interval: Interval(0, aniInterval),
          onPressed: () => {_goToCalculator(context)},
        ),
        _buildButton(
          icon: Icon(FontAwesomeIcons.gift),
          label: 'Promo',
          interval: Interval(step, aniInterval + step),
          onPressed: () => {Navigator.pushNamed(context, PromosPage.routeName)},
        ),
        _buildButton(
          icon: Icon(FontAwesomeIcons.calendarAlt),
          label: 'Citas ',
          interval: Interval(step * 2, aniInterval + step * 2),
          onPressed: () =>
              {Navigator.pushNamed(context, AppointmentPage.routeName)},
        ),
        _buildButton(
          icon: Icon(FontAwesomeIcons.info),
          label: 'Info ',
          interval: Interval(step * 2, aniInterval + step * 2),
          onPressed: () =>
          {Navigator.pushNamed(context, InfoPage.routeName)},
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarColor: Colors.orangeAccent, // this one for android
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark // this one for iOS
      ),
    );
    return WillPopScope(
      onWillPop: () async {
        // ToastUtil.makeToast("Usuario no encontrado");
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: _buildAppBar(theme),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          //color: theme.primaryColor.withOpacity(.1),
          color: Colors.orangeAccent,
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  SizedBox(height: 40),
                  Expanded(
                    flex: 2,
                    child: _buildHeader(theme),
                  ),
                  Expanded(
                    flex: 8,
                    child: _buildDashboardGrid(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
