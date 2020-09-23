import "package:flutter/material.dart";
import "package:ctrip/model/grid_nav_model.dart";

class GridNav extends StatelessWidget {
  const GridNav({Key key, @required this.gridNavModel}) : super(key: key);

  final GridNavModel gridNavModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Grid Nav"),
    );
  }
}
