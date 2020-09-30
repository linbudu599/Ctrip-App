import 'package:flutter/material.dart';
import 'package:ctrip/navigator/tab_navigator.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
    Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ctrip APP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BotNavigationView(),
    );
  }
}
