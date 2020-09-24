import "package:flutter/material.dart";

import 'package:ctrip/model/common_model.dart';
import 'package:ctrip/widget/webview.dart';

Widget gestureWrapper(BuildContext context, Widget widget, CommonModel model) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => WebView(
                    url: model.url,
                    statusBarColor: model.statusBarColor,
                    hideAppBar: model.hideAppBar,
                  )));
    },
    child: widget,
  );
}
