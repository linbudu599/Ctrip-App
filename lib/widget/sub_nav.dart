import "package:flutter/material.dart";

import 'package:ctrip/model/common_model.dart';
import "package:ctrip/widget/gesture_wrapper.dart";

class SubNav extends StatelessWidget {
  final List<CommonModel> subNavList;

  const SubNav({Key key, @required this.subNavList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(6)),
        child: Padding(
          padding: EdgeInsets.all(7),
          child: _items(context),
        ));
  }

  Widget _items(BuildContext context) {
    List<Widget> items = [];

    if (subNavList == null) return null;

    subNavList.forEach((model) {
      items.add(_item(context, model));
    });

    int len = subNavList.length;
    // 第一行显示数量
    int separator = (len / 2 + 0.5).toInt();
    return Column(children: <Widget>[
      Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: items.sublist(0, separator)),
      Padding(
        padding: EdgeInsets.only(top: 10),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: items.sublist(separator, len)),
      )
    ]);
  }

  Widget _item(BuildContext context, CommonModel model) {
    return Expanded(
        flex: 1,
        child: gestureWrapper(
            context,
            Column(
              children: <Widget>[
                Image.network(
                  model.icon,
                  width: 18,
                  height: 18,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 3),
                  child: Text(
                    model.title,
                    style: TextStyle(fontSize: 12),
                  ),
                )
              ],
            ),
            model));
  }
}
