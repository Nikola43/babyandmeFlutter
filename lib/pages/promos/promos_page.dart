import 'package:babyandme/models/promo.dart';
import 'package:babyandme/pages/promos/promo_detail.dart';
import 'package:babyandme/services/promo_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PromosPage extends StatefulWidget {
  static const routeName = '/promos';

  PromosPage({Key key}) : super(key: key);

  _PromosPageState createState() => _PromosPageState();
}

class _PromosPageState extends State<PromosPage> {
  Size _screenSize;
  PromoService promoService = new PromoService();

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;

    var futureBuilder = new FutureBuilder(
      future: promoService.getPromosByWeek(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return new Center(
              child: CircularProgressIndicator(
                  valueColor:
                      new AlwaysStoppedAnimation<Color>(Colors.orange)),
            );
          default:
            if (snapshot.hasError) {
              return new Text('Error: ${snapshot.error}');
            } else {
              return createListView(context, snapshot);
            }
        }
      },
    );

    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
          centerTitle: true,
          title: Text(
            "Promos",
            style: TextStyle(color: Colors.white),
          ),
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => {Navigator.pop(context)})),
      body: futureBuilder,
    );
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<Promo> values = snapshot.data;
    if (values.length > 0) {
      return new ListView.builder(
        itemCount: values.length,
        itemBuilder: (BuildContext context, int index) {
          return new Column(
            children: <Widget>[
              GestureDetector(
                onTap: () => {
                  Navigator.of(context).pushNamed(PromoDetail.routeName,
                      arguments: values[index])
                },
                child: new ListTile(
                  leading: Icon(
                    FontAwesomeIcons.gift,
                    color: Colors.orange,
                  ),
                  title: new Text(
                    values[index].title,
                    style: TextStyle(color: Colors.orange),
                  ),
                  subtitle: new Text(
                    values[index].text,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              new Divider(
                height: 2.0,
              ),
            ],
          );
        },
      );
    } else {
      return Center(
        child: Text("No hay promos disponible"),
      );
    }
  }
}
