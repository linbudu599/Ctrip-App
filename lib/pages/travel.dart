import "package:flutter/material.dart";

import 'package:ctrip/model/travel_tab_model.dart';
import 'package:ctrip/dao/travel_tab_dao.dart';

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
          padding: EdgeInsets.fromLTRB(3, 20, 3, 5),
          child: TabBar(
              controller: _controller,
              isScrollable: true,
              labelColor: Colors.black,
              labelPadding: EdgeInsets.fromLTRB(15, 0, 15, 5),
              indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(color: Color(0xff2fcfbb), width: 3),
                  insets: EdgeInsets.only(bottom: 10)),
              tabs: tabs
                  .map<Tab>((TravelTab tab) => Tab(
                        child: Text(
                          tab.labelName,
                          textAlign: TextAlign.start,
                        ),
                      ))
                  .toList())),
      Flexible(
          child: TabBarView(
              controller: _controller,
              children: tabs
                  .map((TravelTab tab) => TravelTabPage(
                        travelURL: travelTabModel.url,
                        groupChannelCode: tab.groupChannelCode,
                      ))
                  .toList()))
    ]));
  }
}
