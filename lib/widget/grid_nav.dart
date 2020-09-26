import "package:flutter/material.dart";

import 'package:ctrip/model/common_model.dart';
import "package:ctrip/model/grid_nav_model.dart";
import "package:ctrip/widget/gesture_wrapper.dart";

class GridNav extends StatelessWidget {
  const GridNav({Key key, @required this.gridNavModel}) : super(key: key);

  final GridNavModel gridNavModel;

  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        clipBehavior: Clip.antiAlias,
        child: Column(children: _gridNavItems(context)));
  }

  _gridNavItems(BuildContext context) {
    List<Widget> items = [];
    if (gridNavModel == null) return items;
    if (gridNavModel.hotel != null) {
      items.add(_gridNavItem(context, gridNavModel.hotel, true));
    }
    if (gridNavModel.flight != null) {
      items.add(_gridNavItem(context, gridNavModel.flight, false));
    }
    if (gridNavModel.travel != null) {
      items.add(_gridNavItem(context, gridNavModel.travel, false));
    }

    return items;
  }

  Widget _gridNavItem(
      BuildContext context, GridNavItem gridNavItem, bool isFirstItem) {
    List<Widget> items = [];
    List<Widget> expandItems = [];

    items.add(_mainItem(context, gridNavItem.mainItem));
    items.add(_doubleItem(context, gridNavItem.item1, gridNavItem.item2));
    items.add(_doubleItem(context, gridNavItem.item3, gridNavItem.item4));

    items.forEach((element) {
      expandItems.add(Expanded(child: element, flex: 1));
    });

    Color startColor = Color(int.parse('0xff' + gridNavItem.startColor));
    Color endColor = Color(int.parse('0xff' + gridNavItem.endColor));

    return Container(
      height: 88,
      margin: isFirstItem ? null : EdgeInsets.only(top: 3),
      decoration: BoxDecoration(

          // 线性渐变
          gradient: LinearGradient(colors: [startColor, endColor])),
      child: Row(children: expandItems),
    );
  }

  Widget _mainItem(BuildContext context, CommonModel model) {
    return gestureWrapper(
        context,
        Stack(alignment: AlignmentDirectional.topCenter, children: <Widget>[
          Image.network(
            model.icon,
            fit: BoxFit.contain,
            height: 88,
            width: 121,
            alignment: AlignmentDirectional.bottomEnd,
          ),
          Container(
            margin: EdgeInsets.only(top: 11),
            child: Text(model.title,
                style: TextStyle(fontSize: 14, color: Colors.white)),
          )
        ]),
        model);
  }

  Widget _doubleItem(
    BuildContext context,
    CommonModel topItem,
    CommonModel bottomItem,
  ) {
    return Column(children: <Widget>[
      Expanded(
        child: _item(context, topItem, true),
      ),
      Expanded(
        child: _item(context, bottomItem, false),
      )
    ]);
  }

  Widget _item(
    BuildContext context,
    CommonModel model,
    bool isFirst,
  ) {
    BorderSide borderSide = BorderSide(width: 0.8, color: Colors.white);

    return FractionallySizedBox(
      widthFactor: 1,
      child: Container(
          decoration: BoxDecoration(
              border: Border(
                  left: borderSide,
                  bottom: isFirst ? borderSide : BorderSide.none)),
          child: gestureWrapper(
              context,
              Center(
                child: Text(model.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.white)),
              ),
              model)),
    );
  }
}
