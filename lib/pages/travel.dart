import "package:flutter/material.dart";
import "package:ctrip/utils/constants.dart";
import 'package:ctrip/widget/webview.dart';
import 'package:ctrip/model/travel_tab_model.dart';
import 'package:ctrip/model/travel_model.dart';
import 'package:ctrip/dao/travel_tab_dao.dart';
import 'package:ctrip/dao/travel_dao.dart';
import 'package:ctrip/pages/travel_tab_page.dart';

class TravelPage extends StatefulWidget {
  TravelPage({Key key}) : super(key: key);

  @override
  _TravelPageState createState() => _TravelPageState();
}

class _TravelPageState extends State<TravelPage> with TickerProviderStateMixin {
  TabController _controller;
  List<TravelTab> tabs = [];
  TravelTabModel travelTabModel;

  @override
  void initState() {
    _controller = TabController(length: 0, vsync: this);

    TravelTabDao.fetch()
        .then((TravelTabModel model) => {
              _controller =
                  TabController(length: model.tabs.length, vsync: this),
              setState(() {
                tabs = model.tabs;
                travelTabModel = model;
              })
            })
        .catchError((e) => {print(e)});

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: <Widget>[
      Container(
          color: Colors.white,
          padding: EdgeInsets.only(top: 30),
          child: TabBar(
              controller: _controller,
              isScrollable: true,
              labelColor: Colors.black,
              labelPadding: EdgeInsets.fromLTRB(20, 0, 10, 5),
              indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(color: Color(0xff2fcfbb), width: 3),
                  insets: EdgeInsets.only(bottom: 10)),
              tabs: tabs
                  .map<Tab>((TravelTab tab) => Tab(text: tab.labelName))
                  .toList())),
      Flexible(
          child: TabBarView(
              controller: _controller,
              children: tabs.map((TravelTab tab) {
                return TravelTabPage(
                  travelURL: travelTabModel.url,
                  groupChannelCode: tab.groupChannelCode,
                );
              }).toList()))
    ]));
  }
}
