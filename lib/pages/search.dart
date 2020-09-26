import 'package:ctrip/model/search_model.dart';
import 'package:ctrip/widget/webview.dart';
import "package:flutter/material.dart";
import "package:ctrip/widget/search_bar.dart";
import "package:ctrip/dao/search_dao.dart";

import "package:ctrip/utils/constants.dart";

class SearchPage extends StatefulWidget {
  final bool hideLeft;
  final String searchURL;
  final String keyword;
  final String hint;

  SearchPage(
      {Key key,
      this.hideLeft,
      this.searchURL = SEARCH_URL,
      this.keyword,
      this.hint = SEARCH_HINT})
      : super(key: key);

  @override
  Searchtate createState() => Searchtate();
}

class Searchtate extends State<SearchPage> {
  SearchModel searchModel;
  String keyword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: <Widget>[
      _appBar(),
      MediaQuery.removePadding(
        context: context,
        child: Expanded(
          flex: 1,
          child: ListView.builder(
            itemCount: searchModel?.data?.length ?? 0,
            itemBuilder: (BuildContext context, int idx) {
              return _item(idx);
            },
          ),
        ),
      ),
      InkWell(
          onTap: () {
            // SearchDao.fetch("${widget.searchURL}" + "长城")
            //     .then((SearchModel value) => {print(value.data[0].url)});
          },
          child: Text("Test"))
    ]));
  }

  Widget _appBar() {
    return Column(
      children: <Widget>[
        Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0x66000000), Colors.transparent],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter)),
            child: Container(
              padding: EdgeInsets.only(top: 20),
              height: 80,
              decoration: BoxDecoration(color: Colors.white),
              child: SearchBar(
                hideLeft: widget.hideLeft,
                defaultText: widget.keyword,
                hint: widget.hint,
                handleLeftBtnClick: () {
                  Navigator.pop(context);
                },
                onChanged: _onTextChange,
              ),
            ))
      ],
    );
  }

  void _onTextChange(String text) {
    keyword = text;

    if (text.length == 0) {
      setState(() {
        searchModel = null;
      });
      return;
    }
    String fullURL = SEARCH_URL + text;
    SearchDao.fetch(fullURL, text)
        .then((SearchModel value) => {
              if (value.keyword == keyword)
                setState(() {
                  searchModel = value;
                })
            })
        .catchError((e) {
      print(e);
    });
  }

  Widget _item(int idx) {
    if (searchModel == null || searchModel.data == null) return null;

    SearchItem item = searchModel.data[idx];
    return GestureDetector(
        child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border:
                  Border(bottom: BorderSide(width: 0.3, color: Colors.grey)),
            ),
            child: Row(children: <Widget>[
              Column(children: <Widget>[
                Container(
                  width: 300,
                  child: Text(
                      '${item.word} ${item.districtname ?? ''} ${item.zonename ?? ''}'),
                ),
                Container(
                  width: 300,
                  child: Text('${item.price} ${item.type}'),
                )
              ])
            ])),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WebView(url: item.url, title: "详情")));
        });
  }
}
