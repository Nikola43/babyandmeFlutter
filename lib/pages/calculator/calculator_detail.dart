import 'package:babyandme/models/calculator.dart';
import 'package:babyandme/utils/json_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'package:styled_text/styled_text.dart';

class CalculatorDetailPage extends StatefulWidget {
  static const routeName = '/calculator_detail';

  CalculatorDetailPage({Key key}) : super(key: key);

  _CalculatorDetailPageState createState() => _CalculatorDetailPageState();
}

class _CalculatorDetailPageState extends State<CalculatorDetailPage> {
  Size _screenSize;
  List<String> ps = [];

  int calculateDaysBySetDate(DateTime selectedDate) {
    var difference = new DateTime.now().difference(selectedDate).inDays % 7;
    print(difference);
    if (difference <= 1) {
      difference = 1;
    }
    return difference.toInt();
  }

  int calculateWeekBySetDate(DateTime selectedDate) {
    var difference = new DateTime.now().difference(selectedDate).inDays / 7;
    print(difference);
    if (difference <= 1) {
      difference = 1;
    }
    return difference.toInt();
  }

  void read() async {
    print("read");
    var promoText = await JsonUtil.readJson("assets/weeks/1.json");
    /*
    for (int i = 0; i < plength; i++) {
      ps.add(promoText["p" + i.toString()]);
    }
    */
  }

  @override
  void initState() {
    read();
    super.initState();
  }

  Widget buildCalculatorText(String file) {
    List<Widget> calculatorTexts = [];
    Widget widget = new FutureBuilder<List<String>>(
      future: JsonUtil.readJson(file),
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return new Center(
              child: CircularProgressIndicator(
                  valueColor:
                      new AlwaysStoppedAnimation<Color>(Colors.orangeAccent)),
            );
          default:
            if (snapshot.hasError) {
              return new Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData && snapshot.data.length > 0) {
              for (int i = 0; i < snapshot.data.length; i++) {
                calculatorTexts.add(StyledText(
                  text: snapshot.data[i],
                  styles: {
                    'bold': TextStyle(fontWeight: FontWeight.bold),
                  },
                ));

                /*
                if (snapshot.data[i].contains("<bold>")) {
                  snapshot.data[i] = snapshot.data[i].replaceAll("<bold>", "");
                  calculatorTexts.add(Text(
                    snapshot.data[i],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ));
                } else {
                  calculatorTexts.add(Text(snapshot.data[i]));
                }
              */
              }
              return Column(children: calculatorTexts);
            } else if (!snapshot.hasData) {
              return Center(
                child: Text(
                  "Erro",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
                ),
              );
            } else {
              return Center(
                child: Text(
                  "Erro",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
                ),
              );
            }
        }
      },
    );
    return widget;
  }

  @override
  Widget build(BuildContext context) {
    final Calculator calc = ModalRoute.of(context).settings.arguments;
    _screenSize = MediaQuery.of(context).size;
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Está de " +
                calculateWeekBySetDate(calc.selectedDateTime).toString() +
                ' semanas' +
                " e " +
                calculateDaysBySetDate(calc.selectedDateTime).toString() +
                ' dia' +
                (calculateDaysBySetDate(calc.selectedDateTime) > 1 ? "s" : ""),
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          leading: new IconButton(
            icon: new Icon(
              FontAwesomeIcons.arrowLeft,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
            child: Container(
                width: _screenSize.width,
                height: _screenSize.height,
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Column(children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 25),
                      child: Text(
                        'Semana ' + calc.id.toString(),
                        style: TextStyle(fontSize: 25, color: Colors.black),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(25),
                      child: ClipRRect(
                          borderRadius: new BorderRadius.circular(10.0),
                          child: FadeInImage(
                            fit: BoxFit.fitHeight,
                            placeholder: AssetImage(
                                "assets/images/9619-loading-dots-in-yellow.gif"),
                            image: NetworkImage(calc.imageUrl),
                          )),
                      /*

                              child: ExtendedImage.network(
                                calc.imageUrl,
                                fit: BoxFit.fill,
                                cache: true,
                              )),
                           */
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 25, right: 25),
                      child: buildCalculatorText("assets/weeks/1.json"),
                    ),
                    SizedBox(height: _screenSize.height / 32),
                  ]),
                ))));
  }
}
