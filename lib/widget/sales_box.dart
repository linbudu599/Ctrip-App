import "package:flutter/material.dart";

import "package:ctrip/model/common_model.dart";
import "package:ctrip/model/sales_box_model.dart";

import 'package:ctrip/widget/webview.dart';

import 'gesture_wrapper.dart';

// Bot Card(Sales Box)
class SalesBox extends StatelessWidget {
  final SalesBoxModel salesBox;

  const SalesBox({Key key, @required this.salesBox}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: _items(context),
    );
  }

  Widget _items(BuildContext context) {
    List<Widget> items = [];
    if (salesBox == null) return null;

    items.add(_doubleItem(
        context, salesBox.bigCard1, salesBox.bigCard2, true, false));
    items.add(_doubleItem(
        context, salesBox.smallCard1, salesBox.smallCard2, false, false));
    items.add(_doubleItem(
        context, salesBox.smallCard3, salesBox.smallCard4, false, true));

    return Column(children: <Widget>[
      Container(
          height: 44,
          margin: EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(width: 1, color: Color(0xfff2f2f2)))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Image.network(salesBox.icon, height: 15, fit: BoxFit.fill),
              Container(
                padding: EdgeInsets.fromLTRB(10, 1, 8, 1),
                margin: EdgeInsets.only(right: 7),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                        colors: [Color(0xffff4e63), Color(0xffff6cc9)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight)),
                child: GestureDetector(
                  child: Text("获取更多福利 >",
                      style: TextStyle(fontSize: 12, color: Colors.white)),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              WebView(url: salesBox.moreURL, title: "更多活动"),
                        ));
                  },
                ),
              ),
            ],
          )),
      Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: items.sublist(0, 1)),
      Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: items.sublist(1, 2)),
      Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: items.sublist(2, 3)),
    ]);
  }

  Widget _doubleItem(BuildContext context, CommonModel leftCard,
      CommonModel rightCard, bool isMain, bool isLast) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _item(context, leftCard, isMain, true, isLast),
          _item(context, rightCard, isMain, false, isLast)
        ]);
  }

  Widget _item(BuildContext context, CommonModel model, bool isMain,
      bool isLeft, bool isLast) {
    BorderSide borderSide = BorderSide(width: 0.8, color: Color(0xfff2f2f2));

    return gestureWrapper(
        context,
        Container(
          decoration: BoxDecoration(
              border: Border(
                  right: isLeft ? borderSide : BorderSide.none,
                  bottom: isLast ? BorderSide.none : borderSide)),
          child: Image.network(
            model.icon,
            fit: BoxFit.fill,
            width: MediaQuery.of(context).size.width / 2 - 10,
            height: isMain ? 129 : 80,
          ),
        ),
        model);
  }
}
