import 'package:ctrip/widget/webview.dart';
import "package:flutter/material.dart";
import "package:ctrip/utils/constants.dart";

class MyPage extends StatefulWidget {
  MyPage({Key key}) : super(key: key);

  @override
  MyPageState createState() => MyPageState();
}

class MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: WebView(
        url: ACCOUNT_PAGE,
        hideAppBar: true,
        backForbid: true,
        statusBarColor: '4c5bca',
      ),
    ));
  }
}
