import 'package:babyandme/login_screen.dart';
import 'package:babyandme/pages/gallery/gallery.dart';
import 'package:babyandme/pages/heartbeat_page.dart';
import 'package:babyandme/pages/images_gallery/image_gallery.dart';
import 'package:babyandme/pages/streaming/streaming_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
      color: theme.accentColor,
      onPressed: () => _goToLogin(context),
    );

    return AppBar(
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
      title: Text(''),
      backgroundColor: theme.primaryColor.withOpacity(.1),
      elevation: 0,
      textTheme: theme.accentTextTheme,
      iconTheme: theme.accentIconTheme,
    );
  }

  Widget _buildHeader(ThemeData theme) {
    final primaryColor =
        Colors.primaries.where((c) => c == theme.primaryColor).first;
    final accentColor =
        Colors.primaries.where((c) => c == theme.accentColor).first;
    final linearGradient = LinearGradient(colors: [
      primaryColor.shade800,
      primaryColor.shade200,
    ]).createShader(Rect.fromLTWH(0.0, 0.0, 418.0, 78.0));

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
      padding: const EdgeInsets.symmetric(
        horizontal: 32.0,
        vertical: 20,
      ),
      childAspectRatio: .9,
      // crossAxisSpacing: 5,
      crossAxisCount: 3,
      children: [
        GestureDetector(
          onTap: () {
            _goToGallery(context, 1);
          },
          child: ClipRRect(
            borderRadius: new BorderRadius.circular(10.0),
            child: Column(
              children: [
                Hero(
                  tag: 'imagesTab',
                  child: Icon(
                    FontAwesomeIcons.moneyBillAlt,
                    size: 20,
                  ),
                ),
                Text('Images')
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            _goToGallery(context, 2);
          },
          child: ClipRRect(
            borderRadius: new BorderRadius.circular(10.0),
            child: Column(
              children: [
                Hero(
                  tag: 'videosTab',
                  child: Icon(
                    FontAwesomeIcons.moneyBillAlt,
                    size: 20,
                  ),
                ),
                Text('Video')
              ],
            ),
          ),
        ),
        FlatButton(
            onPressed: () => {_goToGallery(context, 2)}, child: Text('Video')),
        FlatButton(
            onPressed: () => {_goToHeartbeat(context)}, child: Text('Latido')),
        FlatButton(
            onPressed: () => {_goToStreaming(context)},
            child: Text('Streaming')),
        _buildButton(
          icon: Container(
            // fix icon is not centered like others for some reasons
            padding: const EdgeInsets.only(left: 16.0),
            alignment: Alignment.centerLeft,
            child: Icon(
              FontAwesomeIcons.moneyBillAlt,
              size: 20,
            ),
          ),
          label: 'Fund Transfer',
          interval: Interval(step, aniInterval + step),
        ),
        _buildButton(
          icon: Icon(FontAwesomeIcons.handHoldingUsd),
          label: 'Payment',
          interval: Interval(step * 2, aniInterval + step * 2),
        ),
        _buildButton(
          icon: Icon(FontAwesomeIcons.chartLine),
          label: 'Report',
          interval: Interval(0, aniInterval),
        ),
        _buildButton(
          icon: Icon(Icons.vpn_key),
          label: 'Register',
          interval: Interval(step, aniInterval + step),
        ),
        _buildButton(
          icon: Icon(FontAwesomeIcons.history),
          label: 'History',
          interval: Interval(step * 2, aniInterval + step * 2),
        ),
        _buildButton(
          icon: Icon(FontAwesomeIcons.ellipsisH),
          label: 'Other',
          interval: Interval(0, aniInterval),
        ),
        _buildButton(
          icon: Icon(FontAwesomeIcons.search, size: 20),
          label: 'Search',
          interval: Interval(step, aniInterval + step),
        ),
        _buildButton(
          icon: Icon(FontAwesomeIcons.slidersH, size: 20),
          label: 'Settings',
          interval: Interval(step * 2, aniInterval + step * 2),
        ),
      ],
    );
  }

  Widget _buildDebugButtons() {
    const textStyle = TextStyle(fontSize: 12, color: Colors.white);

    return Positioned(
      bottom: 0,
      right: 0,
      child: Row(
        children: <Widget>[
          RaisedButton(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            color: Colors.red,
            child: Text('loading', style: textStyle),
            onPressed: () => _loadingController.value == 0
                ? _loadingController.forward()
                : _loadingController.reverse(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () => _goToLogin(context),
      child: Scaffold(
        appBar: _buildAppBar(theme),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: theme.primaryColor.withOpacity(.1),
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
                    child: ShaderMask(
                      // blendMode: BlendMode.srcOver,
                      shaderCallback: (Rect bounds) {
                        return LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          tileMode: TileMode.clamp,
                          colors: <Color>[
                            Colors.deepPurpleAccent.shade100,
                            Colors.deepPurple.shade100,
                            Colors.deepPurple.shade100,
                            Colors.deepPurple.shade100,
                            // Colors.red,
                            // Colors.yellow,
                          ],
                        ).createShader(bounds);
                      },
                      child: _buildDashboardGrid(),
                    ),
                  ),
                ],
              ),
              if (!kReleaseMode) _buildDebugButtons(),
            ],
          ),
        ),
      ),
    );
  }
}

_goToGallery(BuildContext context, int type) {
  Navigator.pushNamed(
    context,
    Gallery.routeName,
    arguments: type
  );
}

_goToImageGallery(BuildContext context) {
  Navigator.of(context).pushReplacement(MaterialPageRoute(
    builder: (context) => ImageGalleryPage(),
  ));
}

_goToHeartbeat(BuildContext context) {
  Navigator.of(context).pushReplacement(MaterialPageRoute(
    builder: (context) => HeartbeatPage(),
  ));
}

_goToStreaming(BuildContext context) {
  Navigator.of(context).pushReplacement(MaterialPageRoute(
    builder: (context) => StreamingCodePage(),
  ));
}
