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
              Container(
                margin: EdgeInsets.all(1),
                child: Image(
                    height: 26,
                    width: 26,
                    image: AssetImage(_typeImg(item.type))),
              ),
              Column(children: <Widget>[
                Container(
                  width: 300,
                  child: _title(item),
                ),
                Container(
                  width: 300,
                  margin: EdgeInsets.only(top: 5),
                  child: _subTitle(item),
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

  String _typeImg(String type) {
    String defaultPath = "travelgroup";

    if (type == null) return "assets/images/type_$defaultPath.png";
    for (final val in TYPES) {
      if (type.contains(val)) {
        defaultPath = val;
        break;
      }
    }

    return "assets/images/type_$defaultPath.png";
  }

  Widget _title(SearchItem item) {
    if (item == null) return null;

    List<TextSpan> spans = [];
    spans.addAll(_keywordTextSpans(item.word, searchModel.keyword));
    spans.add(TextSpan(
        text: ' ' + (item.districtname ?? '') + ' ' + (item.zonename ?? ''),
        style: TextStyle(fontSize: 16, color: Colors.grey)));
    return RichText(text: TextSpan(children: spans));
  }

  Widget _subTitle(SearchItem item) {
    return RichText(
      text: TextSpan(children: <TextSpan>[
        TextSpan(
          text: item.price ?? '',
          style: TextStyle(fontSize: 16, color: Colors.orange),
        ),
        TextSpan(
          text: ' ' + (item.star ?? ''),
          style: TextStyle(fontSize: 12, color: Colors.grey),
        )
      ]),
    );
  }

  List<TextSpan> _keywordTextSpans(String word, String keyword) {
    List<TextSpan> spans = [];
    if (word == null || word.length == 0) return spans;
    // 搜索关键字高亮忽略大小写
    String wordL = word.toLowerCase(), keywordL = keyword.toLowerCase();
    List<String> arr = wordL.split(keywordL);
    TextStyle normalStyle = TextStyle(fontSize: 16, color: Colors.black87);
    TextStyle keywordStyle = TextStyle(fontSize: 16, color: Colors.orange);
    //'wordwoc'.split('w') -> [, ord, oc] @https://www.tutorialspoint.com/tpcg.php?p=wcpcUA
    int preIndex = 0;
    for (int i = 0; i < arr.length; i++) {
      if (i != 0) {
        // 搜索关键字高亮忽略大小写
        preIndex = wordL.indexOf(keywordL, preIndex);
        spans.add(TextSpan(
            text: word.substring(preIndex, preIndex + keyword.length),
            style: keywordStyle));
      }
      String val = arr[i];
      if (val != null && val.length > 0) {
        spans.add(TextSpan(text: val, style: normalStyle));
      }
    }
    return spans;
  }
}
