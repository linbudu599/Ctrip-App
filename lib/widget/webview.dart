import 'dart:async';

import "package:flutter/material.dart";
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

const List<String> INTERCEPT_URLS = [
  'm.ctrip.com/',
  'm.ctrip.com/html5/',
  'm.ctrip.com/html5'
];

class WebView extends StatefulWidget {
  final String url;
  final String statusBarColor;
  final String title;

  final bool hideAppBar;
  final bool backForbid;

  WebView(
      {Key key,
      this.url,
      this.statusBarColor,
      this.title,
      this.hideAppBar,
      this.backForbid = false})
      : super(key: key);

  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  final webViewRef = FlutterWebviewPlugin();
  StreamSubscription<String> _onURLChanged;
  StreamSubscription<WebViewStateChanged> _onStateChanged;
  StreamSubscription<WebViewHttpError> _onHttpError;

  bool exited = false;

  @override
  void initState() {
    super.initState();
    webViewRef.close();
    _onURLChanged = webViewRef.onUrlChanged.listen((String url) {});
    _onStateChanged =
        webViewRef.onStateChanged.listen((WebViewStateChanged state) {
      switch (state.type) {
        case WebViewState.shouldStart:
          // TODO: Handle this case.
          break;
        case WebViewState.startLoad:
          if (hitMainUrl(state.url) && !exited) {
            if (widget.backForbid) {
              webViewRef.launch(widget.url);
            } else {
              Navigator.pop(context);
              exited = true;
            }
          }
          break;
        case WebViewState.finishLoad:
          // TODO: Handle this case.
          break;
        case WebViewState.abortLoad:
          // TODO: Handle this case.
          break;
      }
    });

    _onHttpError = webViewRef.onHttpError.listen((WebViewHttpError error) {
      print(error);
    });
  }

  @override
  void dispose() {
    _onURLChanged.cancel();
    _onStateChanged.cancel();
    _onHttpError.cancel();
    // 销毁webview后才能去销毁页面
    webViewRef.dispose();
    super.dispose();
  }

  bool hitMainUrl(String url) {
    bool hit = false;

    for (final val in INTERCEPT_URLS) {
      if (url?.endsWith(val) ?? false) {
        hit = true;
        break;
      }
    }

    return hit;
  }

  @override
  Widget build(BuildContext context) {
    String statusBarColor = widget.statusBarColor ?? "fff";
    Color backBtnColor = statusBarColor == 'fff' ? Colors.black : Colors.white;

    return Scaffold(
        body: Column(children: <Widget>[
      _appBar(Color(int.parse("0xff" + statusBarColor)), backBtnColor),
      Expanded(
          child: WebviewScaffold(
        url: widget.url,
        withZoom: true,
        withLocalStorage: true,
        hidden: true,
        initialChild: Container(
            color: Colors.white,
            child: Center(
              child: Text("Loading"),
            )),
      ))
    ]));
  }

  _appBar(Color bgColor, Color backBtnColor) {
    if (widget.hideAppBar ?? false) {
      return Container(
        color: bgColor,
        height: 30,
      );
    }

    return Container(
        color: bgColor,
        // padding: EdgeInsets.fromLTRB(0, 40, 0, 10),
        child: FractionallySizedBox(
          widthFactor: 1,
          child: Stack(
            children: <Widget>[
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Icon(Icons.close, color: bgColor, size: 26),
                  )),
              Positioned(
                  left: 0,
                  right: 0,
                  child: Center(
                      child: Text(widget.title ?? "",
                          style: TextStyle(color: bgColor, fontSize: 20))))
            ],
          ),
        ));
  }
}
