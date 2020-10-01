import 'package:flutter/material.dart';
import 'package:ctrip/navigator/tab_navigator.dart';

void main() {
  runApp(CtripApp());
}

class CtripApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ctrip APP',
      // 使用ThemeData设置全局主题
      // 或使用Theme()控件单独设置主题
      // 如果只是想改变部分:
      // Theme(
      //  data: Theme.of(context).copyWith(accentColor: Colors.yellow),
      //  child: Text('copyWith method'),
      // );
      // Theme.of(context)会查找Widget树, 返回最近的Theme控件
      // 如果没有, 则返回全局的Theme
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue,
        primaryColorBrightness: Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BotNavigationView(),
    );
  }
}
