import "package:flutter/material.dart";

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  @override
  Searchtate createState() => Searchtate();
}

class Searchtate extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Text("搜索"),
    ));
  }
}
