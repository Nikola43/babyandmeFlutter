import 'package:babyandme/utils/shared_preferences.dart';
import 'package:babyandme/utils/toast_util.dart';
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
      icon: const Icon(FontAwesomeIcons.signOutAlt),
      color: Colors.white,
      onPressed: () => {
        ToastUtil.makeToast("Ha cerrado sesión"),
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
        child: Image.asset(
          'assets/images/babyandmebranco.png',
          filterQuality: FilterQuality.high,
          height: 150,
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
          label: 'CITAS',
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
          label: 'VIDEOS',
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
