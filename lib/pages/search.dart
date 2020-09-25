import "package:flutter/material.dart";
import "package:ctrip/widget/search_bar.dart";

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  @override
  Searchtate createState() => Searchtate();
}

class Searchtate extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(children: <Widget>[
          SearchBar(
            hideLeft: true,
            defaultText: "芜湖!",
            hint: "Hint Here!",
            handleLeftBtnClick: () {
              Navigator.pop(context);
            },
            onChanged: _onTextChange,
          )
        ]));
  }

  void _onTextChange(String text) {}
}
